//
//  ViewController.swift
//  SessionDemo
//
//  Created by kunal on 29/09/17.
//  Copyright © 2017 coditas. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lbStatus: UILabel!
    
    var arrayTemperature = ["Tmax","Tmin","Tmean","Sunshine","Rainfall"]
    var arrayCountries = ["UK.txt","England.txt","Wales.txt","Scotland.txt"]
    let weatherFile = Appconstants.StringConstants.weather
    var baseUrlString = Appconstants.StringConstants.baseUrl
    
    var resultantFilePaths = [String]()
    var docController: UIDocumentInteractionController?
    
    //MARK:- LifeCycle of ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        /*first create csv file in Document Directory*/
        FileManagerController.createFileOfName(weatherFile)
        
        //Primary data written in File
        let fileHeader = Appconstants.StringConstants.fileHeader
        FileManagerController.appendDataInFile(InFile: weatherFile, dataToWrite: fileHeader)
    }
    
    //MARK:- UserInteractions
    @IBAction func actionDownload(_ sender: UIButton) {
        if btnDownload.currentTitle == Appconstants.StringConstants.download{
            activityIndicator.startAnimating()
            btnDownload.isEnabled = false
            lbStatus.isHidden = false
            lbStatus.text = Appconstants.StringConstants.downloadingFiles
            downloadAllData(completion: {
                self.btnDownload.isEnabled = true
                self.activityIndicator.stopAnimating()
                self.lbStatus.isHidden = true
                self.btnDownload.setTitle(Appconstants.StringConstants.open, for: .normal)
            })
        }else{
            guard let filePath = FileManagerController.getFilePath(weatherFile) else {return}
            let fileUrl = URL(fileURLWithPath: filePath)
            self.previewDocument(fileURL: fileUrl)
        }
    }
    
    //MARK:- Utility Methods
    func downloadAllData(completion: @escaping ()->Void) {
        DispatchQueue.global(qos: .background).async {
            for country in self.arrayCountries{
                for temperature in self.arrayTemperature{
                    let urlStr = self.baseUrlString+temperature+"/date/"+country
                    let url = URL(string: urlStr)
                    //Load Url request , downloaded file will be saved in Document dir and returns its path
                    NetworkController.loadFile(url!,withFileName:temperature, completion: { (filePath, error) in
                        //filePath is stored in an array
                        if error == nil{
                            self.resultantFilePaths.append(filePath)
                            //if all the files downloaded Create
                            if self.resultantFilePaths.count == (self.arrayCountries.count * self.arrayTemperature.count){
                                DispatchQueue.main.async {
                                    self.lbStatus.text = Appconstants.StringConstants.creatingCSV
                                    FileManagerController.createSingleFileUsingAllFilesData(resultantFilePaths: self.resultantFilePaths, completion: completion)
                                }
                            }
                        }else{
                            CommonUtils.log(logString: error.debugDescription)
                        }
                    })
                }
            }
        }
    }
    
    func previewDocument(fileURL:URL){
        self.docController = UIDocumentInteractionController(url: fileURL)
        self.docController?.delegate = self
        self.docController?.presentPreview(animated: true)
    }
}

extension DownloadViewController: UIDocumentInteractionControllerDelegate{
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}
