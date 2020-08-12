//
//  Utils.swift
//  myappp
//
//  Created by lucian on 2020/8/10.
//  Copyright © 2020年 lucian. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func styleTextField (textField: UITextField) {
        
        textField.borderStyle = .roundedRect
        
    }
    
    static func styleFilledButton(button: UIButton) {
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 5.0
        button.tintColor = UIColor.black
    }
    
    static func styleView(image: String, viewController: UIViewController) {
        let bgImageView = UIImageView(frame: UIScreen.main.bounds)
        bgImageView.image = UIImage(named: image)
        viewController.view.addSubview(bgImageView)
    }
    

    
    
}
