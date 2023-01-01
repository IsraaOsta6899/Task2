//
//  CellsProtocol.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
protocol CellsProtocole {
    /// Cell height
    var cellHeight: CGFloat{ get set }
    
    ///  Reuse identifier
    var reuseIdentifier: String { get set }
}
