//
//  SectionRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
import Foundation
class SectionTableViewRepresentable {
     /// header representable
     var headerRepresentable: HeaderTableViewRepresentable?
    
     /// cells representabels as [TableViewCellRepresentable]
     var cellsRepresentable: [TableViewCellRepresentable] = []
    
     /// is Expanded as bool
     var isExpanded : Bool = false
    
     var sectionKey: String = ""
}
