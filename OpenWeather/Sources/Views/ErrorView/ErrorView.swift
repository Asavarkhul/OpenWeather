//
//  ErrorView.swift
//  OpenWeather
//
//  Created by Bertrand on 19/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit

class ErrorView: UIView {
    @IBOutlet weak var errorMessageMabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.fadeOut()
    }
    
    public static var sharedViewInstance: ErrorView!
    
    static func loadFromNib() -> ErrorView {
        let nibName = "\(self)".characters.split{$0 == "."}.map(String.init).last!
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! ErrorView
    }

    static func display(in viewController: UIViewController, withMessage message: String) {
        var displayedViewController = viewController
        
        if let tabBarController = viewController as? UITabBarController {
            displayedViewController = tabBarController.selectedViewController ?? viewController
        }
        
        if sharedViewInstance == nil {
            sharedViewInstance = loadFromNib()
            
            sharedViewInstance.layer.masksToBounds = false
            sharedViewInstance.layer.shadowColor = UIColor.darkGray.cgColor
            sharedViewInstance.layer.shadowOpacity = 1
            sharedViewInstance.layer.shadowOffset = CGSize(width: 0, height: 3)
        }
        
        sharedViewInstance.errorMessageMabel.text = message
        
        if sharedViewInstance?.superview == nil {
            let y = displayedViewController.view.frame.height - sharedViewInstance.frame.size.height - 12
            sharedViewInstance.frame = CGRect(x: 12,
                                              y: y,
                                              width: displayedViewController.view.frame.size.width - 24,
                                              height: sharedViewInstance.frame.size.height)
            sharedViewInstance.alpha = 0.0
            
            displayedViewController.view.addSubview(sharedViewInstance)
            sharedViewInstance.fadeIn()
        }
    }
    
    //MARK: - Animations
    fileprivate func fadeIn() {
        UIView.animate(withDuration: 0.33) { _ in
            self.alpha = 1.0
        }
    }
    
    @objc
    fileprivate func fadeOut() {
        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = 0.0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
