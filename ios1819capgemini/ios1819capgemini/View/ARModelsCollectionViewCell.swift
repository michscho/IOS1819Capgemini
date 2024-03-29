//
//  ARModelsCollectionViewCell.swift
//  ios1819capgemini
//
//  Created by Michael Schott on 11.01.19.
//  Copyright © 2019 TUM LS1. All rights reserved.
//

import UIKit
import SwipeCellKit
class ARModelsCollectionViewCell: SwipeCollectionViewCell {
    
    //swiftlint:disable private_outlet
    @IBOutlet weak var modelImage: UIImageView!
    
    @IBOutlet weak var incidentLabel: UILabel!
    
    @IBOutlet weak var openLabel: UILabel!

    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var resolvedLabel: UILabel!
    
    @IBOutlet weak var openNumber: UILabel!
    
    @IBOutlet weak var progessNumber: UILabel!
    
    @IBOutlet weak var resolvedNumber: UILabel!

}
