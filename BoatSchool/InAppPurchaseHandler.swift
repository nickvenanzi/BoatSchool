


////
////  InAppPurchaseHandler.swift
////  BoatSchool
////
////  Created by Nick Venanzi on 2/19/22.
////
//import StoreKit
//
//enum InAppPurchaseMessages: String {
//    case purchased = "You payment has been successfully processed."
//    case failed = "Failed to process the payment."
//}
//
//enum PurchaseProduct: String, CaseIterable {
//    case OldExams = "oldExams"
//    case TestGenerator = "testGenerator"
//}
//
//class InAppPurchaseHandler: NSObject {
//    static let shared = InAppPurchaseHandler()
//
//    fileprivate var productIds = PurchaseProduct.allCases.map(\.rawValue)
//    fileprivate var productID = ""
//    fileprivate var productsRequest = SKProductsRequest()
//    fileprivate var productToPurchase: SKProduct?
//    fileprivate var fetchProductcompletion: (([SKProduct]) -> Void)?
//    fileprivate var purchaseProductcompletion: ((String, SKProduct?, SKPaymentTransaction?)->Void)?
//
//    private func canMakePurchases() -> Bool {
//        SKPaymentQueue.canMakePayments()
//    }
//}
//
//extension InAppPurchaseHandler {
//    func purchase(product: SKProduct, completion: @escaping ((String, SKProduct?, SKPaymentTransaction?)->Void)) {
//        purchaseProductcompletion = completion
//        productToPurchase = product
//
//        if canMakePurchases() {
//            let payment = SKPayment(product: product)
//            SKPaymentQueue.default().add(self)
//            SKPaymentQueue.default().add(payment)
//            productID = product.productIdentifier
//        } else {
//            completion("In app purchases are disabled", nil, nil)
//        }
//    }
//
//    func restore(completion: @escaping ((String, SKProduct?, SKPaymentTransaction?)->Void)) {
//        purchaseProductcompletion = completion
//
//        if (SKPaymentQueue.canMakePayments()) {
//          SKPaymentQueue.default().restoreCompletedTransactions()
//        } else {
//            completion("In app purchases are disabled", nil, nil)
//        }
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
//        purchaseProductcompletion?(InAppPurchaseMessages.failed.rawValue, nil, nil)
//    }
//
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        print("1")
//        purchaseProductcompletion?(InAppPurchaseMessages.purchased.rawValue, nil, nil)
//    }
//
//    func fetchAvailableProducts(completion: @escaping (([SKProduct]) -> Void)){
//        fetchProductcompletion = completion
//
//        if productIds.isEmpty {
//            fatalError("Product Ids are not found")
//        } else {
//            productsRequest = SKProductsRequest(productIdentifiers: Set(productIds))
//            productsRequest.delegate = self
//            productsRequest.start()
//        }
//    }
//}
//
//// MARK: SKProductsRequestDelegate
//extension InAppPurchaseHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
//    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        if response.products.count > 0, let completion = fetchProductcompletion {
//            completion(response.products)
//        } else {
//            // TO-DO handle error
//            print("Invalid Product Identifiers: \(response.invalidProductIdentifiers)")
//        }
//    }
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        print("2")
//        for transaction in transactions {
//            switch transaction.transactionState {
//            case .failed:
//                print("Product purchase failed")
//                SKPaymentQueue.default().finishTransaction(transaction)
//
//                if let completion = purchaseProductcompletion {
//                    completion(InAppPurchaseMessages.failed.rawValue, nil, nil)
//                }
//                break
//            case .purchased, .restored:
//                print("Product purchase done")
//                SKPaymentQueue.default().finishTransaction(transaction)
//
//                if let completion = purchaseProductcompletion {
//                    completion(InAppPurchaseMessages.purchased.rawValue, productToPurchase, transaction)
//                }
//                break
//            default:
//                print(transaction.error?.localizedDescription ?? "Something went wrong")
//                break
//            }
//        }
//    }
//}
