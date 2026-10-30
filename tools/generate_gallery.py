#!/usr/bin/env python3
"""Render a picture of every supported part and update the gallery in README.md.

Run this after adding or changing a part in gridfinity_bin_label.scad:

    python3 tools/generate_gallery.py

The part lists are read from the customizer dropdowns in the .scad file, so a
new entry in a dropdown shows up here without touching this script. The
pictures are written to docs/gallery/ and the README section between the
gallery markers is replaced.

Needs OpenSCAD on the PATH (or in the OPENSCAD environment variable). The
manifold backend of recent OpenSCAD versions is used when available, it
renders a label in a fraction of a second.
"""

import os
import re
import shutil
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCAD = os.path.join(ROOT, "gridfinity_bin_label.scad")
README = os.path.join(ROOT, "README.md")
GALLERY_DIR = os.path.join(ROOT, "docs", "gallery")
GALLERY_URL = "docs/gallery"

START_MARKER = "<!-- gallery:start -->"
END_MARKER = "<!-- gallery:end -->"

IMAGE_SIZE = "480,160"
CAMERA = "0,0,0,0,0,0,37"
TABLE_COLUMNS = 3

# Sizes used for the pictures, per category
BOLT_SIZE = ("M5", 16)
NUT_SIZE = "M5"
WASHER_SIZE = "M5"
STANDOFF_SIZE = ("M3", 10)
FURNITURE_SIZE = ("8", 30)
ICON_LENGTH_EXAMPLES = [6, 16, 40]
WASHER_SIZES = {
    "Spacer": ("M5", 5),
}
OTHER_SIZES = {
    "Wall anchor": ("M6", 30),
    "Heat set insert": ("M3", 5),
    "Threaded rod": ("M8", 1000),
    "Compression spring": ("6", 20),
    "None": ("M5", 16),
}

# Defaults used when showing one dropdown on its own
DEFAULT_HEAD = "Pan head"
DEFAULT_DRIVE = "Hex socket"
DEFAULT_TIP = "Machine"

# Dropdown values that are ignored for some heads (see the comments in the .scad file)
HEADS_WITHOUT_DRIVE = ["Hex head"]
HEADS_WITHOUT_TIP = ["Grub screw"]


def dropdown(name):
    """Return the options of a customizer dropdown, e.g. Head = "..."; // [a, b]"""
    with open(SCAD, encoding="utf-8") as f:
        source = f.read()
    match = re.search(r"^\s*" + re.escape(name) + r'\s*=\s*"[^"]*"\s*;\s*//\s*\[([^\]]*)\]', source, re.M)
    if not match:
        sys.exit(f"Dropdown {name} not found in {SCAD}")
    return [option.strip() for option in match.group(1).split(",")]


def slug(*parts):
    return "_".join(re.sub(r"[^a-z0-9]+", "_", p.lower()).strip("_") for p in parts)


def find_openscad():
    openscad = os.environ.get("OPENSCAD") or shutil.which("openscad")
    if not openscad and os.path.exists("/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"):
        openscad = "/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"
    if not openscad:
        sys.exit("OpenSCAD not found, put it on the PATH or set OPENSCAD")
    return openscad


def supports_manifold(openscad):
    result = subprocess.run([openscad, "--help"], capture_output=True, text=True)
    return "--backend" in result.stdout + result.stderr


def scad_string(value):
    return '"' + value.replace('"', '\\"') + '"'


class Picture:
    def __init__(self, file, title, params):
        self.file = file
        self.title = title
        self.params = params

    @property
    def url(self):
        return f"{GALLERY_URL}/{self.file}"


def bolt(head, drive, tip, title):
    diameter, length = BOLT_SIZE
    return Picture(
        f"bolt_{slug(head, drive, tip)}.png",
        title,
        {"Category": "Bolt", "Head": head, "Drive": drive, "Tip": tip,
         "diameter": diameter, "hardware_length": length},
    )


def collect_sections():
    """Return [(heading, intro, pictures, details)], details being a list of (summary, pictures)."""
    heads = dropdown("Head")
    drives = dropdown("Drive")
    tips = dropdown("Tip")
    sections = []

    sections.append((
        "Bolt heads",
        f"Shown with the {DEFAULT_DRIVE.lower()} drive. Every head can be combined with every drive and tip below.",
        [bolt(h, DEFAULT_DRIVE, DEFAULT_TIP, h) for h in heads],
        [],
    ))
    sections.append((
        "Bolt drives",
        f"Shown on a {DEFAULT_HEAD.lower()}. Ignored for hex head bolts.",
        [bolt(DEFAULT_HEAD, d, DEFAULT_TIP, d) for d in drives],
        [],
    ))
    sections.append((
        "Bolt tips",
        f"Shown on a {DEFAULT_HEAD.lower()}. Ignored for grub screws.",
        [bolt(DEFAULT_HEAD, DEFAULT_DRIVE, t, t) for t in tips],
        [],
    ))

    pictures = []
    for mode in dropdown("Icon_length"):
        for length in ICON_LENGTH_EXAMPLES:
            pictures.append(Picture(
                f"icon_length_{slug(mode, str(length))}.png",
                f"{mode}, {BOLT_SIZE[0]}x{length}",
                {"Category": "Bolt", "Head": DEFAULT_HEAD, "Drive": DEFAULT_DRIVE, "Tip": DEFAULT_TIP,
                 "diameter": BOLT_SIZE[0], "hardware_length": length, "Icon_length": mode},
            ))
    sections.append((
        "Icon length",
        "Fixed (the default) draws every part at the same size, the length only shows in the text. "
        "Real length scales the icon with the length, long parts get a split icon.",
        pictures,
        [],
    ))

    combinations = []
    for head in heads:
        pictures = []
        for drive in ([DEFAULT_DRIVE] if head in HEADS_WITHOUT_DRIVE else drives):
            for tip in ([DEFAULT_TIP] if head in HEADS_WITHOUT_TIP else tips):
                title = ", ".join(
                    ([] if head in HEADS_WITHOUT_DRIVE else [drive])
                    + ([] if head in HEADS_WITHOUT_TIP else [tip])
                ) or head
                pictures.append(bolt(head, drive, tip, title))
        combinations.append((f"{head} ({len(pictures)})", pictures))
    total = sum(len(p) for _, p in combinations)
    sections.append((
        "All bolt combinations",
        f"Every head with every drive and tip, {total} in total.",
        [],
        combinations,
    ))

    simple = [
        ("Nuts", "Nut", "Nut_type", NUT_SIZE, None, {}),
        ("Washers", "Washer", "Washer_type", WASHER_SIZE, None, WASHER_SIZES),
        ("Standoffs", "Standoff", "Standoff_type", STANDOFF_SIZE[0], STANDOFF_SIZE[1], {}),
        ("Furniture hardware", "Furniture", "Furniture_type", FURNITURE_SIZE[0], FURNITURE_SIZE[1], {}),
    ]
    for heading, category, variable, diameter, length, sizes in simple:
        pictures = []
        for option in dropdown(variable):
            params = {"Category": category, variable: option, "diameter": diameter}
            if length is not None:
                params["hardware_length"] = length
            if option in sizes:
                params["diameter"], params["hardware_length"] = sizes[option]
            pictures.append(Picture(f"{slug(category, option)}.png", option, params))
        sections.append((heading, "", pictures, []))

    pictures = []
    for option in dropdown("Other_type"):
        params = {"Category": "Other", "Other_type": option}
        if option in OTHER_SIZES:
            params["diameter"], params["hardware_length"] = OTHER_SIZES[option]
        pictures.append(Picture(f"{slug('other', option)}.png", option, params))
    sections.append(("Other", "", pictures, []))

    return sections


def render(openscad, manifold, picture):
    output = os.path.join(GALLERY_DIR, picture.file)
    command = [openscad, "--render", "-o", output,
               "--camera=" + CAMERA, "--projection=o",
               "--imgsize=" + IMAGE_SIZE, "--colorscheme=Tomorrow"]
    if manifold:
        command.append("--backend=manifold")
    for key, value in picture.params.items():
        command += ["-D", f"{key}={scad_string(value) if isinstance(value, str) else value}"]
    command.append(SCAD)
    result = subprocess.run(command, capture_output=True, text=True)
    log = result.stdout + result.stderr
    problems = [line.strip() for line in log.splitlines() if "WARNING" in line or "ERROR" in line]
    if result.returncode != 0 or not os.path.exists(output):
        problems.append(f"OpenSCAD exited with {result.returncode}")
    return picture, problems


def table(pictures):
    lines = ["| " + " | ".join([" "] * TABLE_COLUMNS) + " |",
             "|" + "|".join([":---:"] * TABLE_COLUMNS) + "|"]
    for i in range(0, len(pictures), TABLE_COLUMNS):
        row = pictures[i:i + TABLE_COLUMNS]
        cells = [f'<img src="{p.url}" alt="{p.title}" width="240"><br>{p.title}' for p in row]
        cells += [" "] * (TABLE_COLUMNS - len(row))
        lines.append("| " + " | ".join(cells) + " |")
    return "\n".join(lines)


def markdown(sections):
    out = [
        START_MARKER,
        "<!-- Generated by tools/generate_gallery.py, do not edit by hand. -->",
        "",
    ]
    for heading, intro, pictures, details in sections:
        out.append(f"### {heading}")
        if intro:
            out += ["", intro]
        if pictures:
            out += ["", table(pictures)]
        for summary, detail_pictures in details:
            out += ["", "<details>", f"<summary>{summary}</summary>", "", table(detail_pictures), "", "</details>"]
        out.append("")
    out.append(END_MARKER)
    return "\n".join(out)


def update_readme(section):
    with open(README, encoding="utf-8") as f:
        readme = f.read()
    if START_MARKER not in readme or END_MARKER not in readme:
        sys.exit(f"Gallery markers {START_MARKER} / {END_MARKER} not found in README.md")
    before = readme[:readme.index(START_MARKER)]
    after = readme[readme.index(END_MARKER) + len(END_MARKER):]
    with open(README, "w", encoding="utf-8") as f:
        f.write(before + section + after)


def main():
    openscad = find_openscad()
    manifold = supports_manifold(openscad)
    sections = collect_sections()

    pictures = []
    for _, _, section_pictures, details in sections:
        pictures += section_pictures
        for _, detail_pictures in details:
            pictures += detail_pictures
    unique = list({p.file: p for p in pictures}.values())

    # start from an empty folder so pictures of removed parts disappear
    if os.path.isdir(GALLERY_DIR):
        shutil.rmtree(GALLERY_DIR)
    os.makedirs(GALLERY_DIR)

    failed = False
    with ThreadPoolExecutor(max_workers=os.cpu_count() or 4) as pool:
        for picture, problems in pool.map(lambda p: render(openscad, manifold, p), unique):
            if problems:
                failed = True
                print(f"{picture.file}:", *problems, sep="\n  ")

    update_readme(markdown(sections))
    print(f"Rendered {len(unique)} pictures to {os.path.relpath(GALLERY_DIR, ROOT)} and updated README.md")
    if failed:
        sys.exit(1)


if __name__ == "__main__":
    main()
