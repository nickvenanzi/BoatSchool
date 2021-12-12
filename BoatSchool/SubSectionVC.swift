//
//  SubSectionsVC.swift
//  BoatSchool
//
//  Created by Nick Venanzi on 4/5/21.
//

import Foundation
import UIKit

class SubSectionVC: UITableViewController{
    
    let cellReuseIdentifier = "subsectionCell"
    var subjects: [Section]
    let in4k: Bool
    let subject: String
    
    init(_ titles: [Section], _ subjectName: String, _ in4k: Bool) {
        subjects = titles
        subject = subjectName
        self.in4k = in4k
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        super.viewDidLoad()
        self.navigationItem.title = subject
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "QBackground"))
        tableView.tableFooterView = UIView(frame: .zero)

        if subject == "Old Exams" {
            return
        }
        // Add generate test button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Generate Test", style: .plain, target: self, action: #selector(SubSectionVC.presentAlert(sender:)))

    }
    
    @objc func presentAlert(sender: UIBarButtonItem) {
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = subjects[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white

        return cell
    }
    
    //Goes to first question and resets the first question number to 0 in preperation for bounds
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        QuestionsVC.firstQuestion = 0
        let sectionSelected: Section = subjects[indexPath.row]
        navigationController?.pushViewController(QuestionsVC(sectionSelected.lowerBound, sectionSelected.upperBound, in4k), animated: true)
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75))
        var footer = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75 ))
        footer = UIImageView(image: UIImage(named: "Title"))
        footer.center = CGPoint(x: footerView.frame.size.width/2, y: footerView.frame.size.height/2)
        footerView.addSubview(footer)
        return footerView
    }
}
