//
//  excelReader.swift
//  BoatSchool
//
//  Created by Zach Venanzi on 3/28/21.
//

import CoreXLSX

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
