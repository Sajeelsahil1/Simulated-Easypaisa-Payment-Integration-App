# 💳 Simulated Easypaisa Payment Integration App

A **Flutter + Flask** project that simulates Easypaisa-style payment processing.
This app demonstrates how to integrate payment APIs (real or simulated) with a Flutter front-end and a Flask backend.

---

## 🚀 Features

✅ Flutter-based responsive UI (Material Design)
✅ Flask backend for payment handling
✅ SQLite database for transaction storage
✅ Ngrok integration for testing APIs on mobile
✅ Realistic payment simulation with success/failure responses

---

## 🧠 Tech Stack

| Technology         | Description                                      |
| ------------------ | ------------------------------------------------ |
| **Flutter**        | Front-end mobile app                             |
| **Flask (Python)** | Backend API server                               |
| **SQLite**         | Local database for storing transactions          |
| **Ngrok**          | Tunneling service for API access on real devices |
| **HTTP**           | Communication between Flutter & Flask            |

---

## 📸 Screenshots

### 🏠 Home Page UI
![Home Page](screenshots/home%20page%20ui.PNG)

### 💰 Payment Successful UI
![Payment Successful](screenshots/payment%20successful%20ui.PNG)

### 🧾 Transaction History Page
![Transaction History](screenshots/transaction%20history%20page.PNG)


---

## ⚙️ Setup Instructions

### 🔹 1. Clone this Repository

```bash
git clone https://github.com/Sajeelsahil1/Simulated-Easypaisa-Payment-Integration-App.git
cd Simulated-Easypaisa-Payment-Integration-App
```

### 🔹 2. Backend Setup (Flask)

```bash
cd server
pip install -r requirements.txt
python app.py
```

Once it’s running locally (usually on port `5000`), start **ngrok**:

```bash
ngrok http 5000
```

Copy your ngrok URL (example: `https://225f3d9762e7.ngrok-free.app`) and update it in Flutter’s `main.dart` file.

---

### 🔹 3. Frontend Setup (Flutter)

```bash
cd flutter_app
flutter pub get
flutter run
```

---

## 💾 Database

All payments are stored in a local **SQLite database** (`payments.db`).
It includes columns for:

* `id`
* `phone`
* `amount`
* `transaction_id`
* `status`
* `timestamp`

---

## 🔐 Future Scope

* 🔸 Integration with **real Easypaisa API** (via sandbox credentials)
* 🔸 Add **user authentication** (JWT)
* 🔸 Add **payment history UI**
* 🔸 Integrate **Push Notifications** for payment success/failure

---

## 🧑‍💻 Author

**Sajeel Sahil**
📧 sajeelsahil8@gmail.com
🌐 [Linkedin](https://www.linkedin.com/in/sajeel-sahil-85b575300/) 

---

## 🪪 License

This project is open-source under the [MIT License](LICENSE).
