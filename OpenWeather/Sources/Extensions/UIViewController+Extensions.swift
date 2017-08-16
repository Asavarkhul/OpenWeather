//
//  UIViewController+Extensions.swift
//  OpenWeather
//
//  Created by Bertrand on 16/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public enum DismissButtonStyle {
        case done
        
        func newBarButtonItem(_ target: AnyObject?, action: Selector) -> UIBarButtonItem {
            switch self {
            case .done:
                return UIBarButtonItem(
                    barButtonSystemItem: .done,
                    target: target,
                    action: action
                )
            }
        }
    }
    
    public func updateDismissButton(style: DismissButtonStyle = .done, animated: Bool) {
        if navigationController?.viewControllers.first == self {
            let barButtonItem = style.newBarButtonItem(self, action: #selector(UIViewController._dismissViewControllerAnimated))
            navigationItem.setLeftBarButton(barButtonItem, animated: animated)
        }
        else {
            navigationItem.setLeftBarButton(nil, animated: animated)
        }
    }
    
    @objc fileprivate func _dismissViewControllerAnimated() {
        dismiss(animated: true, completion: nil)
    }
}
