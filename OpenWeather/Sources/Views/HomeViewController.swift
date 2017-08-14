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

open class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    internal var viewModel: HomeViewModel!
    
    fileprivate lazy var conditionDataSource: RxTableViewSectionedAnimatedDataSource<ConditionSection> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<ConditionSection>()
        dataSource.configureCell = {dataSource, tableView, indexPath, condition in
            let cell = tableView.dequeueReusableCellWithClass(UITableViewCell.self)
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, sectionIndex in
            let section = dataSource.sectionModels[sectionIndex]
            return section.model
        }
        
        dataSource.canEditRowAtIndexPath = { _ in false }
        dataSource.canMoveRowAtIndexPath = { _ in false }
        
        dataSource.animationConfiguration = RxDataSources.AnimationConfiguration(
            insertAnimation: .automatic,
            reloadAnimation: .none,
            deleteAnimation: .automatic)
        
        return dataSource
    }()
    
    fileprivate lazy var forecastDataSource: RxCollectionViewSectionedAnimatedDataSource<ForecastsSection> = {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<ForecastsSection>()
        dataSource.configureCell = { dataSource, collectionView, indexPath, session in
            let cell = collectionView.dequeueReusableCellWithClass(UICollectionViewCell.self, forIndexPath: indexPath)
            
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
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.view.backgroundColor = .clear
        self.view.backgroundColor = UIColor.appBlue()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Weather in \(self.viewModel.city.name)"
    }
}

extension HomeViewController: BindableType {
    
    func bindViewModel() {
        viewModel.conditions
            .bind(to: tableView.rx.items(dataSource: conditionDataSource))
            .addDisposableTo(rx_disposeBag)
        
        viewModel.forecasts
            .bind(to: collectionView.rx.items(dataSource: forecastDataSource))
            .addDisposableTo(rx_disposeBag)
    }
}
