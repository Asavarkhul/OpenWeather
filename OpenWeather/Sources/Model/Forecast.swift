//
//  WeatherForecast.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import RxDataSources

class Forecast: Object, Mappable {
    // MARK: - Properties
    dynamic var comment = ""
    dynamic var iconURL = ""
    dynamic var date: Date?
    dynamic var temperature: Double = 0.0
    
    //MARK: Mappable
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        comment <- map["weather.0.description"]
        iconURL <- (map["weather.0.icon"], IconURLTransformer())
        date <- (map["dt"], DateTransform())
        temperature <- map["main.temp"]
    }
}

extension Forecast: IdentifiableType {
    var identity: Date {
        return self.date ?? Date()
    }
}
