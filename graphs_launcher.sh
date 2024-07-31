#!/bin/sh
input_filename_no_extension=$1
path_to_unitex_french_directory=$2 #Must contain Dela/motsGramf-.bin and Dela/Dela_fr.bin
path_to_input_file_directory=$3
path_to_output_directory=$4
path_to_unitex_tool_logger=$5
path_to_graph_to_apply=$6

input_file="$path_to_input_file_directory${input_filename_no_extension}.txt"
snt_directory="${path_to_output_directory}${input_filename_no_extension}_snt"
preprocessed_file_path="${path_to_output_directory}${input_filename_no_extension}.snt"

mkdir "$snt_directory"

"$path_to_unitex_tool_logger/UnitexToolLogger" Normalize "$input_file" "-r$path_to_unitex_french_directory/Norm.txt" "--output_offsets=$snt_directory/normalize.out.offsets" -qutf8-no-bom

mv "$path_to_input_file_directory$input_filename_no_extension.snt" "$preprocessed_file_path"

"$path_to_unitex_tool_logger/UnitexToolLogger" Grf2Fst2 "$path_to_unitex_french_directory/Graphs/Preprocessing/Sentence/Sentence.grf" -y "--alphabet=$path_to_unitex_french_directory/Alphabet.txt" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" Flatten "$path_to_unitex_french_directory/Graphs/Preprocessing/Sentence/Sentence.fst2" --rtn -d5 -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" Fst2Txt "-t$preprocessed_file_path" "$path_to_unitex_french_directory/Graphs/Preprocessing/Sentence/Sentence.fst2" "-a$path_to_unitex_french_directory/Alphabet.txt" -M "--input_offsets=$snt_directory/normalize.out.offsets" "--output_offsets=$snt_directory/normalize.out.offsets" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" Grf2Fst2 "$path_to_unitex_french_directory/Graphs/Preprocessing/Replace/Replace.grf" -y "--alphabet=$path_to_unitex_french_directory/Alphabet.txt" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" Fst2Txt "-t$preprocessed_file_path" "$path_to_unitex_french_directory/Graphs/Preprocessing/Replace/Replace.fst2" "-a$path_to_unitex_french_directory/Alphabet.txt" -R "--input_offsets=$snt_directory/normalize.out.offsets" "--output_offsets=$snt_directory/normalize.out.offsets" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" Tokenize "$preprocessed_file_path" "-a$path_to_unitex_french_directory/Alphabet.txt" "--input_offsets=$snt_directory/normalize.out.offsets" "--output_offsets=$snt_directory/tokenize.out.offsets" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" Dico "-t$preprocessed_file_path" "-a$path_to_unitex_french_directory/Alphabet.txt" "$path_to_unitex_french_directory/Dela/motsGramf-.bin" "$path_to_unitex_french_directory/Dela/Dela_fr.bin" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" SortTxt "$snt_directory/dlf" "-l$snt_directory/dlf.n" "-o$path_to_unitex_french_directory/Alphabet_sort.txt" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" SortTxt "$snt_directory/dlc" "-l$snt_directory/dlc.n" "-o$path_to_unitex_french_directory/Alphabet_sort.txt" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" SortTxt "$snt_directory/err" "-l$snt_directory/err.n" "-o$path_to_unitex_french_directory/Alphabet_sort.txt" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" SortTxt "$snt_directory/tags_err" "-l$snt_directory/tags_err.n" "-o$path_to_unitex_french_directory/Alphabet_sort.txt" -qutf8-no-bom


"$path_to_unitex_tool_logger/UnitexToolLogger" Grf2Fst2 "$path_to_unitex_french_directory/$path_to_graph_to_apply" -y "--alphabet=$path_to_unitex_french_directory/Alphabet.txt" -qutf8-no-bom

fst2_file_path=${path_to_graph_to_apply%.*}.fst2
"$path_to_unitex_tool_logger/UnitexToolLogger" Locate "-t$preprocessed_file_path" "$path_to_unitex_french_directory/$fst2_file_path" "-a$path_to_unitex_french_directory/Alphabet.txt" -L -R --all -b -Y --stack_max=1000 --max_matches_per_subgraph=200 --max_matches_at_token_pos=400 --max_errors=50 -qutf8-no-bom

# "$path_to_unitex_tool_logger/UnitexToolLogger" Concord "$snt_directory/concord.ind" "-m$path_to_output_directory$input_filename_no_extension.xml" -qutf8-no-bom

# "$path_to_unitex_tool_logger/UnitexToolLogger" Normalize "$path_to_output_directory$input_filename_no_extension.xml" "-r$path_to_unitex_french_directory/Norm.txt" -qutf8-no-bom

# "$path_to_unitex_tool_logger/UnitexToolLogger" Tokenize "$path_to_output_directory$input_filename_no_extension.xml" "-a$path_to_unitex_french_directory/Alphabet.txt" -qutf8-no-bom

"$path_to_unitex_tool_logger/UnitexToolLogger" Concord "${snt_directory}/concord.ind" "-fCourier New" -s16 -l40 -r40 --CL --html
mv ${snt_directory}/concord.html ${snt_directory}/${input_filename_no_extension}.html
mv ${snt_directory}/concord.ind ${snt_directory}/${input_filename_no_extension}.ind
