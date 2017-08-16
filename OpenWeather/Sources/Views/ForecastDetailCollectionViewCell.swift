//
//  ForecastTableViewCell.swift
//  OpenWeather
//
//  Created by Bertrand on 16/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit
import RxSwift

public final class ForecastDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minTemperatureLabell: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    var disposeBag = DisposeBag()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
    }
    
    func configure(with forecast: Forecast) {
        forecast.rx.observe(String.self, "iconURL")
            .subscribe(onNext: {[weak self] iconUrl in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.iconLabel.text = iconUrl
            })
            .addDisposableTo(disposeBag)
        
        forecast.rx.observe(Double.self, "minTemperature")
            .subscribe(onNext: {[weak self] temp in
                guard let strongSelf = self else {
                    return
                }
                guard let temp = temp else {
                    return
                }
                strongSelf.minTemperatureLabell.text = "\(Int(temp).description)°"
            })
            .addDisposableTo(disposeBag)
    }
    
    override public func prepareForReuse() {
        iconLabel.text = "Day"
        hourLabel.text = "Day"
        minTemperatureLabell.text = "Day"
//        maxTemperatureLabel.text = "Day"
        iconLabel.text = "Day"
        cloudinessLabel.text = "Day"
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
}
