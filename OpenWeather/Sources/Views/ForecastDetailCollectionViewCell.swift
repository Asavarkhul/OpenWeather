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
    // MARK: - Properties
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var temperatureLabell: UILabel!
    @IBOutlet weak var cloudinessLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    var disposeBag = DisposeBag()
    
    //MARK: - View lifecycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 3.0
        self.layer.masksToBounds = true
        self.configureLabel()
    }
    
    fileprivate func configureLabel() {
        iconLabel.text = "W"
        hourLabel.text = "H"
        temperatureLabell.text = "T°"
        cloudinessLabel.text = "C"
        windSpeedLabel.text = "S"
    }
    
    override public func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
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
        
        forecast.rx.observe(Date.self, "date")
            .subscribe(onNext: {[weak self] time in
                guard let strongSelf = self else {
                    return
                }
                guard let time = time else {
                    return
                }
                strongSelf.hourLabel.text = "\(literalHourFormat.string(from: time).lowercased())"
            })
            .addDisposableTo(disposeBag)
        
        forecast.rx.observe(Int.self, "cloudiness")
            .subscribe(onNext: {[weak self] cloudiness in
                guard let strongSelf = self else {
                    return
                }
                guard let cloudiness = cloudiness else {
                    return
                }
                strongSelf.cloudinessLabel.text = "Cloudiness: \(cloudiness)%"
            })
            .addDisposableTo(disposeBag)
        
        forecast.rx.observe(Int.self, "windSpeed")
            .subscribe(onNext: {[weak self] speed in
                guard let strongSelf = self else {
                    return
                }
                guard let speed = speed else {
                    return
                }
                strongSelf.windSpeedLabel.text = "Wind speed: \(speed)km/h"
            })
            .addDisposableTo(disposeBag)
        
        forecast.rx.observe(Double.self, "temperature")
            .subscribe(onNext: {[weak self] temp in
                guard let strongSelf = self else {
                    return
                }
                guard let temp = temp else {
                    return
                }
                strongSelf.temperatureLabell.text = "\(Int(temp).description)°c"
            })
            .addDisposableTo(disposeBag)
    }
}
