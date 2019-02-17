//
//  DogModel.swift
//  ChallangeCabOnline
//
//  Created by Robert Andersson on 2019-02-17.
//  Copyright © 2019 Kroppe. All rights reserved.
//

import Foundation
import UIKit

class DogModel {
    
    let dogBreed: String!
    let dogImage: UIImage!
    
    init(dogBreed: String, dogImage: UIImage) {
        self.dogBreed = dogBreed
        self.dogImage = dogImage
        
    }
}
