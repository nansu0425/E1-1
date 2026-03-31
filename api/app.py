import os
from flask import Flask, jsonify

app = Flask(__name__)

REDIS_HOST = os.environ.get("REDIS_HOST", "redis")
REDIS_PORT = int(os.environ.get("REDIS_PORT", 6379))


def get_redis():
    import redis
    return redis.Redis(host=REDIS_HOST, port=REDIS_PORT, decode_responses=True)


@app.route("/api/visits")
def visits():
    r = get_redis()
    count = r.incr("visits")
    debug = os.environ.get("FLASK_DEBUG", "0")
    return jsonify({"visits": count, "debug": debug})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
