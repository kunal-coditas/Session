//
//  Appconstants.swift
//  SessionDemo
//
//  Created by kunal on 29/09/17.
//  Copyright © 2017 coditas. All rights reserved.
//

import Foundation
struct  Appconstants {
    struct StringConstants {
        static var baseUrl = "http://www.metoffice.gov.uk/pub/data/weather/uk/climate/datasets/"
        static let weather = "weather.csv"
        static let fileHeader = "region_code, weather_param, year, key, value\n"
        
        static let download = "Download"
        static let open = "Open"
        static let downloadingFiles = "Downloading Files"
        static let creatingCSV = "Creating CSV File"
        
    }
}
