#!/bin/bash

# Base directories
BASE_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output"
ENCODER_TYPE="bert"  # Default encoder type; change as needed

# Iterate over bert and medbert directories
for model_type in "bert" "medbert"; do
    for sub_dir in ${BASE_DIR}/${model_type}/*; do
        if [ -d "$sub_dir" ]; then
            echo "${sub_dir}"
            # Extract job ID from the directory name
            job_id=$(basename "$sub_dir")
            slurm_id=$(echo "$job_id" | grep -oP '(?<=job)\d+$')
            echo "  - SLURM JOB ID: ${slurm_id}"
            # Set the encoder type based on the parent directory
            if [[ "$model_type" == "bert" ]]; then
                ENCODER_TYPE="bert"
            else
                ENCODER_TYPE="medbert"
            fi

            # Path to the model checkpoint
            model_checkpoint="${sub_dir}/checkpoint_best_regular.pth"
            echo "  - MODEL CHECKPOINT: ${model_checkpoint}"
            echo "  - ENCODER TYPE: ${ENCODER_TYPE}"
            echo ""

            # Submit the job using sbatch
            sbatch sbatch_test_full.slurm "${model_checkpoint}" "${slurm_id}" "${ENCODER_TYPE}"
        fi
    done
done