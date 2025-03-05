#!/bin/bash
#SBATCH --partition=gpu           # Partition (queue) name
#SBATCH -n 1                # Number of cores
#SBATCH --time=0-05:00          # Runtime in D-HH:MM
#SBATCH --job-name=open_G_dino      # Job name
#SBATCH --gpus-per-node=1         # Number of GPUs per node
#SBATCH --ntasks=1                  # Total number of tasks
#SBATCH --ntasks-per-node=1         # Tasks per node
#SBATCH --cpus-per-task=4           # CPUs per task
#SBATCH --mem-per-cpu 32000         # Memory per node
#SBATCH --output=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/bert_%x_%j.out          # Standard output log
#SBATCH --error=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/slurm_output/bert_%x_%j.err           # Standard error log
#SBATCH --export=ALL        # Pass any exported env vars to this script and its children

# Load necessary modules or activate a Conda environment
module load anaconda
module load cuda/11.6
module load gcc/11.2.0
conda deactivate
conda activate grounding_dino
# source activate my_conda_env        # Or activate your Conda environment

# Run the Python script
python setup.py build install
python test.py
conda deactivate
