//
//  ConditionsService.swift
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

struct ConditionService {
    init() {}
    
    @discardableResult
    func conditions() -> Observable<Results<Condition>> {
        let result = Launcher.withRealm("Getting conditions") { realm -> Observable<Results<Condition>> in
            let conditions = realm.objects(Condition.self)
            return Observable.collection(from: conditions)
        }
        return result ?? .empty()
    }
    
    func loadCurrentCondition(for city: City,
                                     success:@escaping (_ condition: Condition) -> Void,
                                     failure: @escaping (_ error: Error) -> Void) {
        Alamofire.request(OpenWeatherRouter.current(cityId: city.identifier, units: .Metric))
            .responseJSON() { dataResponse in
                guard let httpURLResponse = dataResponse.response else {
                    failure(OpenWeatherRouter.ApiError.serverFailure)
                    return
                }
                if okRequestStatusCode ..< multipleChoicesStatusCode ~= httpURLResponse.statusCode {
                    guard let jsonResponse = dataResponse.result.value, let condition = Mapper<Condition>().map(JSON: jsonResponse as! [String : Any]) else {
                        failure(OpenWeatherRouter.ApiError.cityNotFound)
                        return
                    }
                    success(condition)
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
