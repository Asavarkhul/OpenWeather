//
//  ConditionViewModelTests.swift
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

fileprivate let fiveNextForcast = 5

class HomeViewModelTests: XCTestCase {
    fileprivate func createViewModel() -> HomeViewModel {
        return HomeViewModel(initWith: TestData.city)
    }
    
    func test_whenInitialized_storesInitParams() {
        let viewModel = createViewModel()
        
        XCTAssertNotNil(viewModel.city)
    }
    
    func test_whenInitialized_ForecastsCorrectlyBinded() {
        let asyncExpect = expectation(description: "fullfill test")
        Realm.useCleanMemoryRealmByDefault(identifier: #function)
        
        let realm = try! Realm()
        guard let condition = TestData.conditionObject else {
            return
        }
        
        let viewModel = createViewModel()
        try! realm.write {
            realm.add(condition, update: true)
            viewModel.city.currentCondition = condition
        }
        
        var conditionEmitted = [[Condition]]()
        _ = viewModel.conditions
            .subscribe(onNext: { value in
                conditionEmitted.append(value)
                asyncExpect.fulfill()
            })
        
        waitForExpectations(timeout: 1.0, handler: { error in
            XCTAssertNil(error, "error: \(error!.localizedDescription)")
            XCTAssertTrue(conditionEmitted.count == 1)
            XCTAssertNotNil(viewModel.city.currentCondition, "Condition is nil")
            XCTAssertEqual(viewModel.city.currentCondition, condition)
        })
    }
    
    func test_whenInitialized_ConditionsCorrectlyBinded() {
        let asyncExpect = expectation(description: "fullfill test")
        
        let realm = try! Realm()
        guard let forecasts = TestData.forecastObjects else {
            return
        }
        
        let viewModel = createViewModel()
        try! realm.write {
            realm.add(forecasts, update: true)
        }
        
        var forecastSectionEmitted = [[ForecastsSection]]()
        _ = viewModel.forecastsForNextFiveDaysSection
            .subscribe(onNext: { value in
                forecastSectionEmitted.append(value)
                asyncExpect.fulfill()
            })
        
        let forecastSection = forecastSectionEmitted.first?.first
        let forecastItems = forecastSection?.items
        
        waitForExpectations(timeout: 1.0, handler: { error in
            XCTAssertNil(error, "error: \(error!.localizedDescription)")
            XCTAssertTrue(forecastItems?.count == fiveNextForcast)
        })
    }
}
