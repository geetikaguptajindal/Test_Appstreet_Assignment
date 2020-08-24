//
//  SearchViewModel.swift
//  Geetika_Assignment
//
//  Created by geetikagupta on 23/08/20.
//  Copyright © 2020 geetikagupta. All rights reserved.
//

import Foundation

class SearchViewModel {
    
     //MARK:- iVar and property
    var searchResultData:[SearchText] {
        return Database.sharedInstance.getData(SearchText.self)
    }

    var searchResultNumberOfCell : Int {
        return searchResultData.count
    }
    
    //MARK:-  Function to save data into core data
    func saveSearchTextIntoDatabase(searchKeyWord: String) {
        if searchKeyWord.isEmpty == false {
            let dict:  [String : String] =  [Constants.Keywords.text : searchKeyWord]
            Database.sharedInstance.deleteFirstData()
            Database.sharedInstance.save(object: dict)
        }
    }
    
    func cellItemAtIndex(at indexPath: IndexPath) -> SearchText {
        return searchResultData[indexPath.row]
    }
    
}
