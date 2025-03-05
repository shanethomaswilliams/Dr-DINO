from transformers import AutoTokenizer, AutoModel
tokenizer = AutoTokenizer.from_pretrained("Charangan/MedBERT")
model = AutoModel.from_pretrained("Charangan/MedBERT")

print(tokenizer.save_pretrained("./med-bert"))
print(model.save_pretrained("./med-bert"))