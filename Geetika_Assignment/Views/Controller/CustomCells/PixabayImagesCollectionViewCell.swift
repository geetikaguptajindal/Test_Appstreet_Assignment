//
//  PixabayImagesCollectionViewCell.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 22/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import UIKit
import SDWebImage

class PixabayImagesCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Outlet and iVar
    @IBOutlet weak var displayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //to ensure image duplicay does not happen
    override func prepareForReuse() {
           self.displayImageView.sd_cancelCurrentImageLoad()
           self.displayImageView.image = nil
       }
       
    
    //MARK:- Set Data on cell
    func setData(_ imageInfoViewModel: ImageHitViewModel?) {
        if let _ = imageInfoViewModel?.previewImageUrl {
            self.displayImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.displayImageView.sd_imageIndicator?.startAnimatingIndicator()
            let url = URL(string: imageInfoViewModel!.previewImageUrl)
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, context: nil, progress: nil) { (image, data, erroe, SDImageCacheType, isFinshed, uRL) in
                if image != nil {
                    self.displayImageView.image = image
                    self.displayImageView.sd_imageIndicator?.stopAnimatingIndicator()
                }
            }
        }
    }
    
}
