//
//  Option Model.swift
//  Filters
//
//  Created by Israa Usta on 23/12/2022.
//

import Foundation
struct Filter: Codable {
    var id: Int
    var name: String
    
    enum CodingKeys : String , CodingKey {
        case id
        case name
    }
    
    init(dict : Dictionary<String, Any>) {
        self.init()
        if let filterID = dict[CodingKeys.id.rawValue] as? Int{
            self.id = filterID
        }
        if let filterName = dict[CodingKeys.name.rawValue] as? String{
            self.name = filterName
        }


    }
    init() {
        self.id = 0
        self.name = ""
    }
}
