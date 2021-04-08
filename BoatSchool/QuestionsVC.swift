//
//  swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/29/21.
//
import Foundation
import UIKit

struct Question {
    var question: String
    var correctAnswer: Int
    var answers: [String]
    var highlightedRow: Int?
    
    // var image: UIImage()
    
    init(_ question: String, _ correctAnswer: Int, _ answers: [String]) {
        self.question = question
        self.correctAnswer = correctAnswer
        self.answers = answers
    }
}

enum CellType {
    case QUESTION
    case ANSWER
}

class QuestionsVC: UITableViewController{
    
    var upperBound: Int
    var lowerBound: Int
    var questions: [Question] = []
    var numberOfQuestionsRight = 0
    var numberOfQuestionsAnswered = 0
    
    static var answerLetters = ["A", "B", "C", "D", "E"]
    
    var modeSegmentedControl: UISegmentedControl = UISegmentedControl()
        
    init(_ lower: Int, _ upper: Int) {
        self.upperBound = upper
        self.lowerBound = lower
        super.init(nibName: nil, bundle: nil)
        loadInSectionQuestions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     Populates question array with question data from questionData table
     */
    func loadInSectionQuestions() {
        for questionRow in lowerBound...upperBound {
            let rowData: [String] = TableContentsVC.questionTable[questionRow]
            if (rowData[7] == "") {
                continue
            }

            let questionString = "\(questionRow). " + rowData[0]
            let correctAnswer = Int(rowData[rowData.count-1])!
            var answers: [String] = Array(rowData[2..<rowData.count-1])
            // if no 5th answer, remove last element in row
            if answers[answers.count-1] == "" {
                answers.popLast()
            }
            
            questions.append(Question(questionString, correctAnswer, answers))
        }
    }

    func activateStudyMode() {
        numberOfQuestionsRight = 0
        numberOfQuestionsAnswered = 0
        for section in 0..<questions.count {
            questions[section].highlightedRow = nil
            
            for row in 0..<questions[section].answers.count {
                let cell: AnswerCell? = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? AnswerCell
                if questions[section].correctAnswer == row {
                    cell?.answerLabel.textColor = .green

                } else {
                    cell?.answerLabel.textColor = .none
                }
            }
        }
    }
    
    func activateQuizMode() {
        for section in 0..<questions.count {
            for row in 0..<questions[section].answers.count {
                let cell: AnswerCell? = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? AnswerCell
                cell?.answerLabel.textColor = .none
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = modeSegmentedControl
        modeSegmentedControl.insertSegment(withTitle: "Quiz Mode", at: 0, animated: false)
        modeSegmentedControl.insertSegment(withTitle: "Study Mode", at: 1, animated: false)
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.addTarget(self, action: #selector(modeChanged), for: .valueChanged)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        tableView.register(UINib(nibName: "ReturnCell", bundle: nil), forCellReuseIdentifier: "ReturnCell")
//        tableView.register(UINib(nibName: "SectionHeader", bundle: nil), forCellReuseIdentifier: "SectionHeader")
        tableView.register(UINib(nibName: "SectionHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SectionHeader")


        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
    }
    
    /*
     Activated mode after segmented control switched
     */
    @objc func modeChanged() {
        if modeSegmentedControl.selectedSegmentIndex == 0 {
            // Quiz Mode
            activateQuizMode()
        } else {
            // Study Mode
            activateStudyMode()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions[section].answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let questionNumber: Int = indexPath.section
        let question: Question = questions[questionNumber]
        let answer: String = question.answers[indexPath.row]
        
        let answerCell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as? AnswerCell
        answerCell?.answerLabel.text = QuestionsVC.answerLetters[indexPath.row] + ". " + answer
        
        // color text green, red or black depending on scenario
        if modeSegmentedControl.selectedSegmentIndex == 1 {
            answerCell?.answerLabel.textColor = question.correctAnswer == indexPath.row ? .green : .none
        } else if question.highlightedRow == indexPath.row {
            answerCell?.answerLabel.textColor = question.correctAnswer  == question.highlightedRow ? .green : .red
        } else {
            answerCell?.answerLabel.textColor = .none

        }
        return answerCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell: AnswerCell = tableView.cellForRow(at: indexPath) as! AnswerCell
        let question: Question = questions[indexPath.section]
        
        let correctAnswerSelected: Bool = question.correctAnswer == indexPath.row
        cell.answerLabel.textColor = correctAnswerSelected ? .green : .red
        
        if correctAnswerSelected && questions[indexPath.section].highlightedRow == nil {
            numberOfQuestionsRight += 1
        }
        questions[indexPath.section].highlightedRow = indexPath.row
       
        // if every question answered, alert user on results
        if numberOfQuestionsAnswered == questions.count {
            let score: Float = (Float(numberOfQuestionsRight)/Float(numberOfQuestionsAnswered) * 1000).rounded()/10.0
            let quizResultsAlert = UIAlertController(title: "Quiz Results: \(score)%", message: "You answered \(numberOfQuestionsRight) out of \(numberOfQuestionsAnswered)", preferredStyle: .alert)
            
            quizResultsAlert.addAction(UIAlertAction(title: "Exit Section", style: .cancel, handler: { (_) in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            self.present(quizResultsAlert, animated: true)
        }

    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        // if study mode, can't select answers
        guard modeSegmentedControl.selectedSegmentIndex == 0 else {
            return nil
        }
        
        if questions[indexPath.section].highlightedRow == nil {
            numberOfQuestionsAnswered += 1
        }
        
        // only follow through with highlighting selected row if the answer has not yet been selected for this section
        if questions[indexPath.section].correctAnswer == questions[indexPath.section].highlightedRow {
            return nil
        }
        
        //first remove color from previously selected answer in this section if there is one
        let previousCellPath: IndexPath? = tableView.indexPathForSelectedRow
        if previousCellPath?.section == indexPath.section {
            let previousCell = tableView.cellForRow(at: previousCellPath!) as? AnswerCell
            previousCell?.answerLabel.textColor = .none
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SectionHeader") as? SectionHeader
        sectionHeader?.questionLabel.text = questions[section].question
        return sectionHeader
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }
    
    


}
