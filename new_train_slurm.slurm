#!/bin/bash
#SBATCH --partition=gpu           # Partition (queue) name
#SBATCH --gres=gpu:5
#SBATCH --ntasks 5               # Number of cores
#SBATCH --ntasks-per-node=5        # Tasks per node
#SBATCH --cpus-per-task=5           # CPUs per task
#SBATCH --mem=64G       # Memory per node
#SBATCH --time=0-12:00          # Runtime in D-HH:MM
#SBATCH --job-name=bert_open_G_dino      # Job name
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/dist-test/bert.out
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/dist-test/bert.err
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/bert_%x_%j.out
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/bert_%x_%j.err
#SBATCH --export=ALL        # Pass any exported env vars to this script and its children

PARTITION="gpu"
GPUS=5
GPUS_PER_NODE=5
CPUS_PER_TASK=5

# Create output directory with timestamp and job ID
OUTPUT_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/bert/training-$(date '+%b-%d-%Y_%I-%M%p')-job${SLURM_JOB_ID}"  # Example: output-Nov-21-2024_02-30PM-job12345
echo "Creating output directory: ${OUTPUT_DIR}"

if [ $# -eq 1 ]; then
    ENV_NAME=$1
else
    ENV_NAME="grounding_dino"
    echo "No conda environment specified. Using default: ${ENV_NAME}"
fi

# Create the directory
mkdir -p ${OUTPUT_DIR}

# Load required modules and activate conda environment
module load anaconda
conda deactivate
module load cuda/11.6
module load gcc/11.2.0
conda activate ${ENV_NAME}

srun -p ${PARTITION} \
    --job-name=open_G_dino \
    --gres=gpu:${GPUS_PER_NODE} \
    --ntasks=${GPUS} \
    --ntasks-per-node=${GPUS_PER_NODE} \
    --cpus-per-task=${CPUS_PER_TASK} \
    --mem=64G \
    --time=12:00:00 \
    --output=${OUTPUT_DIR}/bert.out \
    --error=${OUTPUT_DIR}/bert.err \
    --kill-on-bad-exit=1 \
    python -u main.py \
    --output_dir ${OUTPUT_DIR} \
    -c /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/cfg_odvg.py \
    --datasets /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/config/med_mixed.json \
    --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/dino_model/groundingdino_swint_ogc.pth \
    --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/vanilla-weights/bert_weights \
