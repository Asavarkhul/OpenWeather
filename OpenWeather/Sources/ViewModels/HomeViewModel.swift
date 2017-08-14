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

typealias ConditionSection = AnimatableSectionModel<String, Condition>
typealias ForecastsSection = AnimatableSectionModel<String, Forecast>

public struct HomeViewModel {
    internal let city: City!
    fileprivate var conditionService = ConditionService()
    fileprivate var forecastService = ForecastService()
    
    init(initWith city: City){
        self.city = city
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
}
