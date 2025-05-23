#!/bin/sh
PARTITION=$1
GPUS=$2
GPUS_PER_NODE=$(($2<8?$2:8))
CPUS_PER_TASK=${CPUS_PER_TASK:-1}
CFG=$3
DATASETS=$4
OUTPUT_DIR=$5


srun -p ${PARTITION} \
    --job-name=open_G_dino \
    --gres=gpu:${GPUS_PER_NODE} \
    --ntasks=${GPUS} \
    --ntasks-per-node=${GPUS_PER_NODE} \
    --cpus-per-task=${CPUS_PER_TASK} \
    --kill-on-bad-exit=1 \
    python -u main.py --output_dir ${OUTPUT_DIR} \
        -c ${CFG} \
        --datasets ${DATASETS}  \
        --pretrain_model_path /cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/dino_weights/groundingdino_swint_ogc.pth \
        --options text_encoder_type=/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/bert_weights
