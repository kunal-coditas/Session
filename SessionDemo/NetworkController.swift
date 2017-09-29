//
//  NetworkController.swift
//  SessionDemo
//
//  Created by kunal on 29/09/17.
//  Copyright © 2017 coditas. All rights reserved.
//

import Foundation
class NetworkController {
    
    class func loadFile(_ url: URL, withFileName fileName:String, completion:@escaping (_ path:String, _ error:Error?) -> Void) {
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = documentsUrl!.appendingPathComponent(fileName+url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            CommonUtils.log(logString: "file already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
                if (error == nil) {
                    if let response = response as? HTTPURLResponse {
                        CommonUtils.log(logString: "response=\(response)")
                        
                        if response.statusCode == 200 {
                            if (try? data!.write(to: destinationUrl, options: [.atomic])) != nil {
                                CommonUtils.log(logString: "file saved [\(destinationUrl.path)]")
                                completion(destinationUrl.path, error)
                            } else {
                                CommonUtils.log(logString: "error saving file")
                                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }else {
                    CommonUtils.log(logString: "Failure: \(error!.localizedDescription)")
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
    }
}
