//
//  ForecastCollectionViewCell.swift
//  OpenWeather
//
//  Created by Bertrand on 15/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit
import RxSwift

public final class ForecastCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIconLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    var disposeBag = DisposeBag()
    
    //MARK: - View lifecycle
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        self.updateHighlightUI()
    }
    
    @objc public override var isSelected: Bool {
        didSet {
            self.updateHighlightUI()
        }
    }
    
    override public func prepareForReuse() {
        dayLabel.text = "Day"
        weatherIconLabel.text = "W"
        tempLabel.text = "Temp"
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    fileprivate func updateHighlightUI() {
        let borderColor = self.isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
        self.layer.borderColor = borderColor
        self.layer.borderWidth = self.isSelected ? 2.0 : 0.0
    }
    
    func configure(with forecast: Forecast) {
        forecast.rx.observe(String.self, "iconURL")
            .subscribe(onNext: {[weak self] iconUrl in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.weatherIconLabel.text = iconUrl
            })
            .addDisposableTo(disposeBag)
        
        forecast.rx.observe(Date.self, "date")
            .subscribe(onNext: {[weak self] date in
                guard let strongSelf = self else {
                    return
                }
                guard let date = date else {
                    return
                }
                strongSelf.dayLabel.text = literalDayFormat.string(from: date)
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
                strongSelf.tempLabel.text = "\(Int(temp).description)°"
            })
            .addDisposableTo(disposeBag)
    }
}
