//
//  PixabayImagesViewController+TableView.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 23/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import UIKit

//MARK:- TableView Delegate & DataSource
extension PixabayImagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell:UITableViewCell = self.searchTextTableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.searchCell){
            let searchTextObj = searchViewModel.cellItemAtIndex(at: indexPath)
            cell.textLabel?.text = searchTextObj.text
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchViewModel.searchResultNumberOfCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchTextObj = searchViewModel.cellItemAtIndex(at: indexPath)
        imageSearchBar.text = searchTextObj.text
        searchButtonAction()
    }
}
