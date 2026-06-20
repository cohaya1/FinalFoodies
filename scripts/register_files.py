#!/usr/bin/env python3
"""
Register new Swift files in FinalFoodies.xcodeproj/project.pbxproj.

The project uses classic Xcode groups (objectVersion = 55), so every new file
must be added in four places: PBXBuildFile, PBXFileReference, a PBXGroup's
children, and a PBXSourcesBuildPhase. This script automates that for the
CraveCart groups created in the first slice.

Usage: edit APP_FILES / TEST_FILES below with (uuid_index, basename, relpath),
pick fresh UUID prefixes that don't collide with existing ones, then run:

    python3 scripts/register_files.py

It is idempotent-ish only in that it asserts it changed something; it does NOT
detect already-registered files, so add each file exactly once. Always verify
brace/paren balance afterwards (the script prints it).
"""

PBX = "FinalFoodies.xcodeproj/project.pbxproj"

# CraveCart group UUIDs (created in slice 1 — do not change).
APP_GROUP = "CAFE09000000000000000001"
TST_GROUP = "CAFE09000000000000000002"
# Sources build phases.
APP_SOURCES_MARKER = "9883233127B8A2A90052859D /* FinalFoodiesApp.swift in Sources */,"
TST_SOURCES_MARKER = "989179292A21A39D008B179A /* FoodiesTests.swift in Sources */,"

# Fill these in for the slice you are registering. `idx` is a 2-char suffix used
# to build a unique UUID; bump the prefix (CAFE04.., CAFE05..) per slice so they
# never collide. (idx, basename, relpath-from-group)
APP_FILES: list[tuple[str, str, str]] = [
    # ("01", "Foo.swift", "Domain/Models/Foo.swift"),
]
TEST_FILES: list[tuple[str, str, str]] = [
    # ("01", "FooTests.swift", "FooTests.swift"),
]
# UUID prefixes for THIS run (must be unused). 24 hex chars total.
APP_FR = lambda n: f"CAFE04{n}0000000000000000"
APP_BF = lambda n: f"CAFE05{n}0000000000000000"
TST_FR = lambda n: f"CAFE06{n}0000000000000000"
TST_BF = lambda n: f"CAFE07{n}0000000000000000"


def main() -> None:
    if not APP_FILES and not TEST_FILES:
        raise SystemExit("Nothing to register: fill in APP_FILES / TEST_FILES.")

    with open(PBX) as f:
        c = orig = f.read()

    bf = [f"\t\t{APP_BF(n)} /* {b} in Sources */ = {{isa = PBXBuildFile; fileRef = {APP_FR(n)} /* {b} */; }};" for n, b, _ in APP_FILES]
    bf += [f"\t\t{TST_BF(n)} /* {b} in Sources */ = {{isa = PBXBuildFile; fileRef = {TST_FR(n)} /* {b} */; }};" for n, b, _ in TEST_FILES]
    if bf:
        c = c.replace("/* End PBXBuildFile section */", "\n".join(bf) + "\n/* End PBXBuildFile section */", 1)

    ref = [f"\t\t{APP_FR(n)} /* {b} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {p}; sourceTree = \"<group>\"; }};" for n, b, p in APP_FILES]
    ref += [f"\t\t{TST_FR(n)} /* {b} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {p}; sourceTree = \"<group>\"; }};" for n, b, p in TEST_FILES]
    if ref:
        c = c.replace("/* End PBXFileReference section */", "\n".join(ref) + "\n/* End PBXFileReference section */", 1)

    # Add to group children (insert before the group's children-closing paren).
    def add_to_group(content: str, group_uuid: str, entries: list[str]) -> str:
        anchor = f"{group_uuid} /* CraveCart */ = {{"
        start = content.index(anchor)
        close = content.index("\t\t\t);", start)
        block = "".join(f"\t\t\t\t{e}\n" for e in entries)
        return content[:close] + block + content[close:]

    if APP_FILES:
        c = add_to_group(c, APP_GROUP, [f"{APP_FR(n)} /* {b} */," for n, b, _ in APP_FILES])
    if TEST_FILES:
        c = add_to_group(c, TST_GROUP, [f"{TST_FR(n)} /* {b} */," for n, b, _ in TEST_FILES])

    # Add to Sources build phases.
    def add_sources(content: str, marker: str, entries: list[str]) -> str:
        idx = content.index(marker)
        close = content.index("\t\t\t);", idx)
        block = "".join(f"\t\t\t\t{e}\n" for e in entries)
        return content[:close] + block + content[close:]

    if APP_FILES:
        c = add_sources(c, APP_SOURCES_MARKER, [f"{APP_BF(n)} /* {b} in Sources */," for n, b, _ in APP_FILES])
    if TEST_FILES:
        c = add_sources(c, TST_SOURCES_MARKER, [f"{TST_BF(n)} /* {b} in Sources */," for n, b, _ in TEST_FILES])

    assert c != orig, "no changes made"
    with open(PBX, "w") as f:
        f.write(c)
    print("pbxproj updated.")
    print("balance: {", c.count("{"), "} ", c.count("}"), "( ", c.count("("), ") ", c.count(")"))


if __name__ == "__main__":
    main()
