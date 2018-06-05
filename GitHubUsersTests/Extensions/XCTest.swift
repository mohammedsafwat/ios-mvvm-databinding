//
//  XCTest.swift
//  GitHubUsersTests
//
//  Created by Mohammed Safwat on 5/8/18.
//  Copyright © 2018 Mohammed Safwat. All rights reserved.
//

import XCTest
import Mockingjay
import SwiftyJSON

extension XCTest {
    func stub(urlString: String, jsonFileName: String) {
        let data = getData(fromJSONFile: jsonFileName)
        stub(everything, jsonData(data))
    }
    
    func stub(urlString: String, error: NSError) {
        stub(everything, failure(error))
    }
    
    func stub(jsonFileName: String) -> JSON? {
        var json: JSON?
        let data = getData(fromJSONFile: jsonFileName)
        
        do {
            json = try JSON(data: data)
        } catch {
            return json
        }
        return json
    }
    
    private func getData(fromJSONFile jsonFileName: String) -> Data {
        let path = Bundle(for: type(of: self)).path(forResource: jsonFileName, ofType: "json")
        let nsdata = NSData(contentsOfFile: path!)
        return Data(referencing: nsdata!)
    }
}
