#!/bin/bash
#SBATCH --partition=gpu           # Partition (queue) name
#SBATCH -n 1                # Number of cores
#SBATCH --time=0-00:10          # Runtime in D-HH:MM
#SBATCH --job-name=test_dino      # Job name
#SBATCH --gpus-per-node=1           # Number of GPUs per node
#SBATCH --ntasks=1                  # Total number of tasks
#SBATCH --ntasks-per-node=1         # Tasks per node
#SBATCH --cpus-per-task=4           # CPUs per task
#SBATCH --mem-per-cpu 32000         # Memory per node
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/%x_%j.out          # Standard output log
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/%x_%j.err           # Standard error log
#SBATCH --export=ALL        # Pass any exported env vars to this script and its children

# Check for conda environment name, default to "grounding_dino" if not provided
if [ $# -eq 1 ]; then
    ENV_NAME=$1
else
    ENV_NAME="grounding_dino"
    echo "No conda environment specified. Using default: ${ENV_NAME}"
fi

# Create output directory with timestamp and job ID
OUTPUT_DIR="/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/test-output/test-$(date '+%b-%d-%Y_%I-%M%p')-job${SLURM_JOB_ID}"  # Example: output-Nov-21-2024_02-30PM-job12345
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
python /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/tools/inference_on_a_image.py \
        -c /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/tools/GroundingDINO_SwinT_OGC.py \
        -p /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/bert-output-Nov-23-2024_05-39PM-job9744580/checkpoint_best_regular.pth \
        -i /cluster/tufts/cs152l3dclass/swilli26/sample-train-data/test/4921_0446582201_01_WRI-L1_M008.png \
        -t "boneanomaly . bonelesion . foreignbody . fracture . metal . periostealreaction . pronatorsign . softtissue . text " \
        -o /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/pred_img/test \

# command = [
#     "python", "/content/Open-GroundingDino/tools/inference_on_a_image.py",
#     "-c", config_path,
#     "-p", checkpoint_path,
#     "-i", image_path,
#     "-t", text_prompts,
#     "-o", output_dir+image_file

conda deactivate