//
//  QuestionsVC.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/29/21.
//
import Foundation
import UIKit

class QuestionsVC: UITableViewController{
    
    static var firstQuestion = 1000
    //This is my attempt to convert a string to an INT
    var correctAnswerInt: Int = Int(TableContentsVC.questionTable[firstQuestion][7])!-1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        tableView.register(UINib(nibName: "ButtonsCell", bundle: nil), forCellReuseIdentifier: "ButtonsCell")
        
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false

    }
    //this is nonsense for now
    func selectQuestion(){
        print(TableContentsVC.questionTable[QuestionsVC.firstQuestion][0])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let questionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell", for: indexPath) as! ButtonsCell
                    
            if indexPath.row == 0{
                questionCell.mainQuestionLabel.text = TableContentsVC.questionTable[QuestionsVC.firstQuestion][0]
                questionCell.mesbLabel.text = "MESB\(QuestionsVC.firstQuestion)"
                return questionCell
            }
            if indexPath.row == 1 {
                return buttonsCell
            }
            if indexPath.row == 2 {
                answerCell.answerLabel.text = TableContentsVC.questionTable[QuestionsVC.firstQuestion][2]
                if indexPath.row == correctAnswerInt{
                    answerCell.selectionStyle = .default
                }
                else {
                    answerCell.selectionStyle = .gray
                }
                return answerCell
            }
            if indexPath.row == 3 {
                answerCell.answerLabel.text = TableContentsVC.questionTable[QuestionsVC.firstQuestion][3]
                return answerCell
                if indexPath.row == correctAnswerInt{
                    answerCell.selectionStyle = .default
                }
                else {
                    answerCell.selectionStyle = .gray
                }

            }
           if indexPath.row == 4 {
            answerCell.answerLabel.text = TableContentsVC.questionTable[QuestionsVC.firstQuestion][4]
                return answerCell
                if indexPath.row == correctAnswerInt{
                    answerCell.selectionStyle = .default
                }
                else {
                    answerCell.selectionStyle = .gray
                }
            }
            if indexPath.row == 5{
                answerCell.answerLabel.text = TableContentsVC.questionTable[QuestionsVC.firstQuestion][5]
                if indexPath.row == correctAnswerInt{
                    answerCell.selectionStyle = .default
                }
                else {
                    answerCell.selectionStyle = .gray
                }
             return answerCell
         }
        print(TableContentsVC.questionTable[1])
        return answerCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
        
}
