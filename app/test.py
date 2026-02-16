from flask import Flask, send_file

app = Flask(__name__)

@app.route("/")
def hello():
    return send_file("app.html")

@app.route("/health")
def health():
    return "Ok"

app.run(host="0.0.0.0", port=8080)

