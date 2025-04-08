//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: Quicksand
    struct Quicksand {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-Medium", size: size)!
        }
        
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Quicksand-Bold", size: size)!
        }
    }
    
    // MARK: SFPro
    struct SFPro {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Bold", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Semibold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Regular", size: size)!
        }
        
        static func light(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .light)
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func thin(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .thin)
        }
        
        static func heavy(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .heavy)
        }
        
        static func black(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .black)
        }
        
        static func ultraLight(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .ultraLight)
        }
    }
}
