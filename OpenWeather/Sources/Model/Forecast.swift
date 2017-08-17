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
            if !localForecasts.contains(where: { $0.day == forecast.day }) {
                guard let noonForecast = forecast.forNoon() else {
                    return
                }
                localForecasts.append(noonForecast)
            }
        }
        return localForecasts
    }
    
    fileprivate func forNoon() -> Forecast? {
        let forecast = self
        guard let tomorrow = Day.tomorrow() else {
            return nil
        }
        guard let date = forecast.date else {
            return nil
        }
        if forecast.hour == "12" && date >= tomorrow {
            return forecast
        }
        return nil
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
