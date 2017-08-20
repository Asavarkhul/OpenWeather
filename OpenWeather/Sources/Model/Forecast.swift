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

fileprivate let twelvePM = "12"
fileprivate let nineAM = "9"
fileprivate let sixAM = "6"

class Forecast: Object, Mappable {
    // MARK: - Properties
    dynamic var comment: String = ""
    dynamic var iconURL: String = ""
    dynamic var date: Date?
    dynamic var day: String = ""
    dynamic var hour: String = ""
    dynamic var temperature: Double = 0.0
    dynamic var cloudiness: Int = 0
    dynamic var windSpeed: Int = 0
    dynamic var uid: String = ""
    
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    //MARK: Mappable
    convenience required init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        comment <- map["weather.0.description"]
        iconURL <- (map["weather.0.icon"], IconURLTransformer())
        date <- (map["dt"], DateTransform())
        temperature <- map["main.temp"]
        cloudiness <- map["clouds.all"]
        windSpeed <- map["wind.speed"]
    }
}

extension Forecast: IdentifiableType {
    var identity: Date {
        return self.date ?? Date()
    }
}

extension Forecast {
    static func filter(_ forecasts: [Forecast], for day: String) -> [Forecast]? {
        var localForecasts: [Forecast] = []
        forecasts.forEach { forecast -> () in
            if forecast.day == day {
                localForecasts.append(forecast)
            }
        }
        return localForecasts
    }
    
    static func filterFromTomorrow(_ forecasts: [Forecast]) -> [Forecast]? {
        var localForecasts: [Forecast] = []
        forecasts.forEach { forecast -> Void in
            if !localForecasts.contains(where: { $0.day == forecast.day }) {
                guard let mostExplicitForecast = forecast.mostExplicit() else {
                    return
                }
                localForecasts.append(mostExplicitForecast)
            }
        }
        return localForecasts
    }
    
    fileprivate func mostExplicit() -> Forecast? {
        let forecast = self
        guard let tomorrow = Day.tomorrowMinusCurrentHour(), let date = forecast.date else {
            return nil
        }
        if date >= tomorrow {
            if forecast.hour == twelvePM {
                return forecast
            } else if forecast.hour == nineAM {
                return forecast
            } else if forecast.hour == sixAM {
                return forecast
            }
        }
        return nil
    }
}
