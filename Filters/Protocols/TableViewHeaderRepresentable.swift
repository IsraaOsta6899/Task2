//
//  TableViewHeaderRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
protocol TableViewHeaderRepresentable {
    /// Headet height
    var headerHeight: CGFloat{ get }
    
    /// Header Reuse identifier
    var reuseIdentifier: String { get }
}
