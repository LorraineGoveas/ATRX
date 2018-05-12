//
//  RoundedButton.swift
//  CSC690Final
//
//  Created by Abigail Chin on 5/11/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import UIKit
import Hue


class RoundedButton: UIButton{
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.backgroundColor = UIColor.white.cgColor
    }
    
}
