//
//  TableContentsVC.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/28/21.
//

import Foundation
import UIKit
import CoreXLSX

class TableContentsVC: UITableViewController, UISearchBarDelegate {
    
    static var questionTable: [[String]] = []
    static var imageIDsToQuestions: [String: [Int]] = [:]
    static var questionsToImageIDs: [Int: String] = [:]
    static var wordsToQuestions: [String: Set<Int>] = [:]
    
    var subjectPicked: Int = 0
     
    /*
     Loads in CSV data into questionTable. To retrieve a particular question, call:
     
     questionTable[i] for question i, 0 <= i < 11828
     
     To retrieve cell data, index into questionTable[i] with index j as follows:
     
     let imageURL: String = questionTable[i][1]
     */
    static func loadQuestionData(){
        // checks if questionTable is nonempty, aka if data has already been loaded
        guard questionTable.isEmpty else {
            return
        }
        
        let filepath = Bundle.main.path(forResource: "bank", ofType: "csv")!
        
        do {
            let content = try String(contentsOfFile: filepath)
            let listOfRows: [String] = content.components(
                separatedBy: "\r\n"
            )
            questionTable = listOfRows.compactMap { (row) -> [String] in
                row.components(separatedBy: ",") + ["F"]
            }
            
            /*
             Map words to question numbers
             */
            let indices: [Int] = [0, 2, 3, 4, 5, 6]
            for (row, question) in questionTable[1...].enumerated() {
                if question.count < questionTable[0].count { continue }
                for index in indices {
                    let string: String = question[index]
                    let pieces: [String] = string.components(separatedBy: " ")
                    for piece in pieces {
                        if piece.isEmpty {
                            continue
                        }
                        let lowered: String = piece.lowercased()
                        if wordsToQuestions[lowered] == nil {
                            wordsToQuestions[lowered] = Set<Int>()
                        }
                        wordsToQuestions[lowered]!.insert(row+1)
                    }
                }
            }
        }
        catch {
            fatalError("Failed to parse bank data")
        }
        
        let matchesPath = Bundle.main.path(forResource: "matches", ofType: "csv")!
        
        do {
            let content = try String(contentsOfFile: matchesPath)
            let listOfQuestionNums: [String] = content.components(
                separatedBy: "\r\n"
            )
            for stringNum in listOfQuestionNums {
                let num: Int? = Int(stringNum)
                if num == nil {
                    continue
                }
                let lastIndex = questionTable[num!].count - 1
                questionTable[num!][lastIndex] = "T"
            }
        }
        catch {
            fatalError("Failed to parse bank data")
        }
    }
    
    /*
     Loads in linkage data between ids and questions, and vice versa
     */
    static func loadLinkageData() {
        
        // checks if IDtoQuestions has been loaded
        if imageIDsToQuestions.isEmpty {
            let filepath = Bundle.main.path(forResource: "IDsToQuestions", ofType: "csv")!
            
            do {
                let content = try String(contentsOfFile: filepath)
                let listOfRows: [String] = content.components(
                    separatedBy: "\r\n"
                )
                for row in listOfRows {
                    var rowData: [String] = row.components(separatedBy: ",")
                    let imageID: String = rowData.remove(at: 0)
                    imageIDsToQuestions[imageID] = rowData.compactMap({ (questionNumAsString) -> Int? in
                        Int(questionNumAsString)
                    })
                }
            }
            catch {
                fatalError("Failed to parse IDs -> Questions data")
            }
        }
        
        // checks if questionsToImageIDs has been loaded
        if questionsToImageIDs.isEmpty {
            let filepath = Bundle.main.path(forResource: "questionsToIDs", ofType: "csv")!
            
            do {
                let content = try String(contentsOfFile: filepath)
                let listOfRows: [String] = content.components(
                    separatedBy: "\r\n"
                )
                for (rowNum, rowString) in listOfRows.enumerated() {
                    if rowString == "" {
                        continue
                    }
                    questionsToImageIDs[rowNum] = rowString
                }
            }
            catch {
                fatalError("Failed to parse Questions -> IDs data")
            }
           
        }
    }

    let cellReuseIdentifier = "chapterCell"
    
    @IBOutlet weak var modeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var questionSearchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableContentsVC.loadQuestionData()
        TableContentsVC.loadLinkageData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.titleView = modeSegmentedControl
        modeSegmentedControl.selectedSegmentIndex = 0
        modeSegmentedControl.addTarget(self, action: #selector(in4kChanged), for: .valueChanged)

        
        tableView.backgroundView = UIImageView(image: UIImage(named: "TCBackground"))
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        navigationItem.title = "Sections"
        
        questionSearchBar.backgroundImage = UIImage()
        questionSearchBar.delegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        tableView.keyboardDismissMode = .onDrag

    }

    @objc func dismissKeyboard() {
        questionSearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        questionSearchBar.endEditing(true)
        
        guard let query = questionSearchBar.text else {
            return
        }
        
        guard query != "" else {
            return
        }
        
        var queryPieces: Set<String> = Set(query.components(separatedBy: " ").map { upper in
            upper.lowercased()
        })
        queryPieces.remove("")
        
        var matches: [Int: Int] = [:]
        for queryPiece in queryPieces {
            for matchToPiece in TableContentsVC.wordsToQuestions[queryPiece] ?? Set() {
                if matches[matchToPiece] == nil {
                    matches[matchToPiece] = 0
                }
                matches[matchToPiece]! += 1
            }
        }
        
        var questionsMatched: [Int] = []
        for match in matches {
            if match.value == queryPieces.count {
                // this question contained every word in the query
                questionsMatched.append(match.key)
            }
        }
        
        guard !questionsMatched.isEmpty else {
            let noMatchesAlert: UIAlertController = UIAlertController(title: "No matches", message: "The query: '\(query)' did not match any questions or answers in the question database", preferredStyle: .alert)
            noMatchesAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

            self.present(noMatchesAlert, animated: true)
            return
        }
        navigationController?.pushViewController(QuestionsVC(questionsMatched), animated: true)
        
    }
        
    var in4k: Bool = false
    
    @objc func in4kChanged() {
        in4k = modeSegmentedControl.selectedSegmentIndex == 1
    }
    
    //Determines the row count
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Contents.subjects.count
    }
    
    //Row Height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //Sets the Cells for the initial screen of main subjects
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = Contents.subjects[indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }

    
    //Function for selecting a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subjectTitles: [Section] = Contents.sections[indexPath.row]
        
        navigationController?.pushViewController(SubSectionVC(subjectTitles, in4k), animated: true)
    }
}


