from unitextools import (
    extract_matches,
    run_subprocess,
    make_directories_if_not_exist,
    write_to_file
)
from pathlib import Path
from typing import List

def evaluate_results(matches: List[str],gold_file: Path):
    with open(gold_file, "r") as f:
        gold = f.read().split("\n")
    gold = [match.lower() for match in gold]
    chaines = [chaine.lower() for chaine in matches]
    chaines = set(chaines)
    gold = set(gold)
    false_positives = list(chaines - gold)
    false_negatives = list(gold - chaines)
    print("chaine",chaines)
    return false_negatives, false_positives


def main(
    input_file: Path,
    unitex_french_directory: Path,
    output_file_directory: Path,
    unitex_tool_logger: Path,
    shell_script: Path,
    gold_file: Path,
    false_positives_folder: Path,
    false_negatives_folder: Path,
    matches_folder: Path,
    paht_to_graph_to_apply: Path
):

    make_directories_if_not_exist([output_file_directory])
    run_subprocess(
        input_file,
        unitex_french_directory,
        output_file_directory,
        unitex_tool_logger,
        shell_script,
        path_to_graph_to_apply,
    )
    input_file_stem = input_file.stem
    output_snt_folder = f"{output_file_directory}/{input_file_stem}_snt/"
    matches = extract_matches(f"{output_snt_folder}/{input_file_stem}.ind")
    chaines = [match[1] for match in matches]
    false_negatives, false_positives = evaluate_results(chaines, gold_file)
    write_to_file(
        text="\n".join(false_negatives),
        input_name=f"faux_negatifs_{input_file_stem}",
        folder=false_negatives_folder,
    )
    write_to_file(
        text="\n".join(false_positives),
        input_name=f"faux_positifs_{input_file_stem}",
        folder=false_positives_folder,
    )
    write_to_file(
        text="\n".join(chaines),
        input_name=input_file_stem,
        folder=matches_folder,
    )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("input_file", type=Path)
    parser.add_argument("gold", type=Path)
    parser.add_argument(
        "-ufd",
        "--unitex-french-directory",
        type=Path,
        default="/Applications/Unitex-GramLab-3.3/French/",
    )
    parser.add_argument(
        "-ofd", "--output-file-directory", type=Path, default="../../Outputs/"
    )
    parser.add_argument(
        "-utl",
        "--unitex-tool-logger",
        type=Path,
        default="/Applications/Unitex-GramLab-3.3/App/",
    )
    parser.add_argument(
        "-s", "--shell-script", type=Path, default="./temporal_adverbial_annotator.sh"
    )
    parser.add_argument(
        "-fn",
        "--false-negatives-folder",
        type=Path,
        default="../../Evaluation/FauxNegatifs/",
    )
    parser.add_argument(
        "-fp",
        "--false-positives-folder",
        type=Path,
        default="../../Evaluation/FauxPositifs/",
    )
    parser.add_argument(
        "-m", "--matches-folder", type=Path, default="../../Evaluation/Matches/"
    )
    parser;add_argument(
        "-g",
        "--graph-to-apply",
        type=Path,
        default="Graphs/Graphes_Charles_Menel/_Main_.grf",
    )
    args = parser.parse_args()

    main(
        args.input_file,
        args.unitex_french_directory,
        args.output_file_directory,
        args.unitex_tool_logger,
        args.shell_script,
        args.gold,
        args.false_positives_folder,
        args.false_negatives_folder,
        args.matches_folder,
        args.graph_to_apply
    )
