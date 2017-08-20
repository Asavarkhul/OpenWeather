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

@testable import OpenWeather

class HomeViewModelTests: XCTestCase {
    fileprivate func createViewModel() -> HomeViewModel {
        return HomeViewModel(initWith: TestData.city)
    }
    
    func test_whenInitialized_storesInitParams() {
        let viewModel = createViewModel()
        
        XCTAssertNotNil(viewModel.city)
    }
    
    func test_whenInitialized_bindsData() {
        let asyncExpect = expectation(description: "fullfill test")
        Realm.useCleanMemoryRealmByDefault(identifier: #function)
        
        let realm = try! Realm()
        guard let condition = TestData.conditionObject else {
            return
        }
        
        let viewModel = createViewModel()
        try! realm.write {
            realm.add(condition)
            viewModel.city.currentCondition = condition
        }
        
        _ = viewModel.conditions.asObservable()
            .subscribe(onNext: { _ in
                asyncExpect.fulfill()
            })
        
        waitForExpectations(timeout: 1.0, handler: { error in
            XCTAssertNil(error, "error: \(error!.localizedDescription)")
            XCTAssertNotNil(viewModel.city.currentCondition, "Condition is nil")
            XCTAssertEqual(viewModel.city.currentCondition, condition)
        })
    }
}
