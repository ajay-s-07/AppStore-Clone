//
//  AppsHeaderCell.swift
//  AppStore
//
//  Created by Ajay Sarkate on 06/07/23.
//

import UIKit

class AppsHeaderCell: UICollectionViewCell {
    
    var app: SocialApp! {
        didSet {
            companyLabel.text = app.name
            titleLabel.text = app.tagline
            loadImage(in: imageView, from: app.imageUrl)
        }
    }

    
    let companyLabel = UILabel(text: "Facebook", font: .boldSystemFont(ofSize: 12))
    let titleLabel = UILabel(text: "Keeping up with friends is faster than ever", font: .systemFont(ofSize: 24))
    let imageView = UIImageView(cornerRadius: 8)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        companyLabel.textColor = .blue
        imageView.image = UIImage(named: "garden")
        titleLabel.numberOfLines = 2
        
        let stackView = VerticalStackView(arrangedSubviews: [
            companyLabel, titleLabel, imageView
        ], spacing: 12)
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    
}
