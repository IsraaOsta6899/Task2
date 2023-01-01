//
//  HeaderProtocol.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
protocol HeaderProtocole {
    /// Headet height
    var headerHeight: CGFloat{ get set }
    
    /// Header Reuse identifier
    var reuseIdentifier: String { get set }
}
