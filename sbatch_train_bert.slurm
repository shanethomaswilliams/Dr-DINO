#!/bin/bash
#SBATCH -p gpu
#SBATCH --job-name=bert_open_G_dino \
#SBATCH --gres=gpu:a100:8 \
#SBATCH --ntasks=1 \
#SBATCH --ntasks-per-node=8 \
#SBATCH --cpus-per-task=4 \
#SBATCH --mem=32G \
#SBATCH --time=11:00:00 \
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/bert/bert_%x_%j.out          # Standard output log
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/bert/bert_%x_%j.err           # Standard error log
#SBATCH --export=ALL        # Pass any exported env vars to this script and its children
# Check for conda environment name, default to "grounding_dino" if not provided
if [ $# -eq 1 ]; then
    ENV_NAME=$1
else
    ENV_NAME="grounding_dino"
    echo "No conda environment specified. Using default: ${ENV_NAME}"
fi

# Create output directory with timestamp and job ID
OUTPUT_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/bert-output-$(date '+%b-%d-%Y_%I-%M%p')-job${SLURM_JOB_ID}"  # Example: output-Nov-21-2024_02-30PM-job12345
echo "Creating output directory: ${OUTPUT_DIR}"

# Create the directory
mkdir -p ${OUTPUT_DIR}

# Load required modules and activate conda environment
module load anaconda
conda deactivate
module load cuda/11.6
module load gcc/11.2.0
conda activate ${ENV_NAME}
nvidia-smi
# Run the training script
python -u main.py \
    --output_dir ${OUTPUT_DIR} \
    -c /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/cfg_odvg.py \
    --datasets /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/med_mixed.json \
    --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/dino_model/groundingdino_swint_ogc.pth \
    --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/bert_weights \

conda deactivate
