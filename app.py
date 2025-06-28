import threading
import time
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


def run_sniping(interval: float, max_attempts: int) -> None:
    """Simulate ticket sniping attempts."""
    for attempt in range(1, max_attempts + 1):
        timestamp = datetime.now().isoformat()
        print(f"Attempt {attempt} at {timestamp}")
        time.sleep(interval)


@app.route('/start', methods=['POST'])
def start_sniping():
    """Start the ticket sniping process in a background thread."""
    try:
        data = request.get_json(force=True)
        interval = float(data['interval'])
        max_attempts = int(data['max_attempts'])

        thread = threading.Thread(target=run_sniping, args=(interval, max_attempts), daemon=True)
        thread.start()

        return jsonify({'status': 'started'}), 200
    except Exception as exc:
        return jsonify({'error': str(exc)}), 400


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
