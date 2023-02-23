//
//  Filter Model.swift
//  Filter
//
//  Created by Israa Usta on 23/12/2022.
//

import Foundation
struct Filter: Codable {
    
    /// id
    var id: Int
    
    /// name
    var name: String
    
    enum CodingKeys : String , CodingKey {
        case id
        case name
    }
    
    /**
     init
     - Parameter dict :Dictionary<String, Any>
     */
    init(dict : Dictionary<String, Any>) {
        self.init()
        if let filterID = dict[CodingKeys.id.rawValue] as? Int{
            self.id = filterID
        }
        if let filterName = dict[CodingKeys.name.rawValue] as? String{
            self.name = filterName
        }
    }
    
    /**
     init without parameters
     */
    init() {
        self.id = 0
        self.name = ""
    }
}
