import re
from pathlib import Path
import subprocess
from sys import stderr


def extract_matches(file: str) -> list[tuple]:
    with open(file, "r") as f:
        lines = f.readlines()
    matches = []
    for line in lines[1::]:
        ut = re.search(r"<UT.*</UT>", line)
        ut = ut.group(0) if ut else None
        chaine = re.search(r"<Chaine>(.*)</Chaine>", line)
        chaine=chaine.group(1) if chaine else None
        matches.append((ut, chaine))
    return matches



def write_to_file(text: str, input_name: str, folder: Path):
    if not text:
        stderr.write(f"nothing to write in {folder} folder.")
        return None
    path = Path(f"{folder}/{input_name}.txt")
    with open(path, "w") as f:
        f.write(text)


def make_directories_if_not_exist(directories: list[Path]):
    for directory in directories:
        if not directory.exists():
            directory.mkdir()


def run_subprocess(
    input_file: Path,
    unitex_french_directory: Path,
    output_file_directory: Path,
    unitex_tool_logger: Path,
    shell_script: Path,
    path_to_graph_to_apply: Path,
):
    input_filename_no_ext = input_file.stem
    input_file_directory = f"{input_file.parent}/"
    subprocess.run(
        [
            "bash",
            shell_script,
            input_filename_no_ext,
            unitex_french_directory,
            input_file_directory,
            f"{output_file_directory}/",
            unitex_tool_logger,
            path_to_graph_to_apply,
        ]
    )
