//
//  StoreVC.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 12/20/21.
//

import UIKit
import StoreKit
import RxRelay
import RxSwift

class StoreVC: UIViewController, SKPaymentTransactionObserver {
    var oldExams = "oldExams"
    var testGenerator = "testGenerator"

    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    private var completionHandler: ((String, SKProduct?, SKPaymentTransaction?)->Void)?

    @IBOutlet weak var oldExamsButton: UIButton!
    @IBOutlet weak var testGeneratorButton: UIButton!
    @IBOutlet weak var restoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        if (Keys.examsPurchased) {
            self.oldExamsButton.tintColor = .gray
            self.oldExamsButton.isUserInteractionEnabled = false
        }
        if (Keys.testGeneratorPurchased) {
            self.testGeneratorButton.tintColor = .gray
            self.testGeneratorButton.isUserInteractionEnabled = false
        }

        SKPaymentQueue.default().add(self)
        
    }
    
    @IBAction func purchaseOldExams(_ sender: Any) {
        if (SKPaymentQueue.canMakePayments()) {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = oldExams
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("No access")
        }
    }
    
    @IBAction func purchaseTestGenerator(_ sender: Any) {
        if (SKPaymentQueue.canMakePayments()) {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = testGenerator
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("No access")
        }
    }
    
    @IBAction func restorePurchase(_ sender: Any) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased || transaction.transactionState == .restored {
                print("Transaction succeeded/restored")
                if (transaction.payment.productIdentifier == oldExams) {
                    Keys.examsPurchased = true
                    self.oldExamsButton.tintColor = .gray
                    self.oldExamsButton.isUserInteractionEnabled = false
                } else if (transaction.payment.productIdentifier == testGenerator){
                    Keys.testGeneratorPurchased = true
                    self.testGeneratorButton.tintColor = .gray
                    self.testGeneratorButton.isUserInteractionEnabled = false
                }
            } else if transaction.transactionState == .failed {
                let alert = UIAlertController(title: "Transaction Failed", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                present(alert, animated: true)
            }
        }
    }
}

//import UIKit
//import StoreKit
//import RxRelay
//import RxSwift
//
//class StoreVC: UIViewController {
//    let bag = DisposeBag()
//    var products = BehaviorRelay<[SKProduct]>(value: [])
//    var oldExamsPrice = ""
//    var testGeneratorPrice = ""
//
//    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
//    private var completionHandler: ((String, SKProduct?, SKPaymentTransaction?)->Void)?
//
//    @IBOutlet weak var oldExamsButton: UIButton!
//    @IBOutlet weak var testGeneratorButton: UIButton!
//    @IBOutlet weak var restoreButton: UIButton!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addObservers()
//        fetchProducts()
//        if (Keys.examsPurchased) {
//            self.oldExamsButton.tintColor = .gray
//            self.oldExamsButton.isUserInteractionEnabled = false
//        }
//        if (Keys.testGeneratorPurchased) {
//            self.testGeneratorButton.tintColor = .gray
//            self.testGeneratorButton.isUserInteractionEnabled = false
//        }
//
//        completionHandler =  { (message, product, transaction) in
//
//            if let transaction = transaction, let product = product {
//
//                if transaction.error == nil {
//                    let title: String
//                    if (transaction.transactionState == .purchased) {
//                        title = "Success"
//                        if (product.productIdentifier == PurchaseProduct.OldExams.rawValue) {
//                            Keys.examsPurchased = true
//                            self.oldExamsButton.tintColor = .gray
//                            self.oldExamsButton.isUserInteractionEnabled = false
//                        } else {
//                            Keys.testGeneratorPurchased = true
//                            self.testGeneratorButton.tintColor = .gray
//                            self.testGeneratorButton.isUserInteractionEnabled = false
//                        }
//                    } else {
//                        title = "Declined"
//                    }
//                    let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    self.present(alert, animated: true)
//                } else {
//                    let alert = UIAlertController(title: "Declined", message: transaction.error?.localizedDescription ?? message, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    self.present(alert, animated: true)
//                }
//            }
//        }
//    }
//
//    @IBAction func purchaseOldExams(_ sender: Any) {
//        self.purchase(product: .OldExams)
//    }
//    @IBAction func purchaseTestGenerator(_ sender: Any) {
//        self.purchase(product: .TestGenerator)
//    }
//    @IBAction func restorePurchase(_ sender: Any) {
//        self.restorePurchases()
//    }
//
//    private func fetchProducts() {
//        activityIndicator.startAnimating()
//
//        InAppPurchaseHandler.shared.fetchAvailableProducts { (products) in
//            self.products.accept(products)
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
//        }
//    }
//
//    private func restorePurchases() {
//        InAppPurchaseHandler.shared.restore(completion: completionHandler!)
//    }
//
//    private func purchase(product: PurchaseProduct) {
//        guard let _product = products.value.first(where: {$0.productIdentifier == product.rawValue}) else {
////            log.error("Product: \(product.rawValue) not found in Products Set")
//            return
//        }
//
//        InAppPurchaseHandler.shared.purchase(product: _product, completion: completionHandler!)
//    }
//
//    private func addObservers() {
//        products.asObservable().subscribe{ _ in
//            let products = self.products.value
//            guard let oldExams = products.first(where: {$0.productIdentifier == PurchaseProduct.OldExams.rawValue}),
//                  let testGenerator = products.first(where: {$0.productIdentifier == PurchaseProduct.TestGenerator.rawValue})
//            else { return }
//
//            DispatchQueue.main.async {
//                let currency = oldExams.priceLocale.currencyCode ?? ""
//
//                self.oldExamsPrice = "\(currency) \(oldExams.price.decimalValue)"
//                self.testGeneratorPrice = "\(currency) \(testGenerator.price.decimalValue)"
//            }
//        }.disposed(by: bag)
//    }
//}
