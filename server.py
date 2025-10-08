from flask import Flask, request, jsonify
from flask_cors import CORS
import random
import sqlite3
import datetime

app = Flask(__name__)
CORS(app)

# --- Initialize SQLite Database ---
def init_db():
    conn = sqlite3.connect("payments.db")
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS payments (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    phone TEXT NOT NULL,
                    amount REAL NOT NULL,
                    transaction_id TEXT NOT NULL,
                    timestamp TEXT NOT NULL
                )''')
    conn.commit()
    conn.close()

init_db()

@app.route('/create-payment', methods=['POST'])
def create_payment():
    data = request.get_json()
    phone = data.get('phone')
    amount = data.get('amount')

    if not phone or not amount:
        return jsonify({'message': 'Missing phone or amount'}), 400

    # Generate random transaction ID
    transaction_id = f"TXN{random.randint(100000,999999)}"
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Save to SQLite
    conn = sqlite3.connect("payments.db")
    c = conn.cursor()
    c.execute("INSERT INTO payments (phone, amount, transaction_id, timestamp) VALUES (?, ?, ?, ?)",
              (phone, amount, transaction_id, timestamp))
    conn.commit()
    conn.close()

    return jsonify({
        'message': f'Payment of PKR {amount} from {phone} successful!',
        'transactionId': transaction_id,
        'timestamp': timestamp
    }), 200

@app.route('/transactions', methods=['GET'])
def get_transactions():
    conn = sqlite3.connect("payments.db")
    c = conn.cursor()
    c.execute("SELECT phone, amount, transaction_id, timestamp FROM payments ORDER BY id DESC")
    rows = c.fetchall()
    conn.close()

    transactions = [
        {'phone': row[0], 'amount': row[1], 'transaction_id': row[2], 'timestamp': row[3]}
        for row in rows
    ]
    return jsonify(transactions)

if __name__ == '__main__':
    app.run(debug=True)
