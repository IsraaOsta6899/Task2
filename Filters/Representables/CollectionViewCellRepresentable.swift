//
//  CollectionViewCellRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 11/01/2023.
//

import Foundation
class CollectionViewCellRepresentable {
    private(set) var optionTitle: String
    private(set) var idOfOption: Int
    
    init(){
        self.optionTitle = ""
        self.idOfOption = 0
    }
    
    convenience init(optionTitle: String, optionKey: Int) {
        self.init()
        self.idOfOption = optionKey
        self.optionTitle = "  "+optionTitle
    }
}
