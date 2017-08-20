//
//  ForecastService.swift
//  OpenWeather
//
//  Created by Bertrand on 14/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import Alamofire
import ObjectMapper

struct ForecastService {
    init() {}
    
    @discardableResult
    func forecasts() -> Observable<Results<Forecast>> {
        let result = Launcher.withRealm("Getting conditions") { realm -> Observable<Results<Forecast>> in
            let realm = try Realm()
            let forecasts = realm.objects(Forecast.self)
            return Observable.collection(from: forecasts)
        }
        return result ?? .empty()
    }
    
    func loadForecast(for city: City,
                      success: @escaping (_ forecasts: [Forecast]) -> Void,
                      failure: @escaping (_ error: Error) -> Void) {
        Alamofire.request(OpenWeatherRouter.forecast(cityId: city.identifier, units: .Metric))
            .responseJSON() { response in
                guard let httpURLResponse = response.response else {
                    failure(OpenWeatherRouter.ApiError.serverFailure)
                    return
                }
                if okRequestStatusCode ..< multipleChoicesStatusCode ~= httpURLResponse.statusCode {
                    guard let jsonResponse = response.result.value as? [String: Any], let list = jsonResponse["list"], let jsonArray = list as? [[String : Any]] else {
                        failure(OpenWeatherRouter.ApiError.cityNotFound)
                        return
                    }
                    let forecasts = Mapper<Forecast>().mapArray(JSONArray: jsonArray)
                    success(forecasts)
                } else if httpURLResponse.statusCode == unauthorizedStatusCode {
                    failure(OpenWeatherRouter.ApiError.invalidKey)
                } else if badRequestStatusCode ..< internalServerErrorStatusCode ~= httpURLResponse.statusCode {
                    failure(OpenWeatherRouter.ApiError.cityNotFound)
                } else {
                    failure(OpenWeatherRouter.ApiError.serverFailure)
                }
        }
    }
}
