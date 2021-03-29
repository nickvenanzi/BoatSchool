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
    
    var questionTable: [[String]] = []
    
    /*
     Loads in CSV data into questionTable. To retrieve a particular question, call:
     
     questionTable[i] for question i, 0 <= i < 11828
     
     To retrieve cell data, index into questionTable[i] with index j as follows:
     
     let imageURL: String = questionTable[i][1]
     */
    func loadTableData(){
        let filepath = Bundle.main.path(forResource: "bank", ofType: "csv")!
        
        do {
            let content = try String(contentsOfFile: filepath)
            let listOfRows: [String] = content.components(
                separatedBy: "\r\n"
            )
            questionTable = listOfRows.compactMap { (row) -> [String] in
                row.components(separatedBy: ",")
            }
        }
        catch {
            fatalError("Failed to parse bank data")
        }
    }


    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0,y: 10,width: .max ,height: 20))
    let cellReuseIdentifier = "cell"
    let sections = ["Steam","Diesel","Electrical","General Subject","Automation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableData()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = "Sections"
        searchBar.placeholder = "Search"
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = self.sections[indexPath.row]
        cell.textLabel?.font = .boldSystemFont(ofSize: 20)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        excel()
        navigationController?.pushViewController(SubSectionVC(), animated: true)
        
    }
}
class SubSectionVC: UITableViewController{
    let songs = ["a","b","c","d","e"]
    let cellReuseIdentifier = "cell"
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        super.viewDidLoad()
        self.navigationItem.title = "Sub Sections"
        tableView.delegate = self
        tableView.dataSource = self

    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = self.songs[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
}
