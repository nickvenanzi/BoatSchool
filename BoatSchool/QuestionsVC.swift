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
    static var questionData = [[""]]

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
        tableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")


        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
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
        return QuestionsVC.upperBound-QuestionsVC.lowerBound
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studyCell = tableView.dequeueReusableCell(withIdentifier: "StudyCell", for: indexPath) as! StudyCell
        let ReturnCell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell", for: indexPath) as! ReturnCell
            
            StudyCell.questionDescription = TableContentsVC.questionTable[QuestionsVC.firstQuestion][0]
            StudyCell.questionAnswerOne = TableContentsVC.questionTable[QuestionsVC.firstQuestion][2]
            StudyCell.questionAnswerTwo = TableContentsVC.questionTable[QuestionsVC.firstQuestion][3]
            StudyCell.questionAnswerThree = TableContentsVC.questionTable[QuestionsVC.firstQuestion][4]
            StudyCell.questionAnswerFour = TableContentsVC.questionTable[QuestionsVC.firstQuestion][5]
           
        
        return studyCell
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
