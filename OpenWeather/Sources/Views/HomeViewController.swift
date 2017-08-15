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

fileprivate let ConditionCellIdentifier = "ConditionCellIdentifier"
fileprivate let ForecastCellIdentifier = "ForecastCellIdentifier"
fileprivate let minimumInteritemSpacingForSection: CGFloat = 1.0
fileprivate let minimumLineSpacingForSection: CGFloat = 1.0
fileprivate let sizeForItem: CGSize = CGSize(width: 100, height: 100)

open class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var currentDateLabel: UILabel!
    
    internal var viewModel: HomeViewModel!
    
    fileprivate lazy var conditionDataSource: RxTableViewSectionedAnimatedDataSource<ConditionSection> = {
        let dataSource = RxTableViewSectionedAnimatedDataSource<ConditionSection>()
        dataSource.configureCell = {dataSource, tableView, indexPath, condition in
            let cell = tableView.dequeueReusableCellWithClass(ConditionTableViewCell.self)
            cell.textLabel?.text = condition.title
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
        dataSource.configureCell = { dataSource, collectionView, indexPath, forecast in
            let cell = collectionView.dequeueReusableCellWithClass(ForecastCollectionViewCell.self, forIndexPath: indexPath)
            cell.dayLabel.text = forecast.comment
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.registerNib(cellClass: ConditionTableViewCell.self)
        collectionView.registerNib(cellClass: ForecastCollectionViewCell.self)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Weather in \(self.viewModel.city.name)"
        UIApplication.shared.statusBarStyle = .lightContent
    }
}

extension HomeViewController: BindableType {
    func bindViewModel() {
        viewModel.cityService.update()
            .subscribe()
            .addDisposableTo(rx_disposeBag)
        
        viewModel.conditions
            .bind(to: tableView.rx.items(dataSource: conditionDataSource))
            .addDisposableTo(rx_disposeBag)
        
        viewModel.forecastsForNextFiveDays
            .bind(to: collectionView.rx.items(dataSource: forecastDataSource))
            .addDisposableTo(rx_disposeBag)
        
        let condition = Observable.from(optional: viewModel.city.currentCondition).asDriver(onErrorJustReturn: nil)
        
        condition.map { "\($0?.temperature ?? 0)°" }
            .drive(temperatureLabel.rx.text)
            .addDisposableTo(rx_disposeBag)
        
        condition.map { $0?.iconURL }
            .drive(iconLabel.rx.text)
            .addDisposableTo(rx_disposeBag)
        
        condition.map { _ in fullDateFormat.string(from: Date()) }
            .drive(currentDateLabel.rx.text)
            .addDisposableTo(rx_disposeBag)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return sizeForItem
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumInteritemSpacingForSection
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
}
