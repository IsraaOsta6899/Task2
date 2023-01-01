//
//  FiltersViewController&UITableView.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
import UIKit
extension FiltersViewController: UITableViewDataSource , UITableViewDelegate , OptionCellDelegate , HeaderDelegate {
    
    /**
     Get number of  sections from viewModel.
     - Returns: Number of sections as Int.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterViewModel.numberOfSections()
    }
    
    /**
     Get number of rows in each section .
     - Parameter section: Section number as Int.
     - Parameter tableView: Table View as UITableView.
     - Returns: Number of rows in section as Int.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterViewModel.numberOfRows(inSection: section)
    }
    
    /**
     Get cell  at indexPath
     - Parameter indexPath: Index path.
     - Parameter tableView: Table View as UITableView.
     - Returns: Cell  as UITableViewCell.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let representable = self.filterViewModel.representableForRow(at: indexPath)
        if let optionRepresentable = representable as? OptionTableViewCellRepresentable {
            let optionTableViewCell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.getReuseIdentifier(), for: indexPath) as! OptionTableViewCell
            optionTableViewCell.delegate = self
            optionTableViewCell.setup(representable: optionRepresentable)
            return optionTableViewCell
        }else if representable is LoadingTableViewCellRepresentable{
            let loadingCell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.getReuseIdentifier(), for: indexPath) as! LoadingTableViewCell
            return loadingCell
        }
        else{
            return UITableViewCell()
        }
    }
    
    /**
     Get cell height at indexPath
     - Parameter indexPath: Index path.
     - Returns: Cell height  as CGFloat.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.filterViewModel.heightForRow(at: indexPath, tableView: tableView)
    }
    
    /**
     Get header view at section
     - Parameter section: Section number as Int.
     - Parameter tableView: Table View as UITableView.
     - Returns: header view as UIView?
     */
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let representable = self.filterViewModel.representableForHeader(at:section ) as! HeaderTableViewRepresentable
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! HeaderView
        headerView.setup(representable: representable)
        headerView.delegate = self
        return headerView
    }
    
    /**
     Get header height
     - Parameter tableView: UITableView
     - Parameter section: Int
     - Returns header height as CGFloat
     */
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        self.filterViewModel.heightForHeaderInSection(at: section, tableView: tableView)
    }
    
    /**
    Check which header's drop down image pressed to update table view data
     - Parameter headerId: Int
     */
    func dropDownPress(headerId: Int) {
        self.filterViewModel.dropDownPress(section: headerId)
        self.filtersTableView.reloadData()
    }
    
    /**
    Check which header cell's drop down image pressed to update table view data
     - Parameter headerId: Int
     */
    func checkImageForOptionCellPressed(cellID: Int , section: Int) {
        self.filterViewModel.checkImageForOptionCellPressed(cellID: cellID, section: section)
        self.filtersTableView.reloadData()
    }
    
    /**
    Check which header's check image pressed to update table view data
     - Parameter headerId: Int
     */
    func checkImagePressedForHeader(headerId: Int) {
        self.filterViewModel.checkImagePressedForHeader(headerId: headerId)
        self.filtersTableView.reloadData()
    }
 
}
