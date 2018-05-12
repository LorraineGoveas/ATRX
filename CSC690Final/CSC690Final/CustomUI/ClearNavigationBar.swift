//
//  ClearNavigationBar.swift
//  CSC690Final
//
//  Created by Abigail Chin on 5/11/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import Foundation
import UIKit

class ClearNavigationBar: UINavigationBar{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
        super.superview?.backgroundColor = .clear
    }
}
