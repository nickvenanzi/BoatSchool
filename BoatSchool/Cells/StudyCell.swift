//
//  StudyCell.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 4/2/21.
//

import UIKit

class StudyCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    static var questionDescription = ""
    static var questionPicture = ""
    static var questionAnswerOne = ""
    static var questionAnswerTwo = ""
    static var questionAnswerThree = ""
    static var questionAnswerFour = ""

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        tableView.register(UINib(nibName: "ButtonsCell", bundle: nil), forCellReuseIdentifier: "ButtonsCell")
        tableView.register(UINib(nibName: "ReturnCell", bundle: nil), forCellReuseIdentifier: "ReturnCell")
        tableView.register(UINib(nibName: "StudyCell", bundle: nil), forCellReuseIdentifier: "StudyCell")
        
        tableView.isScrollEnabled = false
        
        // Initialization code
    }

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let questionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            let answerCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            let buttonsCell = tableView.dequeueReusableCell(withIdentifier: "ButtonsCell", for: indexPath) as! ButtonsCell
            let returnCell = tableView.dequeueReusableCell(withIdentifier: "ReturnCell", for: indexPath) as! ReturnCell
            
            if indexPath.row == 0{
                questionCell.mainQuestionLabel.text = StudyCell.questionDescription
                //questionCell.mesbLabel.text = "MESB \(QuestionsVC.firstQuestion)"
                return questionCell
            }
            
            if indexPath.row == 1{
                answerCell.answerLabel.text = "A. \(StudyCell.questionAnswerOne)"
//                if indexPath.row == QuestionsVC.correctAnswer+1{
//                    answerCell.selectionStyle = .blue
//                }
//                else{
//                    answerCell.selectionStyle = .none
//                }
                return answerCell
            }
            if indexPath.row == 2 {
                answerCell.answerLabel.text = "B. \(StudyCell.questionAnswerTwo)"
                return answerCell
            }
           if indexPath.row == 3 {
            answerCell.answerLabel.text = "C. \(StudyCell.questionAnswerThree)"
                return answerCell
            }
            if indexPath.row == 4{
                answerCell.answerLabel.text =
                    "D. \(StudyCell.questionAnswerThree)"
                return answerCell
            }
            
        print(TableContentsVC.questionTable[1])
        return answerCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 6{
            print("Return to TableContentsVC")
            //navigationController?.popToRootViewController(animated: true)
            QuestionsVC.firstQuestion = 0
        }
    }
}
