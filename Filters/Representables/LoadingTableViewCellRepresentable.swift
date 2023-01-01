//
//  LoadingTableViewCellRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
class LoadingTableViewCellRepresentable: CellsProtocole {
    
    /// Cell height
    var cellHeight: CGFloat
    
    /// Reuse identifier
    var reuseIdentifier: String
    
    /**
      init without parameters.
     */
    init() {
        self.cellHeight = 0
        self.reuseIdentifier = LoadingTableViewCell.getReuseIdentifier()
    }

}
