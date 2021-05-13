//
//  TableContentsVC.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/28/21.
//

import Foundation
import UIKit
import CoreXLSX

class TableContentsVC: UITableViewController {
    
    static var questionTable: [[String]] = []
    static var imageIDsToQuestions: [String: [Int]] = [:]
    static var questionsToImageIDs: [Int: String] = [:]
    
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

        
        navigationItem.title = "Sections"
//        searchBar.placeholder = "Search"
//        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
//        self.navigationItem.leftBarButtonItem = leftNavBarButton
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
        return cell
    }

    //Function for selecting a row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subjectTitles: [Section]
        switch (indexPath.row) {
            case 0:
                subjectTitles = Contents.generalSubjectsSubs
            case 1:
                subjectTitles = Contents.refrigerationSubs
            case 2:
                subjectTitles = Contents.safetySubs
            case 3:
                subjectTitles = Contents.gasTurbinesSubs
            case 4:
                subjectTitles = Contents.steamPlantsSubs
            case 5:
                subjectTitles = Contents.motorsSubs
            case 6:
                subjectTitles = Contents.electricalSubs
            case 7:
                subjectTitles = Contents.electricAndControlSubs
    //        }
            default:
                print("Selected Row not implemented yet")
                return
        }
        
        navigationController?.pushViewController(SubSectionVC(subjectTitles, in4k), animated: true)
    }
}


