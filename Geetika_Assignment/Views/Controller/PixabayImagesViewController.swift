//
//  PixabayImagesViewController.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 22/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import UIKit

class PixabayImagesViewController: UIViewController {

     //MARK: Outlet
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var searchTextTableView: UITableView!

    @IBOutlet weak var imageSearchBar: UISearchBar!
    @IBOutlet weak var searchTableHeightConstraint: NSLayoutConstraint!
    
    //MARK: Variables
    lazy var searchViewModel: SearchViewModel = {
        return SearchViewModel()
    } ()
    
    lazy var imagesViewModel: ImagesViewModel = {
        return ImagesViewModel(apiClient: APIClient(), page: 1, searchKeyWord: "")
    }()
    
    var isLoadingList: Bool = false
    var currentDisplayIndexPath: IndexPath!

    weak var popUpDispalyView: PopUpView!
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchData()
        self.setupUI()
    }
        
    //MARK:- Init ViewModel
     func fetchData() {
        imagesViewModel.fetchImagesData(isLoadingMore: isLoadingList) // isLoading to show infinite loading
        self.showSpinner(onView: self.view)
        self.reloadTableViewAfterFetchData()
        
        imagesViewModel.noDataInfiniteLoadingClosure = {() in // this closure when no data in infinite loading
            self.removeSpinner()
            self.isLoadingList = false
        }
    }
    
    //MARK:- Private Function

    private func setupUI() {
        self.searchTextTableView.tableFooterView = UIView()
        self.searchTextTableView?.alpha = 0.0
        self.addPreviewView()
    }
    
    // setup model data into collectionview
    private func reloadTableViewAfterFetchData() {
        imagesViewModel.reloadTableViewClosure = { [unowned self] (dataFound) in
            DispatchQueue.main.async {
                self.imagesCollectionView.reloadData()
                self.removeSpinner()
                
                if dataFound {
                    if let searchText = self.imageSearchBar.text {
                        let result = self.searchViewModel.searchResultData.filter {$0.text == searchText}
                        if result.isEmpty == true && self.isLoadingList == false && searchText.isEmpty == false { // this condition is to check if keyword already is not in database table
                           self.searchViewModel.saveSearchTextIntoDatabase(searchKeyWord: searchText)
                    }
                   }
                self.isLoadingList = false

                } else {
                    self.showAlert()
                }
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: Constants.Keywords.sorry, message: Constants.Keywords.noDataFound, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Keywords.ok, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func addPreviewView() {
        popUpDispalyView = PopUpView.loadView()
        popUpDispalyView.delegate = self
        popUpDispalyView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(popUpDispalyView)
        popUpDispalyView.isHidden = true
    }
    
    //MARK:- Function
    // show pop up view to display dimage in full view
    func displayPopUpView(imageHitObj: ImageHitViewModel) {
        self.navigationController?.isNavigationBarHidden = true
        self.popUpDispalyView.setImageData(imageHitObj)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.popUpDispalyView.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.popUpDispalyView.isHidden = false
            self.popUpDispalyView.resetPreviousState()
        }) { (value) in
            if (self.currentDisplayIndexPath.item + 1) == self.imagesViewModel.numberOfCells {
                self.popUpDispalyView.disableNextButton()
            }
            if self.currentDisplayIndexPath.item == 0 {
                self.popUpDispalyView.disablePreviousButton()
            }
        }
    }
    
    func hideSearchTable() {
        DispatchQueue.main.async {
            self.view.endEditing(true)

           UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.searchTableHeightConstraint.constant = 0
                self.searchTextTableView?.alpha = 0.0
           }) { (animation) in
               self.searchTextTableView.isHidden = true
           }
       }
    }
    
    func searchButtonAction() {
           self.view.endEditing(true)
           self.isLoadingList = false
           self.imagesViewModel.searchKeyWord = imageSearchBar.text

           self.fetchData()
           UIView.animate(withDuration: 0.6) {
               self.searchTableHeightConstraint.constant = 0
               self.searchTextTableView?.alpha = 0.0
           }
           searchTextTableView.isHidden = true
           imagesCollectionView.setContentOffset(CGPoint.zero, animated: true)
       }
}



//MARK:- PopUpViewDeleagte
extension PixabayImagesViewController: PopUpViewDeleagte {
    
    func closeButtonAction() {
        self.navigationController?.isNavigationBarHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.popUpDispalyView.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }) { (value) in
            self.popUpDispalyView.isHidden = true
            self.popUpDispalyView.resetPreviousState()
        }
    }
    
    func nextButtonAction() {
        currentDisplayIndexPath?.item += 1
        if currentDisplayIndexPath.item < imagesViewModel.numberOfCells {
            let ImageHitobj = imagesViewModel.getImageHitViewModel(at: currentDisplayIndexPath)
            displayPopUpView(imageHitObj: ImageHitobj)
        }
    }
    
    func previousButtonAction() {
        currentDisplayIndexPath?.item -= 1
        if currentDisplayIndexPath.item >= 0 { // if user see more image then data will be fetch
            let ImageHitobj = imagesViewModel.getImageHitViewModel(at: currentDisplayIndexPath)
            displayPopUpView(imageHitObj: ImageHitobj)
        }
    }
    
}

//MARK:- SearchBar Delegate
extension PixabayImagesViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchViewModel.searchResultNumberOfCell > 0 { // show table if their is any record
            searchTextTableView.isHidden = false
            self.searchTextTableView.reloadData()
            
             DispatchQueue.main.async {
                UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                    self.searchTableHeightConstraint.constant = 140
                     self.searchTextTableView?.alpha = 1.0
                }) { (animation) in
                    
                }
            }
        }
    }
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchButtonAction()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if  searchText.count == 0 {
            self.imagesViewModel.searchKeyWord = ""
            self.imagesCollectionView.setContentOffset(CGPoint.zero, animated: true)
            self.hideSearchTable()
            self.fetchData()
        }
    }
}
