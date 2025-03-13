import SwiftUI

extension Color {
    static let accentPrimary = Color(red: 230/255, green: 0/255, blue: 35/255)
}

extension Font {
    
    static var largeTitleRegular: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 34, weight: .regular, width: .expanded))
        } else {
            return Font.system(size: 34, weight: .regular)
        }
    }
    
    static var largeTitleEmphasized: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 34, weight: .bold, width: .expanded))
        } else {
            return Font.system(size: 34, weight: .bold)
        }
    }
    
    static var title1Regular: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 28, weight: .regular, width: .expanded))
        } else {
            return Font.system(size: 28, weight: .regular)
        }
    }
    
    static var title1Emphasized: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 28, weight: .bold, width: .expanded))
        } else {
            return Font.system(size: 28, weight: .bold)
        }
    }

    static var title2Regular: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 22, weight: .regular, width: .expanded))
        } else {
            return Font.system(size: 22, weight: .regular)
        }
    }
    
    static var title2Emphasized: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 22, weight: .bold, width: .expanded))
        } else {
            return Font.system(size: 22, weight: .bold)
        }
    }
    
    static var title3Regular: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 20, weight: .regular, width: .expanded))
        } else {
            return Font.system(size: 20, weight: .regular)
        }
    }
    
    static var title3Emphasized: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 20, weight: .bold, width: .expanded))
        } else {
            return Font.system(size: 20, weight: .bold)
        }
    }

    static var headlineRegular: Font {
        if #available(iOS 16.0, *) {
            return Font(UIFont.systemFont(ofSize: 17, weight: .semibold, width: .expanded))
        } else {
            return Font.system(size: 17, weight: .semibold)
        }
    }
    
    static let bodyRegular = Font.system(size: 17, weight: .regular)
    static let bodyEmphasized = Font.system(size: 17, weight: .semibold)
    
    static let calloutRegular = Font.system(size: 16, weight: .regular)
    static let calloutEmphasized = Font.system(size: 16, weight: .semibold)
    
    static let subheadlineRegular = Font.system(size: 15, weight: .regular)
    static let subheadlineEmphasized = Font.system(size: 15, weight: .semibold)
    
    static let footnoteRegular = Font.system(size: 13, weight: .regular)
    static let footnoteEmphasized = Font.system(size: 13, weight: .semibold)
    
    static let caption1Regular = Font.system(size: 12, weight: .regular)
    static let caption1Emphasized = Font.system(size: 12, weight: .medium)
    
    static let caption2Regular = Font.system(size: 11, weight: .regular)
    static let caption2Emphasized = Font.system(size: 11, weight: .semibold)

}

