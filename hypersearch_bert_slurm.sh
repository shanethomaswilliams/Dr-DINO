#!/bin/sh

fileToCopy="config/hypersearch/cfg_odvg.py"
START="config/hypersearch/cfg_odvg"
END=".py"
for i in $(seq 1 3);
do
    #Create a new config file based of iteration
    copiedName="${START}${i}${END}"
    echo $copiedName
    cp $fileToCopy $copiedName
    
    #Generate a random LR from 0.0001 - 0.005
    random_LR=$(awk -v seed=$RANDOM 'BEGIN {srand(seed); print rand() }')
    scaled_LR=$(awk "BEGIN {printf $random_LR * 0.01 + 0.0001}")
    truncated_LR=$(awk 'BEGIN {printf "%.4f\n", '$scaled_LR'}')
    
    #Edit the config file to have the right line    
    NEWLINELR="lr = $truncated_LR"
    echo $NEWLINELR
    sed -i "49s/.*/$NEWLINELR/" $copiedName

    #Generate a random Weight Decay from 0.0001 - 0.008
    random_WD=$(awk -v seed=$RANDOM 'BEGIN {srand(seed); print rand() }')
    scaled_WD=$(awk "BEGIN {printf $random_WD * 0.0079 + 0.0001}")
    truncated_WD=$(awk 'BEGIN {printf "%.4f\n", '$scaled_WD'}')
    
    #Edit the config file to have the right line
    NEWLINEWD="weight_decay = $truncated_WD"
    echo $NEWLINEWD
    sed -i "56s/.*/$NEWLINEWD/" $copiedName

    #Generate a random Fusion Drop from 0.1 - 0.5
    random_DP=$(awk -v seed=$RANDOM 'BEGIN {srand(seed); print rand() }')
    scaled_DP=$(awk "BEGIN {printf $random_DP * 0.4 + 0.1}")
    truncated_DP=$(awk 'BEGIN {printf "%.1f\n", '$scaled_DP'}')
    
    #Edit the config file to have the right line
    NEWLINEDP="fusion_droppath = $truncated_DP"
    echo $NEWLINEDP
    sed -i "46s/.*/$NEWLINEDP/" $copiedName

    export configName=$copiedName
    #HERE
    sbatch < train_bert.slurm 
done
