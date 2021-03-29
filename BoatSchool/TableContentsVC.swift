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
    
    func excel(){
        let filepath = "bank.xlsx"
        guard let file = XLSXFile(filepath: filepath) else {
          fatalError("XLSX file at \(filepath) is corrupted or does not exist")
        }

        for wbk in try! file.parseWorkbooks() {
          for (name, path) in try! file.parseWorksheetPathsAndNames(workbook: wbk) {
            if let worksheetName = name {
              print("This worksheet has a name: \(worksheetName)")
            }
            let worksheet = try! file.parseWorksheet(at: path)
            for row in worksheet.data?.rows ?? [] {
              for c in row.cells {
                print(c)
              }
                if let sharedStrings = try! file.parseSharedStrings() {
                  let columnCStrings = worksheet.cells(atColumns: [ColumnReference("C")!])
                    .compactMap { $0.stringValue(sharedStrings) }
                    print(columnCStrings)
                }
            }
          }
        }
    }

    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0,y: 10,width: .max ,height: 20))
    let cellReuseIdentifier = "cell"
    let sections = ["Steam","Diesel","Electrical","General Subject","Automation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
