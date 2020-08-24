//
//  SearchText+CoreDataProperties.swift
//  
//
//  Created by geetikagupta on 22/08/20.
//
//

import Foundation
import CoreData


extension SearchText {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchText> {
        return NSFetchRequest<SearchText>(entityName: "SearchText")
    }

    @NSManaged public var text: String?

}
