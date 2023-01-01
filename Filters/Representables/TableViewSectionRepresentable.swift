//
//  SectionRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
import Foundation
class SectionTableViewRepresentable {
     typealias mytuple = (key: Int, value: CellsProtocole)
     /// header representable
     var headerRepresentable: HeaderTableViewRepresentable?
    
     /// cells representabels as [CellsProtocole]
     var cellsRepresentable: [mytuple] = []
    
     /// is Expanded as bool
     var isExpanded : Bool = false
     
}
