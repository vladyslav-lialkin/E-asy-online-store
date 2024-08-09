//
//  BackButtonModifier.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 09.08.2024.
//

import SwiftUI

struct BackButtonModifier: ViewModifier {
    init() {
        let image = UIImage(systemName: "arrow.left")?.resized(to: CGSize(width: 30, height: 30))
        
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .highlighted)
        UIBarButtonItem.appearance().tintColor = UIColor(named: "AppColor")
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension UIImage {
    static func gradientImageWithBounds(bounds: CGRect, colors: [CGColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
