from flask import Flask, request, jsonify, render_template
import requests

app = Flask(__name__)

# Rasa server URL (adjust if different)
RASA_URL = "http://localhost:5005/webhooks/rest/webhook"

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/chat", methods=["POST"])
def chat():
    user_message = request.json.get("message")
    if not user_message:
        return jsonify({"error": "No message provided"}), 400

    response = requests.post(RASA_URL, json={"sender": "user", "message": user_message})

    if response.status_code != 200:
        return jsonify({"error": "Failed to connect to Rasa"}), 500

    bot_messages = response.json()
    messages = [msg.get("text", "") for msg in bot_messages]
    return jsonify({"messages": messages})

if __name__ == "__main__":
    app.run(debug=True)
