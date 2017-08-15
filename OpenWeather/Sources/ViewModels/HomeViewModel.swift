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
    
    var conditions: Observable<[ConditionSection]> {
        return self.conditionService.conditions()
            .map { results in
                return [
                    ConditionSection(model: "Conditions", items: results.toArray())
                ]
        }
    }
    
    var forecasts: Observable<[ForecastsSection]> {
        return self.forecastService.forecasts()
            .map { results in
                return [
                    ForecastsSection(model: "Forcasts", items: results.toArray())
                ]
        }
    }
    
    var forecastsForNextFiveDays: Observable<[ForecastsSection]> {
        return self.forecastService.forecasts()
            .map { results in
                var forecasts: [Forecast] = []
                let forecastsFromResult = results.toArray()
                
                forecastsFromResult.forEach { (p) -> () in
                    if !forecasts.contains(where: { $0.day == p.day }) {
                        forecasts.append(p)
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
