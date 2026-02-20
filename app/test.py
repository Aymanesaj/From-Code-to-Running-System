from flask import Flask, Response, send_file

app = Flask(__name__, static_folder="static")


@app.route("/")
def home() -> Response:
    return send_file("app.html")


@app.route("/health")
def health() -> tuple[dict[str, str], int]:
    return {"status": "ok"}, 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
