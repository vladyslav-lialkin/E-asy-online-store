//
//  UIImage+Ext.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 09.08.2024.
//

import UIKit

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let scale = min(widthRatio, heightRatio)
        
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        let drawRect = CGRect(x: 5, y: 10, width: newSize.width, height: newSize.height)
        self.draw(in: drawRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
