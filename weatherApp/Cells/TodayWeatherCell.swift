//
//  todayWeatherCell.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/20/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import UIKit

class TodayWeatherCell: UIView {
    
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    
    init(frame: CGRect, name: String, value: String) {
        super.init(frame: frame)
        
        nameLabel.frame = CGRect(x: 0, y: 0, width: self.bounds.width/2 - 5 , height: 32)
        valueLabel.frame = CGRect(x: self.bounds.width/2 + 5, y: 0, width: self.bounds.width/2, height: 30)

        self.addSubview(nameLabel)
        self.addSubview(valueLabel)
        
        nameLabel.textAlignment = .right
        nameLabel.textColor = .gray
        nameLabel.font = .systemFont(ofSize: 16)
        valueLabel.font = .systemFont(ofSize: 18)
        nameLabel.text = name
        valueLabel.text = value
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
