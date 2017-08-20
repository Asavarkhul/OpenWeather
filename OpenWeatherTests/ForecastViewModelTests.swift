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

@testable import OpenWeather

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
    
}
