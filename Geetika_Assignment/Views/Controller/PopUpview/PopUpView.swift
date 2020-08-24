//
//  PopUpView.swift
//  RepCard
//
//  Created by geetikagupta on 14/12/19.
//  Copyright © 2019 Pawan Joshi. All rights reserved.
//

import UIKit
import SDWebImage

protocol PopUpViewDeleagte: AnyObject {
    func closeButtonAction()
    func nextButtonAction()
    func previousButtonAction()

}

@IBDesignable
class PopUpView: UIView {
    
     //MARK:- Outlet and iVar
    @IBOutlet var displayImageView: UIImageView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var previousButton: UIButton!

    weak var delegate: PopUpViewDeleagte?

     //MARK:- init Method
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func loadView() -> PopUpView {
        let myClassNib = UINib(nibName: "PopUpView", bundle: nil)
        return myClassNib.instantiate(withOwner: self, options: nil)[0] as! PopUpView
    }

    
     //MARK:- Set up data
    func setImageData(_ imageInfoViewModel: ImageHitViewModel?) {
        if let _ = imageInfoViewModel?.largeImageUrl {
            self.displayImageView.image = nil
            let url = URL(string: imageInfoViewModel!.largeImageUrl)
            self.displayImageView.sd_imageIndicator = SDWebImageActivityIndicator.whiteLarge
            self.displayImageView.sd_imageIndicator?.startAnimatingIndicator()

            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, data, erroe, SDImageCacheType, isFinshed, uRL) in
                if image != nil {
                    self.displayImageView.image = image
                    self.displayImageView.sd_imageIndicator?.stopAnimatingIndicator()
                }
            }
        }
    }

    func resetPreviousState() {
        nextButton.isEnabled = true
        previousButton.isEnabled = true
    }
    
    func disablePreviousButton() {
        nextButton.isEnabled = true
        previousButton.isEnabled = false
    }
    
    func disableNextButton() {
        nextButton.isEnabled = false
        previousButton.isEnabled = true
    }
    
     //MARK:- Action Funtion
    @IBAction func closeButtonTapped() {
        delegate?.closeButtonAction()
    }

    @IBAction func nextButtonAction() {
        delegate?.nextButtonAction()
    }
    
    @IBAction func previousButtonAction() {
           delegate?.previousButtonAction()
       }
}
