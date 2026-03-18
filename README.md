# InspoQuotes 💡

A clean, elegant iOS application providing inspirational quotes, built specifically to demonstrate a robust, production-ready implementation of **Apple's StoreKit (In-App Purchases)**. 

While the premise is simple—gating premium content behind a paywall—the underlying architecture focuses on secure transactions, memory management, and modern local testing workflows.

## ✨ Core Features

* **Freemium Model:** Displays a set of free quotes while locking premium quotes behind an In-App Purchase (Non-consumable).
* **Seamless Transactions:** Smooth purchasing flow using Apple's `SKPaymentQueue`.
* **Restore Functionality:** Fully compliant with App Store guidelines, allowing users to safely restore past purchases without being charged twice.
* **Persistent State:** Remembers the user's purchase status across app launches using `UserDefaults`.

## 🏗 Technical Highlights & Architecture

This project was developed with a strong emphasis on **Clean Code** and professional iOS development practices:

* **StoreKit Local Testing:** Utilizes Xcode's modern `.storekit` configuration file to simulate a secure, sandbox-free local testing environment for In-App Purchases.
* **Observer Pattern:** Implements `SKPaymentTransactionObserver` cleanly via an extension, separating the core UI logic from the payment processing logic.
* **Memory Management:** Prevents memory leaks by properly adding and removing the transaction observer in `viewDidLoad` and `deinit` respectively.
* **Thread Safety:** Ensures that all UI updates triggered by background payment transactions are strictly dispatched to the **Main Thread** (`DispatchQueue.main.async`).
* **Dynamic TableView Generation:** Avoids unsafe array appending by dynamically calculating `numberOfRowsInSection` and rendering cells based on the real-time purchase state.

## 🛠 Installation & Testing

To test the In-App Purchases locally without needing an Apple Developer Account:

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/InspoQuotes.git
