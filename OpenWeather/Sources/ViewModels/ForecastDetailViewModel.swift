//
//  ForecastDetailViewModel.swift
//  OpenWeather
//
//  Created by Bertrand on 16/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Action
import RealmSwift
import RxRealm

public struct ForecastDetailViewModel {
    internal let forecast: Forecast!
    fileprivate var conditionService = ConditionService()
    fileprivate var forecastService = ForecastService()
    
    let bag = DisposeBag()
    
    init(initWith forecast: Forecast){
        self.forecast = forecast
    }

    func forecasts(for day: String) -> Observable<[ForecastsSection]>{
        return self.forecastService.forecasts()
            .map { results in
                var forecasts: [Forecast] = []
                let forecastsFromResult = results.toArray()
                forecastsFromResult.forEach { (forecast) -> () in
                    if forecast.day == day {
                        forecasts.append(forecast)
                    }
                }
                return [
                    ForecastsSection(model: "", items: forecasts)
                ]
        }
    }
}
