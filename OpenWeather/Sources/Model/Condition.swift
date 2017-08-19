//
//  WeatherCondition.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import ObjectMapper
import RxDataSources

class Condition: Object, Mappable {
    // MARK: - Properties
    dynamic var uid: Int = 0
    dynamic var identifier: Int64 = 0
    dynamic var comment: String = ""
    dynamic var iconURL: String = ""
    dynamic var temperature: Double = 0.0
    dynamic var windSpeed: Double = 0.0
    dynamic var pressure: Double = 0.0
    dynamic var humidity: Double = 0.0
    
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    // MARK: Mappable
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        identifier <- map["weather.0.id"]
        comment <- map["weather.0.description"]
        iconURL <- (map["weather.0.icon"], IconURLTransformer())
        temperature <- map["main.temp"]
        windSpeed <- map["wind.speed.value"]
        pressure <- map["main.pressure"]
        humidity <- map["main.humidity"]
    }
}

extension Condition: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : uid
    }
}
