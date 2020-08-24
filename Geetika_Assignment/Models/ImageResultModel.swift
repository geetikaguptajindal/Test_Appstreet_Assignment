//
//  ImageResultModel.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 22/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import Foundation

struct ImageResultModel: Codable {
    let hits: [ImageHit]?
    
    init(images: [ImageHit] = []) {
        self.hits = images
    }
}

