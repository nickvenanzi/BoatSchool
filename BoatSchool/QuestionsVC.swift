//
//  QuestionsVC.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/29/21.
//
import Foundation
import UIKit

class QuestionsVC: UITableViewController{
    
    static var firstQuestion = 0
    static var upperBound = 0
    static var lowerBound = 0
    static var correctAnswer = 0
    var answerString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        didSelectRange()
        identifyCorrectAnswer()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        tableView.register(UINib(nibName: "ButtonsCell", bundle: nil), forCellReuseIdentifier: "ButtonsCell")
        tableView.register(UINib(nibName: "ReturnCell", bundle: nil), forCellReuseIdentifier: "ReturnCell")

        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
    }
    //sets the range 
    func didSelectRange(){
        guard QuestionsVC.firstQuestion == 0 else{
            return
        }
            for n in Contents.testKeys[TableContentsVC.subjectStringPicked]!{
            QuestionsVC.lowerBound = n.lowerBound
            QuestionsVC.upperBound = n.upperBound
            print(QuestionsVC.upperBound,QuestionsVC.lowerBound)
            QuestionsVC.firstQuestion = QuestionsVC.lowerBound
        }
    }
    func identifyCorrectAnswer(){
        var correctAnswer = TableContentsVC.questionTable[QuestionsVC.firstQuestion][7]
        QuestionsVC.correctAnswer = Int(correctAnswer) ?? 0
        print(correctAnswer)
        print(QuestionsVC.correctAnswer)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let questionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell", for: indexPath) as! ButtonsCell
            let returnCell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell", for: indexPath) as! ReturnCell
            
            if indexPath.row == 0{
                questionCell.mainQuestionLabel.text = TableContentsVC.questionTable[QuestionsVC.firstQuestion][0]
                questionCell.mesbLabel.text = "MESB \(QuestionsVC.firstQuestion)"
                return questionCell
            }
            if indexPath.row == 1 {
                return buttonsCell
            }
            if indexPath.row == 2 {
                answerCell.answerLabel.text = "A. \(TableContentsVC.questionTable[QuestionsVC.firstQuestion][2])"
                if indexPath.row == QuestionsVC.correctAnswer+1{
                    answerCell.selectionStyle = .blue
                }
                else{
                    answerCell.selectionStyle = .none
                }
                return answerCell
            }
            if indexPath.row == 3 {
                answerCell.answerLabel.text = "B. \( TableContentsVC.questionTable[QuestionsVC.firstQuestion][3])"
                if indexPath.row == QuestionsVC.correctAnswer+1{
                    answerCell.selectionStyle = .blue
                }
                else{
                    answerCell.selectionStyle = .none
                }
                return answerCell
            }
           if indexPath.row == 4 {
            answerCell.answerLabel.text = "C. \(TableContentsVC.questionTable[QuestionsVC.firstQuestion][4])"
                if indexPath.row == QuestionsVC.correctAnswer+1{
                    answerCell.selectionStyle = .blue
                }
                else{
                    answerCell.selectionStyle = .none
                }
                return answerCell
            }
            if indexPath.row == 5{
                answerCell.answerLabel.text =
                    "D. \(TableContentsVC.questionTable[QuestionsVC.firstQuestion][5])"
                if indexPath.row == QuestionsVC.correctAnswer+1{
                    answerCell.selectionStyle = .blue
                }
                else{
                    answerCell.selectionStyle = .none
                }
                return answerCell
            }
            if indexPath.row == 6{
                return returnCell
            }
        print(TableContentsVC.questionTable[1])
        return answerCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6{
            print("Return to TableContentsVC")
            navigationController?.popToRootViewController(animated: true)
            QuestionsVC.firstQuestion = 0
        }
        else {
        print("You tapped cell number \(indexPath.row).")
        QuestionsVC.firstQuestion = QuestionsVC.firstQuestion + 1
            if QuestionsVC.firstQuestion >= QuestionsVC.upperBound+1{
                navigationController?.popToRootViewController(animated: true)
                print("Upper bound reached returning to TableContentsVC")
            }
            if indexPath.row == QuestionsVC.correctAnswer+1{
                navigationController?.pushViewController(QuestionsVC(), animated: true)
            }
            else{
                print("Wrong Answer")
            }
        }
    }
}
