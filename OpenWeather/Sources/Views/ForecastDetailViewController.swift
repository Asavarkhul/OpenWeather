//
//  ForecastDetailViewController.swift
//  OpenWeather
//
//  Created by Bertrand on 16/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import NSObject_Rx

public final class ForecastDetailViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    internal var viewModel: ForecastDetailViewModel!
    var disposeBag = DisposeBag()
    
    fileprivate lazy var forecastDataSource: RxCollectionViewSectionedAnimatedDataSource<ForecastsSection> = {
        let dataSource = RxCollectionViewSectionedAnimatedDataSource<ForecastsSection>()
        dataSource.configureCell = { dataSource, collectionView, indexPath, forecast in
            let cell = collectionView.dequeueReusableCellWithClass(ForecastDetailCollectionViewCell.self, forIndexPath: indexPath)
            cell.configure(with: forecast)
            return cell
        }
        
        dataSource.canMoveItemAtIndexPath = { _ in true }
        
        dataSource.animationConfiguration = RxDataSources.AnimationConfiguration(
            insertAnimation: .automatic,
            reloadAnimation: .none,
            deleteAnimation: .automatic)
        
        return dataSource
    }()
    
    fileprivate let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    //MARK: - View lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.darkBlue()
        self.navigationController?.navigationBar.barTintColor = UIColor.darkBlue()
        
        collectionView.backgroundColor = .clear
        collectionView.registerNib(cellClass: ForecastDetailCollectionViewCell.self)
        
        self.collectionViewFlowLayout.minimumInteritemSpacing = iOSDefaultSpicing
        self.collectionViewFlowLayout.minimumLineSpacing = iOSDefaultSpicing
        self.collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: iOSDefaultSpicing,
                                                                  left: iOSDefaultSpicing,
                                                                  bottom: iOSDefaultSpicing,
                                                                  right: iOSDefaultSpicing)
        self.collectionView.collectionViewLayout = self.collectionViewFlowLayout
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.alwaysBounceHorizontal = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDismissButton(animated: false)
    }
    
    //MARK: - Layout
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.collectionViewFlowLayout.itemSize = self.collectionViewFlowLayout.itemSizeThatFits(constrainedToRatio: forecastViewCellRatio,
                                                                                                andConstrainedToLength: idealWidthForModal..<Int.max)
    }
}

extension ForecastDetailViewController: BindableType {
    //MARK: - BindableType
    func bindViewModel() {
        viewModel.forecast.rx.observe(Date.self, "date")
            .subscribe(onNext: {[weak self] date in
                guard let strongSelf = self else {
                    return
                }
                guard let date = date else {
                    strongSelf.title = "Forecast"
                    return
                }
                strongSelf.title = "Forecast for \(literalDayFullFormat.string(from: date))"
            })
            .addDisposableTo(disposeBag)
        
        viewModel.forecasts(for: viewModel.forecast.day)
            .bind(to: collectionView.rx.items(dataSource: forecastDataSource))
            .addDisposableTo(rx_disposeBag)
    }
}
