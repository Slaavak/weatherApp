//
//  ForecastWeatherCell.swift
//  weatherApp
//
//  Created by Slava Korolevich on 9/20/20.
//  Copyright © 2020 Slava Korolevich. All rights reserved.
//

import UIKit

class ForecastWeatherCell: UITableViewCell {
    
    var degreeLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.textAlignment = .center
        label.textColor = .systemBlue
        return label
    }()
    
    let timeLabel = UILabel()
    let iconImageView = UIImageView()
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(iconImageView)
        self.addSubview(timeLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(degreeLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        degreeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 96),
            iconImageView.heightAnchor.constraint(equalToConstant: 96),
            
            timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            
            degreeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            degreeLabel.topAnchor.constraint(equalTo: self.topAnchor),
            degreeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
