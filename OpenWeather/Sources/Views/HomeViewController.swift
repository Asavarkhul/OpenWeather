//
//  HomeViewController.swift
//  OpenWeather
//
//  Created by Bertrand on 14/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import NSObject_Rx
import Realm
import RxRealm
import RxCocoa

fileprivate let ConditionCellIdentifier = "ConditionCellIdentifier"
fileprivate let ForecastCellIdentifier = "ForecastCellIdentifier"
fileprivate let minimumInteritemSpacingForSection: CGFloat = 1.0
fileprivate let minimumLineSpacingForSection: CGFloat = 1.0
fileprivate let sizeForItem: CGSize = CGSize(width: 100, height: 100)

open class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    internal var viewModel: HomeViewModel!
    
    fileprivate lazy var forecastDataSource: RxCollectionViewSectionedAnimatedDataSource<ForecastsSection> = {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<ForecastsSection>()
        dataSource.configureCell = { dataSource, collectionView, indexPath, forecast in
            let cell = collectionView.dequeueReusableCellWithClass(ForecastCollectionViewCell.self, forIndexPath: indexPath)
            cell.configure(with: forecast)
            return cell
        }
        
        dataSource.canMoveItemAtIndexPath = { _ in false }
        
        dataSource.animationConfiguration = RxDataSources.AnimationConfiguration(
            insertAnimation: .automatic,
            reloadAnimation: .none,
            deleteAnimation: .automatic)
        
        return dataSource
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor.appBlue()
        
        collectionView.registerNib(cellClass: ForecastCollectionViewCell.self)
        initLabels()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.deselectItems()
    }
    
    fileprivate func deselectItems() {
        guard let selectedItemIdexpaths = self.collectionView.indexPathsForSelectedItems else {
            return
        }
        for indexpath in selectedItemIdexpaths {
            self.collectionView.deselectItem(at: indexpath, animated: true)
        }
    }
    
    fileprivate func initLabels() {
        self.temperatureLabel.text = "T°"
        self.iconLabel.text = "W"
        self.currentDateLabel.text = fullDateFormat.string(from: Date())
    }
    
    fileprivate func transition(toDetailViewOf forecast: Forecast) {
        let viewModel = ForecastDetailViewModel(initWith: forecast)
        
        let navigationController = AppDelegate.sharedDelegate().storyBoard.instantiateViewController(withIdentifier: "Detail") as! UINavigationController
        var forecastDetailViewController = navigationController.viewControllers.first as! ForecastDetailViewController
        forecastDetailViewController.bindViewModel(to: viewModel)
        
        navigationController.modalPresentationStyle = .formSheet
        navigationController.modalTransitionStyle = .coverVertical
        self.present(navigationController, animated: true, completion: nil)
    }
    
    fileprivate func configureLabels(with condition: Condition) {
        self.temperatureLabel.text = "\(Int(condition.temperature))°"
        self.iconLabel.text = "\(condition.iconURL)"
    }
}

extension HomeViewController: BindableType {
    func bindViewModel() {
        viewModel.cityService.update()
            .subscribe()
            .addDisposableTo(rx_disposeBag)
        
        viewModel.forecastsForNextFiveDaysSection
            .bind(to: collectionView.rx.items(dataSource: forecastDataSource))
            .addDisposableTo(rx_disposeBag)
        
        viewModel.city.rx.observe(String.self, "name")
            .subscribe(onNext: {[weak self] name in
                guard let strongSelf = self else {
                    return
                }
                guard let name = name else {
                    strongSelf.title = "Weather"
                    return
                }
                strongSelf.title = "Weather in \(name)"
            })
            .addDisposableTo(rx_disposeBag)
        
        viewModel.conditions
            .subscribe(onNext: {[weak self] conditions in
                guard let strongSelf = self else {
                    return
                }
                guard let condition = conditions.first else {
                    return
                }
                strongSelf.configureLabels(with: condition)
            })
            .addDisposableTo(rx_disposeBag)
        
        collectionView.rx.itemSelected
            .map {[weak self] indexPath -> Forecast in
                return try self?.forecastDataSource.model(at: indexPath) as! Forecast
            }
            .subscribe(onNext: {[weak self] forecast in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.transition(toDetailViewOf: forecast)
            })
            .addDisposableTo(rx_disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacingForSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
}
