//
//  MemeObject.swift
//  Meme It
//
//  Created by Jonathan Agarrat on 12/3/15.
//  Copyright © 2015 Jenius. All rights reserved.
//

import Foundation
import UIKit

class MemeObject {
    
    var topText: String
    
    var bottomText: String
    
    var originalImage: UIImage!
    
    var memedImage: UIImage!
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        
        self.topText = topText
        
        self.bottomText = bottomText
        
        self.originalImage = originalImage
        
        self.memedImage = memedImage
        
    }
    
}
