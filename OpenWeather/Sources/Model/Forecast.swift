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
import Alamofire

class Forecast: Object, Mappable {
    // MARK: - Properties
    dynamic var comment: String = ""
    dynamic var iconURL: String = ""
    dynamic var date: Date?
    dynamic var day: String = ""
    dynamic var temperature: Double = 0.0
    dynamic var uid: String = ""
    
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    //MARK: Mappable
    convenience required init?(map: Map) {
        self.init()
    }
    
    let dateformatter: DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM-dd-yyyy"
        dateformatter.timeZone = TimeZone(identifier: "GMT")
        return dateformatter
    }()
    
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

extension Forecast {
    static func loadForecast(for city: City, completion: @escaping (_ forecasts: [Forecast]) -> Void) {
        Alamofire.request(OpenWeatherRouter.forecast(cityId: city.identifier, units: .Metric))
            .responseJSON() { response in
                guard let jsonResponse = response.result.value as? [String: Any], let list = jsonResponse["list"] else {
                    return
                }
                guard let jsonArray = list as? [[String : Any]] else {
                    return
                }
                let forecasts = Mapper<Forecast>().mapArray(JSONArray: jsonArray)
                completion(forecasts)
        }
    }
}
