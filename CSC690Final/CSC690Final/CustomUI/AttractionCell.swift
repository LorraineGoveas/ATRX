//
//  AttractionCell.swift
//  CSC690Final
//
//  Created by Abigail Chin on 5/14/18.
//  Copyright © 2018 Abigail Chin. All rights reserved.
//

import UIKit

class AttractionCell: UITableViewCell{
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //containerView.layer.borderWidth = 0.5
        //containerView.layer.borderColor = UIColor.white.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        containerView.layer.cornerRadius = 5
        containerView.layer.backgroundColor = UIColor.white.alpha(0.1).cgColor
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted{
            containerView.backgroundColor = UIColor.white.alpha(0.5)
        }else{
            containerView.backgroundColor = UIColor.white.alpha(0.1)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
}
