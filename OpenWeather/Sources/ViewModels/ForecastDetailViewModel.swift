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

public struct ForecastDetailViewModel {
    // MARK: - Properties
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
                guard let forecasts = Forecast.filter(results.toArray(), for: day) else {
                    return []
                }
                return [
                    ForecastsSection(model: "", items: forecasts)
                ]
        }
    }
}
