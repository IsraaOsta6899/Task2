//
//  Filter Model.swift
//  Filters
//
//  Created by Israa Usta on 23/12/2022.
//

import Foundation
struct Filters: Codable{
    var title: String
    var filters: [Filter]
    
    enum CodingKeys : String , CodingKey {
        case title
        case filters
    }
    
    init(dict : Dictionary<String, Any>) {
        self.init()
        if let title = dict[CodingKeys.title.rawValue] as? String{
            self.title = title
        }
        if let filters = dict[CodingKeys.filters.rawValue] as? [[String:Any]]{
            for filter in filters {
                var filt = Filter(dict: filter)
                self.filters.append(filt)
            }
        }
    }
    init() {
        self.title = ""
        self.filters = []
    }
}
