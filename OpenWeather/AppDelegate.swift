//
//  AppDelegate.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    lazy var storyBoard: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()
    
    lazy var city: City = {
        return City.getCurrentCityIfExistsOrCreatesOne()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Appearence.customize()
        
        let viewModel = HomeViewModel(initWith: city)
        let navigationController = storyBoard.instantiateViewController(withIdentifier: homeViewControllerIdentifier) as! UINavigationController
        var homeViewController = navigationController.viewControllers.first as! HomeViewController
        homeViewController.bindViewModel(to: viewModel)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let cityService = CityService(for: city)
        cityService.update() { error in
            guard let viewController = self.window?.rootViewController else {
                return
            }
            if let error = error as? OpenWeatherRouter.ApiError {
                switch error {
                case .cityNotFound:
                    ErrorView.display(in: viewController, withMessage: "Bad city name")
                case .invalidKey:
                    ErrorView.display(in: viewController, withMessage: "Invalid Api Key")
                case .serverFailure:
                    ErrorView.display(in: viewController, withMessage: "Server error")
                }
            } else if let _ = error as? CityService.RealmError {
                ErrorView.display(in: viewController, withMessage: "Database failed in savin data")
            }
        }
    }
}
