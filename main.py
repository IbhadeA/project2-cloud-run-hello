from flask import Flask
import os

app = Flask(__name__)

@app.get("/")
def root():
    service = os.environ.get("K_SERVICE", "local")
    region = os.environ.get("GOOGLE_CLOUD_REGION", "local")
    return f"Hello from Cloud Run! Service={service}, Region={region}\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
