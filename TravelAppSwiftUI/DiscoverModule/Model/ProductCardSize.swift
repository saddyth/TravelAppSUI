

import Foundation
import SwiftUI

enum ProductCardSize {
    case large, small
    
    var cardWidth: CGFloat {
        switch self {
        case .large: return 0.8
        case .small: return 0.42
        }
    }
    
    var likeSize: CGFloat {
        switch self {
        case .large: return 24
        case .small: return 20
        }
    }
    
    var titleSize: CGFloat {
        switch self {
        case .large: return 0.05
        case .small: return 0.03
        }
    }
    
}
