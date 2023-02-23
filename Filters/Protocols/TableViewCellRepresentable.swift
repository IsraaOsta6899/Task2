//
//  TableViewCellRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
protocol TableViewCellRepresentable {
    /// Cell height
    var cellHeight: CGFloat{ get }
    
    ///  Reuse identifier
    var reuseIdentifier: String { get }
}
