//
//  ErrorView.swift
//  OpenWeather
//
//  Created by Bertrand on 19/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit

fileprivate let errorViewShadowOpacity: Float = 1
fileprivate let errorViewWidthOffset: Int = 0
fileprivate let errorViewHeightOffset: Int = 3
fileprivate let twelve: CGFloat = 12
fileprivate let twentyFour: CGFloat = 24
fileprivate let errorViewAnimationDuration: Double = 0.33
fileprivate let nullAlpha: CGFloat = 0.0
fileprivate let defaultAlpha: CGFloat = 1.0

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
            sharedViewInstance.layer.shadowOpacity = errorViewShadowOpacity
            sharedViewInstance.layer.shadowOffset = CGSize(width: errorViewWidthOffset, height: errorViewHeightOffset)
        }
        
        sharedViewInstance.errorMessageMabel.text = message
        
        if sharedViewInstance?.superview == nil {
            let y = displayedViewController.view.frame.height - sharedViewInstance.frame.size.height - twelve
            sharedViewInstance.frame = CGRect(x: twelve,
                                              y: y,
                                              width: displayedViewController.view.frame.size.width - twentyFour,
                                              height: sharedViewInstance.frame.size.height)
            sharedViewInstance.alpha = nullAlpha
            
            displayedViewController.view.addSubview(sharedViewInstance)
            sharedViewInstance.fadeIn()
        }
    }
    
    //MARK: - Animations
    fileprivate func fadeIn() {
        UIView.animate(withDuration: errorViewAnimationDuration) { _ in
            self.alpha = defaultAlpha
        }
    }
    
    @objc
    fileprivate func fadeOut() {
        UIView.animate(withDuration: errorViewAnimationDuration, animations: {
            self.alpha = nullAlpha
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
