//
//  ActivityIndicator.swift
//  Assignment_GeetikaGupta
//
//  Created by geetikagupta on 26/07/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import Foundation
import UIKit

var vSpinner : UIView?
 
//MARK:- To make custom spinner
extension UIViewController {
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.frame)
        spinnerView.backgroundColor = UIColor.clear
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
