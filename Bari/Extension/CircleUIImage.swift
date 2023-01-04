//
//  CircleUIImage.swift
//  Bari
//
//  Created by 김민성 on 2022/12/22.
//

import UIKit

extension UIImage {
    func circularImage(_ size: CGFloat) -> UIImage? {
        let imageView = UIImageView()
        
        imageView.frame =  CGRect(x: 0, y: 0, width: size, height: size)
        imageView.image = self
        imageView.contentMode = .scaleAspectFit
         
        var layer: CALayer = CALayer()
    
        layer = imageView.layer
        layer.masksToBounds = true
        layer.cornerRadius = size / 2
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        return roundedImage
    }
}
