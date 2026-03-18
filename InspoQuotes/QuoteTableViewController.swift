//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Dev-MuTTiNeeR on 13/03/2026.
//  Copyright © 2026. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController {
    
    // MARK: - Properties
    let productID = "com.muttineer.InspoQuotes.PremiumQuotes"
    
    let freeQuotes = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            navigationItem.setRightBarButton(nil, animated: false)
        }
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return freeQuotes.count + premiumQuotes.count
        } else {
            return freeQuotes.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        
        if indexPath.row < freeQuotes.count {
            cell.textLabel?.text = freeQuotes[indexPath.row]
            cell.textLabel?.textColor = .label
            cell.accessoryType = .none
            
        } else if isPurchased() {
            let premiumIndex = indexPath.row - freeQuotes.count
            cell.textLabel?.text = premiumQuotes[premiumIndex]
            cell.textLabel?.textColor = .label
            cell.accessoryType = .none
            
        } else {
            cell.textLabel?.text = "Get more Quotes"
            cell.textLabel?.textColor = UIColor(red: 0.176, green: 0.498, blue: 0.756, alpha: 1.0) // Modern renk tanımlaması
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == freeQuotes.count && !isPurchased() {
            buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoreKit In-App Purchase Methods
extension QuoteTableViewController: SKPaymentTransactionObserver {
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("The user does not have purchasing authority (parental control, etc.)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase successful!")
                handleSuccessfulPurchase()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                print("Operation failed: \(transaction.error?.localizedDescription ?? "Unknown Error")")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .restored:
                print("Past purchases have been restored!")
                handleSuccessfulPurchase()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func handleSuccessfulPurchase() {
        UserDefaults.standard.set(true, forKey: productID)
        
        DispatchQueue.main.async {
            self.navigationItem.setRightBarButton(nil, animated: true)
            self.tableView.reloadData()
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if queue.transactions.isEmpty {
            print("Apple said: No purchases were found to restore on this account.")
        } else {
            print("The restoration process was successfully completed!")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: any Error) {
        print("Restore failed. Error: \(error.localizedDescription)")
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Helpers
    private func isPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: productID)
    }
}
