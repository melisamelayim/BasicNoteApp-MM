//
//  Constants.swift
//  BasicNoteApp
//
//  Created by Max on 19.03.2025.
//

import Foundation
import UIKit

struct Colors {
    static let BNAPrimaryColor = UIColor(red: 187/255, green: 140/255, blue: 255/255, alpha: 1) // hex: #BB8CFF
    static let BNAPrimaryColorLight = UIColor(red: 220/255, green: 220/255, blue: 255/255, alpha: 1) // #DCDCFF
    
    static let BNAErrorColor = UIColor(red: 221/255, green: 44/255, blue: 0/255, alpha: 1) // #DD2C00
    static let BNAGreenColor = UIColor(red: 108/255, green: 197/255, blue: 124/255, alpha: 1) // #6CC57C
    static let BNAYellowColor = UIColor(red: 255/255, green: 209/255, blue: 100/255, alpha: 1) // #FFD164
    
    static let BNAGrayLight = UIColor(red: 226/255, green: 230/255, blue: 234/255, alpha: 1) // #E2E6EA
    static let BNAGrayDark = UIColor(red: 99/255, green: 141/255, blue: 146/255, alpha: 1) // #638D92
    static let BNABlack = UIColor(red: 35/255, green: 35/255, blue: 60/255, alpha: 1) // #23233C
    
}

struct Fonts {
    static let interMedium = "Inter-Medium"
}

struct Titles {
    static let title1 = UIFont.systemFont(ofSize: 26, weight: .semibold) // 26 pt, Semibold
    static let title2 = UIFont.systemFont(ofSize: 16, weight: .semibold) // 16 pt, Semibold
    static let title3 = UIFont.systemFont(ofSize: 15, weight: .medium) // 15 pt, Medium
    static let title4 = UIFont.systemFont(ofSize: 14, weight: .semibold) // 14 pt, Semibold
    static let title5 = UIFont.systemFont(ofSize: 13, weight: .medium) // 13 pt, Medium
}

