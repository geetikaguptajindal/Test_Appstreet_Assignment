//
//  ImageHitViewModel.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 22/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import Foundation

struct ImageHitViewModel {

    //MARK:- iVar and property

    private let imageHitObj: ImageHit?
    
    init(_ imagehit: ImageHit) {
        self.imageHitObj = imagehit
    }
    
    var previewImageUrl: String {
        return self.imageHitObj?.previewURL ?? ""
    }
    
     var largeImageUrl: String {
           return self.imageHitObj?.largeImageURL ?? ""
       }
}
