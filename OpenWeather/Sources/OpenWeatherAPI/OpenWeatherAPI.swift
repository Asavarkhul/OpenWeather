//
//  OpenWeatherAPI.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

fileprivate let okRequestStatusCode: Int = 200
fileprivate let multipleChoicesStatusCode: Int = 300
fileprivate let badRequestStatusCode: Int = 400
fileprivate let unauthorizedStatusCode: Int = 401
fileprivate let internalServerErrorStatusCode: Int = 500
fileprivate let serverErrorStatusCode: Int = 600

// MARK: - Units
public enum Units: String {
    case Metric = "metric"
}

enum OpenWeatherRouter {
    case current(cityId:Int, units:Units)
    case forecast(cityId:Int, units:Units)
}

extension OpenWeatherRouter: URLRequestConvertible {
    fileprivate static let baseURLString = "http://api.openweathermap.org/data/2.5/"
    fileprivate static let appID = "65a8f57997814c9afe51ce434d073302"
    
    fileprivate var method: HTTPMethod {
        switch self {
        case .current:
            return .get
        case .forecast:
            return .get
        }
    }
    
    fileprivate var path: String {
        switch self {
        case .current:
            return "weather"
        case .forecast:
            return "forecast"
        }
    }
    
    fileprivate var parameters: Parameters {
        switch self {
        case .current(let cityId, let units):
            return ["id": cityId, "units": units.rawValue, "appid": OpenWeatherRouter.appID]
        case .forecast(let cityId, let units):
            return ["id": cityId, "units": units.rawValue, "appid": OpenWeatherRouter.appID]
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try OpenWeatherRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        
        return urlRequest
    }
}
