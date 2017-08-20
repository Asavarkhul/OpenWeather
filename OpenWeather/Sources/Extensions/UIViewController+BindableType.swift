import UIKit
import RxSwift

protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        if #available(iOS 9.0, *) {
            loadViewIfNeeded()
        } else {
            _ = self.view // Wired behaviour on simulator, need to test it on a device with iOS 8
        }
        bindViewModel()
    }
}
