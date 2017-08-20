//
//  TestData.swift
//  OpenWeather
//
//  Created by Bertrand on 20/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import ObjectMapper

@testable import OpenWeather

class TestData {
    static let city: City = {
        let newCity = City()
        newCity.identifier = 2988507
        newCity.name = "Paris"
        return newCity
    }()
    
    static var conditionObject: Condition? {
        return Mapper<Condition>().map(JSON: JSONParser.readJSONFile(forName: "Condition"))
    }
    
    static var forecasts: [Forecast]? {
        var jsonResponse: [String: Any]?
        jsonResponse = JSONParser.readJSONFile(forName: "Forecast")
        guard
            jsonResponse != nil,
            let list = jsonResponse?["list"],
            let jsonArray = list as? [[String : Any]] else {
            return []
        }
        return Mapper<Forecast>().mapArray(JSONArray: jsonArray)
    }
    
    static var forecast: Forecast? {
        return forecasts?.first
    }
    
    
}
