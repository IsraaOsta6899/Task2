//
//  OptionTableViewRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
import UIKit
class OptionTableViewCellRepresentable: CellsProtocole {
    
    /// Cell height
    var cellHeight: CGFloat
    
    /// Reuse identifier
    var reuseIdentifier: String
    
    /// Check image url
    var checkImageURL: String
    
    /// Title
    var title: String
    
    /// is selected flag
    var isSelected: Bool
    
    /// Cell Id
    var cellID: Int
    
    /// Reuse identifier
    var section: Int
    /**
      init without parameters.
     */
    init() {
        self.cellHeight = OptionTableViewCell.getHeight()
        self.reuseIdentifier = OptionTableViewCell.getReuseIdentifier()
        self.title = ""
        self.checkImageURL = ""
        self.isSelected = false
        self.cellID = 0
        self.section = 0
    }
    
    /**
      init.
     - Parameter optionTitle: option Title as string.
     - Parameter optionCheckImageURL: Option check image URL as string.
     - Parameter cellID:  Cell id  as Int.
     - Parameter section: section  as Int.
     */
    convenience init(optionTitle: String , optionCheckImageURL: String , cellID: Int , section: Int ) {
        self.init()
        self.title = optionTitle
        self.checkImageURL = optionCheckImageURL
        self.cellID = cellID
        self.section = section
    }
    
}
