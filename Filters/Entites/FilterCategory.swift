//
//  Filters Model.swift
//  Filters
//
//  Created by Israa Usta on 23/12/2022.
//

import Foundation
class FilterCategory: Codable{
    
    /// Title
    var title: String
    
    /// Filters
    var filters: [Filter]
    
    enum CodingKeys : String , CodingKey {
        case title
        case filters
    }
    
    /**
     init
     - Parameter dict :Dictionary<String, Any>
     */
    convenience init(dict : Dictionary<String, Any>) {
        self.init()
        if let title = dict[CodingKeys.title.rawValue] as? String{
            self.title = title
        }
        if let filters = dict[CodingKeys.filters.rawValue] as? [[String:Any]]{
            for filter in filters {
                let option = Filter(dict: filter)
                self.filters.append(option)
            }
            
        }
    }
    
    /**
     init without parameters
     */
    init() {
        self.title = ""
        self.filters = []
    }
}
