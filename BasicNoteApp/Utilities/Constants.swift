//
//  Constants.swift
//  BasicNoteApp
//
//  Created by Max on 19.03.2025.
//

import Foundation
import UIKit

struct Colors {
    static let BNAPrimaryColor = UIColor(red: 139/255, green: 140/255, blue: 255/255, alpha: 1) // hex: #BB8CFF
    static let BNAPrimaryColorLight = UIColor(red: 220/255, green: 220/255, blue: 255/255, alpha: 1) // #DCDCFF
    
    static let BNAErrorColor = UIColor(red: 221/255, green: 44/255, blue: 0/255, alpha: 1) // #DD2C00
    static let BNAGreenColor = UIColor(red: 108/255, green: 197/255, blue: 124/255, alpha: 1) // #6CC57C
    static let BNAYellowColor = UIColor(red: 255/255, green: 209/255, blue: 100/255, alpha: 1) // #FFD164
    
    static let BNAGrayLight = UIColor(red: 226/255, green: 230/255, blue: 234/255, alpha: 1) // #E2E6EA
    static let BNAGrayDark = UIColor(red: 99/255, green: 141/255, blue: 146/255, alpha: 1) // #638D92
    static let BNABlack = UIColor(red: 35/255, green: 35/255, blue: 60/255, alpha: 1) // #23233C
    
}

enum BNATextStyle {
    case title1
    case title2
    case title3
    case title4
    case title5
}

extension UIFont {
    static func inter(_ style: BNATextStyle) -> UIFont {
        switch style {
        case .title1:
            return UIFont(name: "Inter-Medium", size: 26) ?? systemFont(ofSize: 26)
        case .title2:
            return UIFont(name: "Inter-Medium", size: 16) ?? systemFont(ofSize: 16)
        case .title3:
            return UIFont(name: "Inter-Medium", size: 15) ?? systemFont(ofSize: 15)
        case .title4:
            return UIFont(name: "Inter-Medium", size: 14) ?? systemFont(ofSize: 14)
        case .title5:
            return UIFont(name: "Inter-Medium", size: 13) ?? systemFont(ofSize: 11)
        }
    }
}

