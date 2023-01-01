//
//  LoadingTableViewCell.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import UIKit

/// Loading Table View Cell
class LoadingTableViewCell: UITableViewCell{
    
    /**
     Get height for loading cell
     - Parameter tableView: Table View as UITableView.
     - Returns: height of cell
     */
    class func getHeight(tableview: UITableView) -> CGFloat {
        return tableview.frame.height
    }
    
    /**
     Get ReuseIdentifier for the cell
     - Returns: Reuse identifier
     */
    class func getReuseIdentifier() -> String {
        return "Loading"
    }
    
}
