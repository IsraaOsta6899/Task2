//
//  LoadingTableViewCellRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
class LoadingTableViewCellRepresentable: TableViewCellRepresentable {
    
    /// Cell height
    private(set) var cellHeight: CGFloat
    
    /// Reuse identifier
    private(set) var reuseIdentifier: String
    
    /**
      init without parameters.
     */
    init() {
        self.cellHeight = 0
        self.reuseIdentifier = LoadingTableViewCell.getReuseIdentifier()
    }

}
