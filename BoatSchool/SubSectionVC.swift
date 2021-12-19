//
//  SubSectionsVC.swift
//  BoatSchool
//
//  Created by Nick Venanzi on 4/5/21.
//

import Foundation
import UIKit
import PassKit

class SubSectionVC: UITableViewController {
    
    let cellReuseIdentifier = "subsectionCell"
    var subjects: [Section]
    let in4k: Bool
    
    init(_ titles: [Section], _ in4k: Bool) {
        subjects = titles
        self.in4k = in4k
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        super.viewDidLoad()
        self.navigationItem.title = TableContentsVC.subjectPicked
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "QBackground"))
        tableView.tableFooterView = UIView(frame: .zero)

        var footer = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50 ))
        footer = UIImageView(image: UIImage(named: "Title"))
        footer.contentMode = .scaleAspectFit
        footer.center.y = view.center.x
        tableView.tableFooterView = footer

        if TableContentsVC.subjectPicked == "Old Exams" {
            if Keys.examsPurchased {
                return
            }
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Purchase Exams", style: .plain, target: self, action: #selector(purchaseExamsAlert))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Generate Test", style: .plain, target: self, action: #selector(purchaseTestGeneratorAlert))

        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = subjects[indexPath.row].name
        cell.backgroundColor = .clear
        
        if TableContentsVC.subjectPicked == "Old Exams" && !Keys.examsPurchased {
            cell.textLabel?.textColor = .gray
        } else {
            cell.textLabel?.textColor = .white
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // if exams not payed for, prompt purchase option
        if !Keys.examsPurchased && TableContentsVC.subjectPicked == "Old Exams" {
            purchaseExamsAlert()
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let sectionSelected: Section = subjects[indexPath.row]
        navigationController?.pushViewController(QuestionsVC(sectionSelected.lowerBound, sectionSelected.upperBound, in4k), animated: true)
    }
    
    func generateTestAlert() {
        let alert = UIAlertController(title: "Generate Test", message: "This test will be made with Questions from the " + (in4k ? "3 A/E" : "full") + " bank", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "20 Questions", style: .default, handler: { _ in
            self.generateTest(20)
        }))
        alert.addAction(UIAlertAction(title: "70 Questions", style: .default, handler: { _ in
            self.generateTest(70)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))

        present(alert, animated: true)
    }
    
    func generateTest(_ numQuestions: Int) {
        let lowerBound: Int = subjects[0].lowerBound
        let upperBound: Int = subjects[subjects.count - 1].upperBound
        var questionsToChoose = Set<Int>(lowerBound...upperBound)
        // randomize questions to include
        var questionsToInclude = Set<Int>()
        while questionsToInclude.count < numQuestions {
            let questionRow = questionsToChoose.randomElement()
            guard let questionRow = questionRow else {
                break
            }
            questionsToChoose.remove(questionRow)
            let rowData: [String] = TableContentsVC.questionTable[questionRow]
            if (rowData[7] == "") {
                continue
            }
            let qIn4k: Bool = rowData[rowData.count - 1] == "T"
            if in4k && !qIn4k {
                continue
            }
            questionsToInclude.insert(questionRow)
        }
        navigationController?.pushViewController(QuestionsVC(Array(questionsToInclude).sorted()), animated: true)
    }
    
}

extension SubSectionVC: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) {}
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // determine which payment was authorized:
        if TableContentsVC.subjectPicked == "Old Exams" {
            Keys.examsPurchased = true
            self.navigationItem.rightBarButtonItem = nil
            tableView.reloadData()
        } else {
            Keys.testGeneratorPurchased = true
        }
        return completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }
    
    /*
     ------------------------- Exam Purchase Processing ---------------------------------
     */
    
    private var examsRequest: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.BeepBoopBop"
        request.supportedNetworks = [.masterCard,.amex,.visa,.discover]
        request.supportedCountries = ["US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Old Exams", amount: 9.99)]
        return request
    }
    
    @objc func purchaseExamsAlert() {
        let alert = UIAlertController(title: "Purchase Exams", message: "Would you like to pay $9.99 to get access to all of the old exams?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Purchase", style: .default, handler: { _ in
            self.purchaseExams()
        }))
        present(alert, animated: true)
    }
    
    private func purchaseExams() {
        guard let paymentController = PKPaymentAuthorizationViewController(paymentRequest: examsRequest) else {
            let alert = UIAlertController(title: "Payment Configuration Failed", message: "Try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        paymentController.delegate = self
        present(paymentController, animated: true)
    }
    
    /*
     ------------------------- Generator Purchase Processing ---------------------------------
     */
    
    private var generatorRequest: PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.BeepBoopBop"
        request.supportedNetworks = [.masterCard,.amex,.visa,.discover]
        request.supportedCountries = ["US"]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [PKPaymentSummaryItem(label: "Test Generator", amount: 4.99)]
        return request
    }
    
    @objc func purchaseTestGeneratorAlert() {
        if Keys.testGeneratorPurchased {
            generateTestAlert()
            return
        }
        let alert = UIAlertController(title: "Purchase Test Generator", message: "Would you like to pay $4.99 to get randomly generated practice exams to study from? Note: This purchase will give access to all subsection Test Generators.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Purchase", style: .default, handler: { _ in
            self.purchaseTestGenerator()
        }))
        present(alert, animated: true)
    }
    
    private func purchaseTestGenerator() {
        guard let paymentController = PKPaymentAuthorizationViewController(paymentRequest: generatorRequest) else {
            let alert = UIAlertController(title: "Payment Configuration Failed", message: "Try again later", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
        paymentController.delegate = self
        present(paymentController, animated: true)
    }

}
