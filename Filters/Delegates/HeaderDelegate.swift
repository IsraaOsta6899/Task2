//
//  Drop Down Pressed.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
protocol HeaderDelegate: AnyObject {
    func dropDownPress(headerId: Int)
    func checkImagePressedForHeader(headerId: Int)
}
