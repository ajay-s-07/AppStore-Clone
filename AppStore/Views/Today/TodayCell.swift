//
//  TodayCell.swift
//  AppStore
//
//  Created by Ajay Sarkate on 13/07/23.
//

import UIKit

class TodayCell: BaseTodayCell {
    
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            imageView.image = todayItem.imageName
            descriptionLabel.text = todayItem.desription
            
            backgroundColor = todayItem.backgroundColor
            backgroundView?.backgroundColor = todayItem.backgroundColor
        }
    }
    
    let categoryLabel = UILabel(text: "Life Hack", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Utilize your Time", font: .boldSystemFont(ofSize: 28))
    
    let imageView = UIImageView(image: UIImage(named: "garden"))
    
    let descriptionLabel = UILabel(text: "All the tool and apps you need to intelligently organize your life the right way.", font: .systemFont(ofSize: 18), numberOfLines: 3)
    
    var topConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
//        clipsToBounds = true // blocking the shadows for today cells
        layer.cornerRadius = 16
        
        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
        
        let imageContainerView = UIView()
        imageContainerView.addSubview(imageView)
        imageView.centerInSuperview(size: .init(width: 200, height: 200))
        
        let stackView = VerticalStackView(arrangedSubviews: [
            categoryLabel, titleLabel, imageContainerView, descriptionLabel
        ], spacing: 8)
        
        addSubview(stackView)
        stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 24, bottom: 24, right: 24))
        
        self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        self.topConstraint.isActive = true
        
//        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
