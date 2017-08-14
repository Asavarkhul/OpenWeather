//
//  AppDelegate.swift
//  OpenWeather
//
//  Created by Bertrand on 10/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    class func sharedDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    lazy var storyBoard: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Appearence.customize()
        
        let currentCity = City.getCurrentCity()
        let viewModel = HomeViewModel(initWith: currentCity)
        
        let navigationController = storyBoard.instantiateViewController(withIdentifier: "Home") as! UINavigationController
        var homeViewController = navigationController.viewControllers.first as! HomeViewController
        homeViewController.bindViewModel(to: viewModel)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}
