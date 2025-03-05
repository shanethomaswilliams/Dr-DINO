module load anaconda
module load cuda/11.6
module load gcc/11.2.0

conda deactivate
conda activate grounding_dino

python /cluster/tufts/cs152l3dclass/mprete01/GroundingDINO/demo/inference_on_a_image.py \
  -c tools/GroundingDINO_SwinT_OGC.py \
  -p /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/output/medbert/training-Dec-07-2024_01-04PM-job10351632/checkpoint_best_regular.pth \
  -i /cluster/tufts/cs152l3dclass/swilli26/train-data/test/4886_0345385436_03_WRI-L2_F009.png \
  -t "fracture" \
  -o output_inference

conda deactivate
