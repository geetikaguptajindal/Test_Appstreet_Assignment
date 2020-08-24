//
//  ImageViewModel.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 22/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import Foundation

class ImagesViewModel {
  
    //MARK:- iVar and property
    private let apiClient: APIClient!
    private var page: Int = 1
    private var imageResultInfo:[ImageHit] = [ImageHit]()
    private var imageHitViewModels:[ImageHitViewModel] = [ImageHitViewModel]() {
        didSet {
            self.reloadTableViewClosure?(imageHitViewModels.count == 0 ? false : true)
        }
    }
    
    var searchKeyWord: String?
    var numberOfCells: Int {
        return imageHitViewModels.count
    }
    var numberOfSections: Int {
           return 1
    }
    
    // Closures
    var reloadTableViewClosure: ((Bool)->())?
    var noDataInfiniteLoadingClosure: (()->())?
        
    //MARK:- Init
    init(apiClient:APIClient, page: Int, searchKeyWord: String) {
        self.apiClient = apiClient
        self.page = page
        self.searchKeyWord = searchKeyWord
    }
}

//MARK:- Fetch Data from ApiService
extension ImagesViewModel {
   
    //get facts data from server
    func fetchImagesData(isLoadingMore: Bool =  false) {
        //make a call to server to get data
            
        if isLoadingMore { // handle infinite loading
            self.page = self.page + 1
        } else {
            self.page = 1
        }
       
        apiClient.load(page: self.page , searchKeyWord: self.searchKeyWord ?? "") {(result) in
            switch result {
                case .success(let data):
                    do {
                        let imageList = try JSONDecoder().decode(ImageResultModel.self, from: (data))
                        if let _ = imageList.hits {
                            self.processFetchedData(imageInfo: imageList.hits, isLoadingMore: isLoadingMore)
                        } 
                    } catch {
                        print ("No data")
                    }
                case .failure(let error):
                    print("\(self) retrive error: \(error)")
            }
        }
    }
    
    //ViewModel for update cell of collection view
    func getImageHitViewModel(at indexPath: IndexPath ) -> ImageHitViewModel {
        return imageHitViewModels[indexPath.row]
    }
    
    func processFetchedData(imageInfo: [ImageHit]?, isLoadingMore: Bool) {
        if let imageObj = imageInfo {
            self.imageResultInfo = imageObj

            if isLoadingMore == true { // pagination
                if self.imageResultInfo.isEmpty == true { // no data in infinite loading
                    self.noDataInfiniteLoadingClosure?()
                    return
                }
                for imageData in imageResultInfo {
                    self.imageHitViewModels.append(ImageHitViewModel(imageData))
                }
            } else {
                var imageHitviewModelsObj = [ImageHitViewModel]()
                for imageData in imageResultInfo {
                    imageHitviewModelsObj.append(ImageHitViewModel(imageData))
                }
                self.imageHitViewModels = imageHitviewModelsObj
            }
        }
    }
}
