//
//  OptionTableViewRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
import UIKit
class OptionTableViewCellRepresentable: TableViewCellRepresentable {
    
    /// Cell height
    private(set) var cellHeight: CGFloat
    
    /// Reuse identifier
    private(set) var reuseIdentifier: String
    
    /// Check image url
    private(set) var checkImageName: String
    
    /// Title
    private(set) var title: String
    
    // TODO: - Rename to id
    /// Option Key
    private(set) var id: Int

    /**
      init without parameters.
     */
    init() {
        self.cellHeight = OptionTableViewCell.getHeight()
        self.reuseIdentifier = OptionTableViewCell.getReuseIdentifier()
        self.title = ""
        self.checkImageName = ""
        self.id = 0
    }
    
    /**
      init.
     - Parameter optionTitle: option Title as string.
     - Parameter optionCheckImageURL: Option check image URL as string.
     - Parameter cellID:  Cell id  as Int.
     - Parameter section: section  as Int.
     */
    convenience init(optionTitle: String , isSelected: Bool , id: Int) {
        self.init()
        self.title = optionTitle
        
        //TODO: - Change call of code
        setCheckImageName(isSelected: isSelected)
        self.id = id
    }
    
    func setCheckImageName(isSelected: Bool) {
        if isSelected {
            self.checkImageName = "ThickSelectedCircleImage.pdf"
        }else{
            self.checkImageName = "UnSelectedCircleImage.pdf"
        }
    }
    
}
