from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello"

@app.route("/health")
def health():
    return "Ok"

app.run(host="0.0.0.0", port=8080)
