//
//  ForecastCollectionViewCell.swift
//  OpenWeather
//
//  Created by Bertrand on 15/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
