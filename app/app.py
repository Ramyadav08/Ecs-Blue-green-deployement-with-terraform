from flask import Flask
import os

app = Flask(__name__)

# Deployment color set via environment variable
DEPLOYMENT_COLOR = os.getenv("DEPLOYMENT_COLOR", "blue")

@app.route("/")
def home():
    if DEPLOYMENT_COLOR.lower() == "green":
        return "<h1 style='color:green;'>This is green deployment</h1>", 200
    else:
        return "<h1 style='color:blue;'>This is blue deployment</h1>", 200

# Health check endpoint for ALB
@app.route("/health")
def health_check():
    return "OK", 200  # Simple response indicating app is healthy

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
