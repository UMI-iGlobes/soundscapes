for file in final_sounds/*.wav;
do

FILE=$(echo "$f" | awk -F'[/.]' '{print $(NF-1)}');
FOLDER=$(echo "$FILE" | awk -F'[.]' '{print $(NF-1)}');
OUTPUT=output/$FOLDER.csv

qsub sound_calc.pbs "FOLDER" "OUTPUT"

done