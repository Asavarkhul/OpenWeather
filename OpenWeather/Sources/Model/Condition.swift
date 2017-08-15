//
//  WeatherCondition.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift
import Unbox
import Alamofire
import ObjectMapper
import RxDataSources

class Condition: Object, Mappable {
    // MARK: - Properties
    dynamic var uid: Int = 0
    dynamic var identifier: Int64 = 0
    dynamic var title: String = ""
    dynamic var comment: String = ""
    dynamic var iconURL: String = ""
    dynamic var temperature: Double = 0.0
    dynamic var minTemperature: Double = 0.0
    dynamic var maxTemperature: Double = 0.0
    dynamic var windSpeed: Double = 0.0
    dynamic var windName: String = ""
    dynamic var precipitation: Double = 0.0
    dynamic var precipitationType: String = ""
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
        title <- map["weather.0.main"]
        comment <- map["weather.0.description"]
        iconURL <- (map["weather.0.icon"], IconURLTransformer())
        
        temperature <- map["main.temp"]
        minTemperature <- map["main.temp_min"]
        maxTemperature <- map["main.temp_max"]
        
        windSpeed <- map["wind.speed.value"]
        windName <- map["wind.speed.name"]
        
        precipitation <- map["precipitation.value"]
        precipitationType <- map["precipitation.mode"]
        
        pressure <- map["main.pressure"]
        humidity <- map["main.humidity"]
    }
}

extension Condition: IdentifiableType {
    var identity: Int {
        return self.isInvalidated ? 0 : uid
    }
}

extension Condition {
    static func loadCurrentCondition(for city: City, success:@escaping (_ condition: Condition) -> Void) {
        Alamofire.request(OpenWeatherRouter.current(cityId: city.identifier, units: .Metric))
            .responseJSON() { response in
                guard let jsonResponse = response.result.value else {
                    return
                }
                
                guard let condition = Mapper<Condition>().map(JSON: jsonResponse as! [String : Any]) else {
                    return
                }
                success(condition)
        }
    }
}
