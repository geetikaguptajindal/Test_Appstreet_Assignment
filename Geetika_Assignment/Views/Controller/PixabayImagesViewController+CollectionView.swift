//
//  PixabayImagesViewController+CollectionView.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 24/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import UIKit

//MARK:- CollectionView Delegate & DataSource
extension PixabayImagesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
         return imagesViewModel.numberOfCells
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell:PixabayImagesCollectionViewCell = self.imagesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.customImageCell , for: indexPath) as? PixabayImagesCollectionViewCell{
            let ImageHitobj = imagesViewModel.getImageHitViewModel(at: indexPath)
            cell.setData(ImageHitobj)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width - 20) / 2, height: (view.frame.size.width - 20) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ImageHitobj = imagesViewModel.getImageHitViewModel(at: indexPath)
        displayPopUpView(imageHitObj: ImageHitobj)
        currentDisplayIndexPath = indexPath
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         self.hideSearchTable()
    }
    
    // Calculate for infinite loading
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
            self.isLoadingList = true
            self.fetchData()
        }
    }
}
