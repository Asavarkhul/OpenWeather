//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by Bertrand on 11/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action
import RealmSwift
import RxRealm

typealias ConditionSection = AnimatableSectionModel<String, Condition>
typealias ForecastsSection = AnimatableSectionModel<String, Forecast>

public struct HomeViewModel {
    internal let city: City!
    internal let cityService: CityService!
    fileprivate var conditionService = ConditionService()
    fileprivate var forecastService = ForecastService()
    
    let bag = DisposeBag()
    
    init(initWith city: City){
        self.city = city
        self.cityService = CityService(for: city)
    }
    
    var conditions: Observable<[Condition]> {
        return self.conditionService.conditions()
            .map { result in
                return result.toArray()
        }
    }
    
    var conditionSections: Observable<[ConditionSection]> {
        return self.conditionService.conditions()
            .map { results in
                return [
                    ConditionSection(model: "Conditions", items: results.toArray())
                ]
        }
    }
    
    var forecastsForNextFiveDaysSection: Observable<[ForecastsSection]> {
        return self.forecastService.forecasts()
            .map { results in
                var forecasts: [Forecast] = []
                let forecastsFromResult = results.toArray()
                let today = dayFormat.string(from: Date())
                forecastsFromResult.forEach { (forecast) -> () in
                    if !forecasts.contains(where: { $0.day == forecast.day }) {
                        if forecast.day != today {
                            forecasts.append(forecast)
                        }
                    }
                }
                return [
                    ForecastsSection(model: "Forcasts", items: forecasts)
                ]
        }
    }
    
    func onUpdate() -> CocoaAction {
        return CocoaAction {
            return self.cityService.update().map { _ in }
        }
    }
}
