//
//  FiltersViewController&UITableView.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
import UIKit
extension FiltersViewController: UITableViewDataSource , UITableViewDelegate , OptionTableViewCellDelegate , HeaderTableViewDelegate {
    
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
            optionTableViewCell.separatorInset = .init(top: 0, left: 40, bottom: 0, right: 20)
            optionTableViewCell.setDelegate(delegate: self)
            optionTableViewCell.setup(representable: optionRepresentable , indexPath: indexPath)
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
        headerView.setup(representable: representable,section: section)
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
        self.filterViewModel.toggleExpansionForSection(section: headerId)
        self.filtersTableView.reloadData()
    }
    
    /**
    Check which header cell's drop down image pressed to update table view data
     - Parameter headerId: Int
     */
    func checkImageForOptionCellPressed(indexPath: IndexPath) {
//        self.view.frame.size.height = 10000
        self.filterViewModel.toggleIsSelectedForFilter(indexPath: indexPath)
        self.filtersTableView.reloadData()
        if self.filterViewModel.partialSelectedFiltersForFilterCategory.count != 0 {
            if  self.view.subviews.count == 1 {
                bottomSelectionView.delegate = self
                bottomSelectionView.delegateViewModel = self.filterViewModel
                bottomSelectionView.setup(representable: self.filterViewModel.updateRepresentableForBottomViewWhenOptionCellPressed(indexPath: indexPath))
                self.view.addSubview(bottomSelectionView)
               
                
            }else {
                bottomSelectionView.delegate = self
                bottomSelectionView.delegateViewModel = self.filterViewModel
                bottomSelectionView.setup(representable: self.filterViewModel.updateRepresentableForBottomViewWhenOptionCellPressed(indexPath: indexPath))
            }
        }else{
            self.filterViewModel.updateRepresentableForBottomViewWhenOptionCellPressed(indexPath: indexPath)
            self.bottomSelectionView.frame = CGRect(x: 0, y: self.view.frame.height*0.85, width: self.view.frame.width,height:  self.view.frame.height*0.15)
            self.bottomSelectionView.removeFromSuperview()
        }
        self.filtersTableView.contentSize = CGSize(width: bottomSelectionView.frame.width, height: self.filtersTableView.contentSize.height + bottomSelectionView.frame.height)
    }
    
    /**
    Check which header's check image pressed to update table view data
     - Parameter headerId: Int
     */
    func checkImagePressedForHeader(indexPath: IndexPath) {
        self.filterViewModel.toggleFilterCategory(indexPath: indexPath)
        self.filtersTableView.reloadData()
        if self.filterViewModel.partialSelectedFiltersForFilterCategory.count != 0 {
            if  self.view.subviews.count == 1 {
                bottomSelectionView.delegate = self
                bottomSelectionView.delegateViewModel = self.filterViewModel
                bottomSelectionView.setup(representable: self.filterViewModel.updateRepresentableForBottomViewWhenHeaderPressed(sectionID: indexPath.section))
                self.view.addSubview(bottomSelectionView)
            }else {
                bottomSelectionView.delegate = self
                bottomSelectionView.delegateViewModel = self.filterViewModel
                bottomSelectionView.setup(representable: self.filterViewModel.updateRepresentableForBottomViewWhenHeaderPressed(sectionID: indexPath.section))
            }
        }else{
            self.filterViewModel.updateRepresentableForBottomViewWhenHeaderPressed(sectionID: indexPath.section)
            self.bottomSelectionView.frame = CGRect(x: 0, y: self.view.frame.height*0.85, width: self.view.frame.width,height:  self.view.frame.height*0.15)
            self.bottomSelectionView.removeFromSuperview()
        }
        self.filtersTableView.contentSize = CGSize(width: bottomSelectionView.frame.width, height: self.filtersTableView.contentSize.height + bottomSelectionView.frame.height)
    }
    
    /**
    Check which ccancle image pressed to update table view data
     - Parameter key: id of option  Int
     - Parameter section: section name string
     */
    func cancleImagePressed(key: Int, section: String){
        self.filterViewModel.cancleImagePressed(key: key, section: section)
        self.filtersTableView.reloadData()
        if self.filterViewModel.partialSelectedFiltersForFilterCategory.count != 0 {
            bottomSelectionView.delegate = self
            bottomSelectionView.delegateViewModel = self.filterViewModel
            self.bottomSelectionView.setup(representable: self.filterViewModel.updateRepresentableForBottomViewWhenCancleImagepressed(optionID: key, sectionName: section))
            self.view.addSubview(bottomSelectionView)

        }else{
            self.filterViewModel.updateRepresentableForBottomViewWhenCancleImagepressed(optionID: key, sectionName: section)
            self.bottomSelectionView.frame = CGRect(x: 0, y: self.view.frame.height*0.85, width: self.view.frame.width,height:  self.view.frame.height*0.15)
            self.bottomSelectionView.removeFromSuperview()
        }
    }
}

