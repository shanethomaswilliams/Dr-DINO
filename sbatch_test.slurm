#!/bin/bash
#SBATCH --partition=gpu           # Partition (queue) name
#SBATCH -n 1                # Number of cores
#SBATCH --time=0-00:02          # Runtime in D-HH:MM
#SBATCH --job-name=test_dino      # Job name
#SBATCH --gpus-per-node=1           # Number of GPUs per node
#SBATCH --ntasks=1                  # Total number of tasks
#SBATCH --ntasks-per-node=1         # Tasks per node
#SBATCH --cpus-per-task=4           # CPUs per task
#SBATCH --mem-per-cpu 32000         # Memory per node
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/test/%x_%j.out          # Standard output log
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/test/%x_%j.err           # Standard error log
#SBATCH --export=ALL        # Pass any exported env vars to this script and its children

# Check for conda environment name, default to "grounding_dino" if not provided
if [ $# -eq 1 ]; then
    ENV_NAME=$1
else
    ENV_NAME="grounding_dino"
    echo "No conda environment specified. Using default: ${ENV_NAME}"
fi

# OUTPUT_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/shane-test/
# Create output directory with timestamp and job ID
OUTPUT_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output-test/bert/old-test-$(date '+%b-%d-%Y_%I-%M%p')-job${SLURM_JOB_ID}"  # Example: output-Nov-21-2024_02-30PM-job12345
echo "Creating output directory: ${OUTPUT_DIR}"

# Create the directory
mkdir -p ${OUTPUT_DIR}

# Load required modules and activate conda environment
module load anaconda
conda deactivate
module load cuda/11.6
module load gcc/11.2.0
conda activate ${ENV_NAME}
conda list

# Running test for 
python -u main.py \
    --output_dir ${OUTPUT_DIR}/finetuned \
    -c //cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/medbert/training-Dec-08-2024_01-05AM-job10352917/config_cfg.py \
    --datasets /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/med_ft_test.json \
    --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/medbert/training-Dec-08-2024_01-05AM-job10352917/checkpoint_best_regular.pth \
    --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/medbert_weights \
    --eval \
    --resume /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/medbert/training-Dec-08-2024_01-05AM-job10352917/checkpoint_best_regular.pth

Check the exit status of the first Python call
if [ $? -ne 0 ]; then
    echo "First Python script failed."
else
    echo "First Python script completed successfully."
fi

# python -u main.py \
#     --output_dir ${OUTPUT_DIR}/zero-shot \
#     -c /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/cfg_odvg_zstest.py \
#     --datasets /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/med_zs_test.json \
#     --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/bert-output-Nov-23-2024_05-39PM-job9744580/checkpoint_best_regular.pth \
#     --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/bert_weights \
#     --eval

# Check the exit status of the second Python call
if [ $? -ne 0 ]; then
    echo "Second Python script failed."
else
    echo "Second Python script completed successfully."
fi

conda deactivate