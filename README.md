This repo contains a few scripts to launch and test Unitex graphs from the command line. It uses the Unitex CLI tool `UnitexToolLogger`.

Due to the way UnitexToolLogger works, there are quite a few arguments required. They are conviniently named [in the shell script](./temporal_adverbial_annotator.sh) If you are on MacOS, you typically have two Unitex directories, which have different dictionnaries. You should use the one which contains the Dela/motsGramf-.bin and the Dela/Dela_fr.bin dictionnaries. It is normally located at /Applications/Unitex-GramLab-3.3/French/.
When Unitex applies graphs to a text, it creates an snt folder which contains the results. You can specify where you want this output to be located. The two files of interest are `concord.ind` and `concord.html`, which contain the matches and which this script renames based on the input file name for convinience. 

The [`unitextools.py`](./unitextools.py) script contains a few functions to run the shell script and extract the matches. Beware that your graphs output should have a <chaine> tag for it to work (ex : <chaine>le 27 février 2023</chaine>). This is not convinient but it matched my needs. I might rework it in the future.

The [`evaluation.py`](./evaluation.py) script compares the matches with a gold text file and writes false positives and false negatives in the selected folders. 
