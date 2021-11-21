//
//  SubSectionsVC.swift
//  BoatSchool
//
//  Created by Nick Venanzi on 4/5/21.
//

import Foundation
import UIKit

class SubSectionVC: UITableViewController{
    
    let cellReuseIdentifier = "subsectionCell"
    var subjects: [Section]
    let in4k: Bool
    
    
    init(_ titles: [Section], _ in4k: Bool) {
        subjects = titles
        self.in4k = in4k
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        super.viewDidLoad()
        navigationItem.title = TableContentsVC.subjectPicked
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "QBackground"))
        tableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Generate Test", style: .plain , target: self, action: #selector(SubSectionVC.presentAlert(sender:)))

        var footer = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50 ))
        footer = UIImageView(image: UIImage(named: "Title"))
        footer.contentMode = .scaleAspectFit
        footer.center.y = view.center.x
        tableView.tableFooterView = footer


    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    //
    //Fix this so that it displays a ***MESSAGE*** that say whether or not it is the full bank or the 3A/E bank
    //
    @objc func presentAlert(sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Generate Test", message: "This test will be made of the full bank", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "20 Questions", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "70 Questions", style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: nil))

                // show the alert
            self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        
        cell.textLabel?.text = subjects[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white

        return cell
    }
    
    //Goes to first question and resets the first question number to 0 in preperation for bounds
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        QuestionsVC.firstQuestion = 0
        let sectionSelected: Section = subjects[indexPath.row]
        navigationController?.pushViewController(QuestionsVC(sectionSelected.lowerBound, sectionSelected.upperBound, in4k), animated: true)
    }
    
    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75))
//        var footer = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 75 ))
//        footer = UIImageView(image: UIImage(named: "Title"))
//        footer.center = CGPoint(x: footerView.frame.size.width/2, y: footerView.frame.size.height/2)
//        footerView.addSubview(footer)
//        tableView.tableFooterView = footerView
//        return footerView
//    }
}
