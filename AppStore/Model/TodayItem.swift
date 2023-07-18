//
//  TodayItem.swift
//  AppStore
//
//  Created by Ajay Sarkate on 14/07/23.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let imageName: UIImage
    let desription: String
    let backgroundColor: UIColor
    
    // enum
    let cellType: CellType
    
    let apps: [FeedResult]
    
    enum CellType: String {
        case single, multiple
    }
}
