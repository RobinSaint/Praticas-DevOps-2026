from flask import Flask, jsonify
import socket, datetime, os

app = Flask (__name__)

@app.route('/')
def index():
    return jsonify({
        "worker": socket.gethostname(),
        "timestamp": datetime.datetime.utcnow().isoformat(),
        "mensagem": "Olá do nó distribuído!"
    })

@app.route('/health')
def health():
    return jsonify ({"status": "ok", "node": socket.gethostname()})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)