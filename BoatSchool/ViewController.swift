//
//  ViewController.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/27/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var questionLabl: UILabel!
    @IBOutlet weak var answerOne: UILabel!
    @IBOutlet weak var answerTwo: UILabel!
    @IBOutlet weak var answerThree: UILabel!
    @IBOutlet weak var answerFour: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var data = readDataFromCSV(fileName: FILE_1100, fileType: kCSVFileExtension)
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)

        // Do any additional setup after loading the view.
    }
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
        }
        return result
    }
    var data = readDataFromCSV(fileName: kCSVFileName)
}

