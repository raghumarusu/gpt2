from transformers import GPT2LMHeadModel, GPT2Tokenizer
from qdrant_client import QdrantClient
import os

# Load GPT-2 model and tokenizer
def load_gpt2_model():
    model_name = "gpt2"
    model = GPT2LMHeadModel.from_pretrained(model_name)
    tokenizer = GPT2Tokenizer.from_pretrained(model_name)
    return model, tokenizer

# Function to generate text using GPT-2
def generate_text(prompt, model, tokenizer):
    inputs = tokenizer.encode(prompt, return_tensors="pt")
    outputs = model.generate(inputs, max_length=100, num_return_sequences=1)
    return tokenizer.decode(outputs[0], skip_special_tokens=True)

# Interacting with Qdrant
def connect_qdrant():
    qdrant_host = os.getenv("QDRANT_HOST", "localhost")
    qdrant_port = int(os.getenv("QDRANT_PORT", "6333"))
    client = QdrantClient(host=qdrant_host, port=qdrant_port)
    return client

def main():
    model, tokenizer = load_gpt2_model()
    client = connect_qdrant()

    prompt = "Once upon a time"
    generated_text = generate_text(prompt, model, tokenizer)
    print(f"Generated Text: {generated_text}")

if __name__ == "__main__":
    main()
