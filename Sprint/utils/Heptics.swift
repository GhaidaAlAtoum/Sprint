//
//  Heptics.swift
//  Sprint
//
//  Created by Ghaida Atoum on 12/15/24.
//

import Foundation
import UIKit

enum HapticFeedbackStrength {
    case light
    case medium
    case heavy
    case soft
    case rigid
    
    fileprivate var style: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .light, .soft:
            return .light
        case .medium:
            return .medium
        case .heavy, .rigid:
            return .heavy
        }
    }
}


func vibrate(with strength: HapticFeedbackStrength) {
    if(UserConfig.shared.isVibrationEnabled()) {
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: strength.style)
            generator.impactOccurred()
        }
    }
}
