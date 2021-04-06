//
//  TableContentsVC.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/28/21.
//

import Foundation
import UIKit
import CoreXLSX

class TableContentsVC: UITableViewController{
    
    static var questionTable: [[String]] = []
    var subjectIntPicked: Int = 0
    var subjectStringPicked: String = ""
    
  
    /*
     Loads in CSV data into questionTable. To retrieve a particular question, call:
     
     questionTable[i] for question i, 0 <= i < 11828
     
     To retrieve cell data, index into questionTable[i] with index j as follows:
     
     let imageURL: String = questionTable[i][1]
     */
    static func loadTableData(){
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
            TableContentsVC.questionTable = listOfRows.compactMap { (row) -> [String] in
                row.components(separatedBy: ",")
            }
        }
        catch {
            fatalError("Failed to parse bank data")
        }
    }

    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0,y: 10,width: .max ,height: 20))
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableContentsVC.loadTableData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        navigationItem.title = "Sections"
        searchBar.placeholder = "Search"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton

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
        print("You tapped cell number \(indexPath.row).")
        subjectIntPicked = indexPath.row
        navigationController?.pushViewController(SubSectionVC(), animated: true)
    }
}

class SubSectionVC: UITableViewController{
    
    let cellReuseIdentifier = "cell"
    var subjectNumber: Int = 0
    var subjectsTitles: [String] = []
    
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        super.viewDidLoad()
        self.navigationItem.title = "Sub Sections"
        tableView.delegate = self
        tableView.dataSource = self
        didSelectSubject()
        

    }
    func didSelectSubject(){
        subjectNumber = TableContentsVC.subjectIntPicked
        print(subjectNumber)
        //This code sets the data for the Sub Sections
        if subjectNumber == 0 {
            subjectsTitles = Contents.generalSubjectsSubs
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectsTitles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = subjectsTitles[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    //Goes to first question and resets the first question number to 0 in preperation for bounds 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        TableContentsVC.subjectStringPicked = Contents.generalSubjectsSubs[indexPath.row]
        print(TableContentsVC.subjectStringPicked)
        QuestionsVC.firstQuestion = 0
        navigationController?.pushViewController(QuestionsVC(), animated: true)
    }
}
