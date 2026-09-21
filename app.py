from flask import Flask, jsonify, render_template
import os
import socket
import urllib.request

app = Flask(__name__)

VERSION = os.getenv("APP_VERSION", "1.0")
ENVIRONMENT = os.getenv("ENVIRONMENT", "UNKNOWN")

def get_metadata(path):
    try:
        req = urllib.request.Request("http://169.254.169.254/latest/api/token", method="PUT")
        req.add_header("X-aws-ec2-metadata-token-ttl-seconds", "21600")
        token = urllib.request.urlopen(req, timeout=1).read().decode()
        
        req2 = urllib.request.Request(f"http://169.254.169.254/latest/meta-data/{path}")
        req2.add_header("X-aws-ec2-metadata-token", token)
        return urllib.request.urlopen(req2, timeout=1).read().decode()
    except Exception:
        return "N/A"

@app.route("/")
@app.route("/dashboard")
def dashboard():
    instance_id = get_metadata("instance-id")
    az = get_metadata("placement/availability-zone")
    hostname = socket.gethostname()
    return render_template("dashboard.html", version=VERSION, environment=ENVIRONMENT.upper(), hostname=hostname, instance_id=instance_id, az=az)

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "environment": ENVIRONMENT.upper(),
        "version": VERSION
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
