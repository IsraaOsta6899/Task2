//
//  CollectionViewCellRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 11/01/2023.
//

import Foundation
class TitleCollectionViewCellRepresentable : CollectionViewCellRepresentable {
    
    private(set) var optionTitle: String
    
    private(set) var idOfOption: Int
    /// Reuse identifier
    private(set) var reuseIdentifier: String
    init(){
        self.optionTitle = ""
        self.idOfOption = 0
        self.reuseIdentifier = CustomCollectionViewCell.getReuseIdentifier()
    }
    
    convenience init(optionTitle: String, optionKey: Int) {
        self.init()
        self.idOfOption = optionKey
        self.optionTitle = "  "+optionTitle
    }
}
