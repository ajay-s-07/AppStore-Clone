//
//  AppRowCell.swift
//  AppStore
//
//  Created by Ajay Sarkate on 05/07/23.
//

import UIKit


class AppRowCell: UICollectionViewCell {
    
    var app: FeedResult! {
        didSet {
            companyLabel.text = app.name
            nameLabel.text = app.name
            loadImage(in: imageView, from: app.artworkUrl100)
        }
    }
    
    func loadImage(in view: UIImageView, from urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                
                guard let data = data else {
                    return
                }
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    view.image = image
                }
                
            }.resume()
        }
    }

    
    let imageView = UIImageView(cornerRadius: 8)
    
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 16))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 13))
    
    let getButton = UIButton(title: "GET")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.backgroundColor = .purple
//        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant: 32)
        getButton.layer.cornerRadius = 32 / 2
        
        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel], spacing: 4), getButton])
        stackView.spacing = 16
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
