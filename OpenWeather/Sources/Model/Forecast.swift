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
            guard let tomorrow = Day.tomorrowMinusCurrentHour(), let date = forecast.date else { return }
            if date >= tomorrow {
                localForecasts.append(forecast)
            }
        }
        
        var days = [Int]()
        localForecasts.forEach { forecast -> Void in
            if forecast.day != "" {
                guard let day = Int(forecast.day) else { return }
                days.append(day)
            }
        }
        
        let sortedDays = days.sorted()
        let duplicatesDays = Array(Set(sortedDays.filter({ (i: Int) in sortedDays.filter({ $0 == i }).count > 1})))
        
        var correspondingsDaysForecastFromDuplicates = [Forecast]()
        duplicatesDays.forEach { day in
            forecasts.forEach { forecast in
                if forecast.day == day.description {
                    correspondingsDaysForecastFromDuplicates.append(forecast)
                }
            }
        }
        
        var mostExplicitForecasts = [Forecast]()
        duplicatesDays.forEach { day in
            var correspondingDaysForecasts = [Forecast]()
            correspondingsDaysForecastFromDuplicates.forEach { forecast in
                if forecast.day == day.description {
                    correspondingDaysForecasts.append(forecast)
                }
            }
            
            let sortedForecasts = correspondingDaysForecasts.sorted(by: { $0.day < $1.day })

            var forecastsInRange = [Forecast]()
            sortedForecasts.forEach { forecast in
                guard let hour = Int(forecast.hour) else { return }
                if 0...12 ~= hour {
                    forecastsInRange.append(forecast)
                }
            }
            
            guard let maxForecastInRange = forecastsInRange.max(by: { forecastOne, forecastTwo -> Bool in
                guard let dateOne = forecastOne.date else { return false }
                guard let dateTwo = forecastTwo.date else { return false }
                return dateOne < dateTwo
            }) else {
                return
            }
            
            mostExplicitForecasts.append(maxForecastInRange)
        }
        let sortedExplicitsForecasts = mostExplicitForecasts.sorted(by: { $0.day < $1.day })
        return sortedExplicitsForecasts
    }
}
