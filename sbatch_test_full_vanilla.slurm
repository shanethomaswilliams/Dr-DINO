#!/bin/bash
#SBATCH --partition=gpu           # Partition (queue) name
#SBATCH -n 1                      # Number of cores
#SBATCH --time=0-00:15            # Runtime in D-HH:MM
#SBATCH --job-name=test_dino      # Job name
#SBATCH --gpus-per-node=1         # Number of GPUs per node
#SBATCH --ntasks=1                # Total number of tasks
#SBATCH --ntasks-per-node=1       # Tasks per node
#SBATCH --cpus-per-task=4         # CPUs per task
#SBATCH --mem-per-cpu=32000       # Memory per CPU
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output_eval/%x_%j.out  # Standard output log
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output_eval/%x_%j.err   # Standard error log
#SBATCH --export=ALL              # Pass any exported env vars to this script and its children

# Check if required arguments are provided
if [ $# -ne 1 ]; then
    echo "Usage: sbatch sbatch_test.slurm <encoder-type>"
    exit 1
fi

# Parse arguments
ENCODER_TYPE=$1

OUTPUT_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/results/${ENCODER_TYPE}/evaluation_vanilla"  # Example: output-Nov-21-2024_02-30PM-job12345
echo "Creating output directory: ${OUTPUT_DIR}"

echo "Slurm Job ID: ${SLURM_ID}"
echo "Text Encoder: ${ENCODER_TYPE}"

# Create the output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

# Load required modules and activate conda environment
module load anaconda
conda deactivate
module load cuda/11.6
module load gcc/11.2.0
conda activate grounding_dino
conda list

# Run zero-shot evaluation
python -u main.py \
    --output_dir ${OUTPUT_DIR}/finetuned \
    -c /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/cfg_odvg.py \
    --datasets /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/med_ft_test.json \
    --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/dino_model/groundingdino_swint_ogc.pth \
    --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/${ENCODER_TYPE}_weights \
    --eval \

Check the exit status of the first Python call
if [ $? -ne 0 ]; then
    echo "First Python script failed."
else
    echo "First Python script completed successfully."
fi

python -u main.py \
    --output_dir ${OUTPUT_DIR}/zero-shot \
    -c /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/cfg_odvg_zstest.py \
    --datasets /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/med_zs_test.json \
    --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/dino_model/groundingdino_swint_ogc.pth \
    --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/medbert_weights \
    --eval \
    
# Check the exit status of the second Python call
if [ $? -ne 0 ]; then
    echo "Second Python script failed."
else
    echo "Second Python script completed successfully."
fi

conda deactivate

# Check the status of the script
if [ $? -ne 0 ]; then
    echo "Python script failed."
else
    echo "Python script completed successfully."
fi

# Deactivate conda environment
conda deactivate
