//
//  ForecastViewModelTests.swift
//  OpenWeather
//
//  Created by Bertrand on 20/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import ObjectMapper
import RealmSwift
import RxRealm
import RxDataSources

@testable import OpenWeather

fileprivate let totalForcastsNumberFromJSONFile = 40
fileprivate let forcastsForAPlainDay = 8

class ForecastViewModelTests: XCTestCase {
    fileprivate func createViewModel() -> ForecastDetailViewModel {
        guard let forecast = TestData.forecast else {
            fatalError("No forecast from json file")
        }
        return ForecastDetailViewModel(initWith: forecast)
    }
    
    func test_whenInitialized_storesInitParams() {
        let viewModel = createViewModel()
        
        XCTAssertNotNil(viewModel.forecast)
    }
    
    func test_whenInitialized_bindForecasts() {
        let asyncExpect = expectation(description: "fullfill test")
        
        let realm = try! Realm()
        guard let forecasts = TestData.forecastObjects else {
            return
        }

        let viewModel = createViewModel()
        try! realm.write {
            for forecast in forecasts {
                if let date = forecast.date {
                    forecast.hour = hourFormat.string(from: date)
                    forecast.day = dayFormat.string(from: date)
                }
                forecast.uid = forecast.date?.description ?? Date().timeIntervalSinceReferenceDate.description
            }
            realm.add(forecasts, update: true)
        }
        
        var forecastSectionEmitted = [[ForecastsSection]]()
        _ = viewModel.forecasts(for: "20")
            .subscribe(onNext: { value in
                forecastSectionEmitted.append(value)
                asyncExpect.fulfill()
            })
        
        let forecastSection = forecastSectionEmitted.first?.first
        let forecastItems = forecastSection?.items
        
        waitForExpectations(timeout: 1.0, handler: { error in
            XCTAssertNil(error, "error: \(error!.localizedDescription)")
            XCTAssertTrue(forecastSectionEmitted.count > 0)
            XCTAssertTrue(forecastItems?.count == forcastsForAPlainDay)
        })
    }
    
    func test_forecastFromJson_correctlyAdded() {
        let forecasts = TestData.forecastObjects
        
        XCTAssertNotNil(forecasts)
        XCTAssert(forecasts?.count == totalForcastsNumberFromJSONFile, "Forecasts from Json file are not correctly added")
    }   
}
