//
//  Check Image For Option Cell Pressed.swift
//  Filters
//
//  Created by Israa Usta on 26/12/2022.
//

import Foundation
protocol OptionCellDelegate : AnyObject{
    func checkImageForOptionCellPressed(cellID:Int , section:Int)
}
