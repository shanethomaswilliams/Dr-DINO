import torch
import numpy as np

eval_paths = ["/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/results/medbert/evaluation_10352917/finetuned/eval.pth",
             "/cluster/tufts/cs152l3dclass/mprete01/Medical-Grounding-DINO/results/bert/evaluation_10362741/finetuned/eval.pth"]
for i, eval_path in enumerate(eval_paths):
    coco_eval_data = torch.load(eval_path, map_location="cpu")
    print("Loaded eval data keys:", coco_eval_data.keys())  

    precision = coco_eval_data["precision"]  # Shape: (IoU, Recall, Category, Area, MaxDet)
    params = {
        "IoU": np.linspace(0.5, 0.95, 10),
        "maxDet": 100,
    }

    print("Precision shape:", precision.shape)

    # Iterate over categories (class-level AP)
    num_classes = precision.shape[2]
    results_per_class = {}

    for class_idx in range(num_classes):
        class_precision = precision[:, :, class_idx, 0, -1]  # AP for IoU=0.5:0.95, area=all, maxDet=100
        class_AP = class_precision[class_precision > -1].mean()  # Filter invalid (-1)
        results_per_class[f"Class_{class_idx}"] = class_AP

    if i == 0:
        print("MEDBERT: ")
    else:
        print("BERT: ")

    # Print results
    for class_name, AP in results_per_class.items():
        print(f"{class_name}: AP = {AP:.8f}")