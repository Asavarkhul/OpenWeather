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

typealias ForecastsSection = AnimatableSectionModel<String, Forecast>

public struct HomeViewModel {
    // MARK: - Properties
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
    
    var forecastsForNextFiveDaysSection: Observable<[ForecastsSection]> {
        return self.forecastService.forecasts()
            .map { results in
                guard let forecasts = Forecast.filterFromTomorrow(results.toArray()) else {
                    return []
                }
                return [
                    ForecastsSection(model: "Forcasts", items: forecasts)
                ]
        }
    }
}
