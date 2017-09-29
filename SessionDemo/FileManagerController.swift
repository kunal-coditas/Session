//
//  FileManagerController.swift
//  SessionDemo
//
//  Created by kunal on 29/09/17.
//  Copyright © 2017 coditas. All rights reserved.
//

import Foundation

class FileManagerController{
    static var documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    class func contentsOfFile(_ filename: String) -> String? {
        let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destPath = filePath!.appendingPathComponent(filename)
        
        do {
            if FileManager.default.fileExists(atPath: destPath.path) {
                let contents = try NSString(contentsOfFile: destPath.path, encoding: String.Encoding.utf8.rawValue)
                return contents as String
            }
        }
        catch _ {
        }
        return nil
    }
    
    class func getFilePath(_ fileName: String) -> String? {
        var filePath = self.documentsDirectoryPath()
        filePath = filePath + "/\(fileName)"
        if FileManager.default.fileExists(atPath: filePath) {
            return filePath
        }
        return nil
    }
    
    class func documentsDirectoryPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectoryPath = paths[0]
//        print("\(documentsDirectoryPath)")
        return documentsDirectoryPath
    }
    
    class func pathForFile(_ fileName: String)-> String{
        let docPath = self.documentsDirectoryPath()
        return docPath + "/\(fileName)"
    }
    
    class func createFileOfName(_ name: String){
        if !( FileManager.default.fileExists(atPath: self.pathForFile(name))){
            FileManager.default.createFile( atPath: self.pathForFile(name), contents: nil, attributes: nil)
        }
//        print("creating csv file.")
    }
    
    class func appendDataInFile(InFile fileName: String, dataToWrite dataStr:String){
        
        let handle = FileHandle(forWritingAtPath: FileManagerController.getFilePath(fileName)!)
        handle?.truncateFile(atOffset: (handle?.seekToEndOfFile())!)
        handle?.write(dataStr.data(using: String.Encoding.utf8)!)
    }
    
    class func createSingleFileUsingAllFilesData(resultantFilePaths: [String], completion : @escaping (()-> Void)){
        DispatchQueue.global(qos: .background).async {
            for urlstr in resultantFilePaths{
                
                let fileUrl = URL(string:  urlstr)
                
                guard let fileContents = FileManagerController.contentsOfFile("\(fileUrl!.lastPathComponent)") else{return}
                
                //removed file Info
                var array = fileContents.components(separatedBy: "ANN")
                array.removeFirst()
                
                if array.count == 0{
                    return
                }
                let dataStr = array[0]
                //Numerical data
                let arrLines = dataStr.components(separatedBy: "\n")
                
                for line in arrLines{
                    
                    if line.isEmpty{
                        continue
                    }
                    
                    //remove empty spaces
                    var lineWithExtaSpaces = line.replacingOccurrences(of: "     ", with: " ")
                    lineWithExtaSpaces = lineWithExtaSpaces.replacingOccurrences(of: "    ", with: " ")
                    lineWithExtaSpaces = lineWithExtaSpaces.replacingOccurrences(of: "   ", with: " ")
                    lineWithExtaSpaces = lineWithExtaSpaces.replacingOccurrences(of: "  ", with: " ")
                    
                    
                    var arrComponents = lineWithExtaSpaces.components(separatedBy: " ")
                    
                    var year = ""
                    var index = 0
                    for component in arrComponents{
                        
                        if component == arrComponents[0]{
                            year = arrComponents[0]
                            continue
                        }
                        
                        var writingStr = year
                        let regionCode = self.getCountryName(fileUrl!.absoluteString)
                        let weatherType = checkTemperatureType(fileUrl!.absoluteString)
                        
                        let month = self.stringFromKeyMonth(index)
                        index += 1
                        
                        if Float(component) != nil{
                            writingStr = regionCode + "," + weatherType  + ","
                            writingStr.append(year  + "," + month! + "," + component + "\n")
                            //                        print(writingStr)
                        }else{
                            writingStr = regionCode + "," + weatherType  + ","
                            writingStr.append(year  + "," + month!  + "," + "NA \n")
                        }
                        FileManagerController.appendDataInFile(InFile: Appconstants.StringConstants.weather, dataToWrite: writingStr)
                    }
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    class func getCountryName(_ str: String)->String{
        if str.contains("UK"){
            return "UK"
        }else if str.contains("England"){
            return "England"
            
        }else if str.contains("Wales"){
            return "Wales"
            
        }else if str.contains("Scotland"){
            return "Scotland"
        }
        return ""
    }
    
    class func checkTemperatureType(_ str:String)->String{
        if str.contains("Tmax"){
            return "Tmax"
        }else if str.contains("Tmin"){
            return "Tmin"
            
        }else if str.contains("Tmean"){
            return "Tmean"
            
        }else if str.contains("Sunshine"){
            return "Sunshine"
        }else if str.contains("Rainfall"){
            return "Rainfall"
        }
        return ""
    }
    
    class func stringFromKeyMonth(_ index: Int)->String?{
        switch index {
        case 0:
            return "JAN"
        case 1:
            return "FEB"
        case 2:
            return "MAR"
        case 3:
            return "APR"
        case 4:
            return "MAY"
        case 5:
            return "JUN"
        case 6:
            return "JUL"
        case 7:
            return "AUG"
        case 8:
            return "SEP"
        case 9:
            return "OCT"
        case 10:
            return "NOV"
        case 11:
            return "DEC"
        case 12:
            return "WIN"
        case 13:
            return "SPR"
        case 14:
            return "SUM"
        case 15:
            return "AUT"
        case 16:
            return "ANN"
        default:
            break
        }
        return nil
    }
}
