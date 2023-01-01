//
//  FiltersViewModel.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
import UIKit
/// Filters view model
class FilterViewModel {
    
    /// All Filters
    private var allFilters: [Filters]
    
    /// Representable
    private var representables: [SectionTableViewRepresentable]
    
    /// Selected Filters Name
    private(set)var selectedFiltersName: Set<String>
    
    /// Searching flag
    private var searching = false
    
    /// Filterd Representable for search operation
    private var filterdRepresentable: [SectionTableViewRepresentable]
    
    /// Selected Filters Options
    private(set) var SelectedFiltersOptions: [[Int:String]]
    
    /// Searching Text
    private var searchingText = ""
    
    /// init
    init() {
        self.allFilters = []
        self.representables = []
        self.filterdRepresentable = []
        let x = SectionTableViewRepresentable()
        x.cellsRepresentable.append((0,LoadingTableViewCellRepresentable()))
        x.isExpanded = true
        self.representables.append(x)
        self.selectedFiltersName = []
        self.SelectedFiltersOptions = [[:],[:],[:],[:]]
        self.filterdRepresentable.append(x)
    }
    
    /**
     Set filters.
     */
    func setFilters(allFilters: [Filters]){
        self.allFilters = allFilters
        self.buildRepresentable()
    }
    
    /**
     Build representable.
     */
    private func buildRepresentable() {
        self.representables.removeAll()
        for (index , filter) in self.allFilters.enumerated() {
            let sectionRepresentable = SectionTableViewRepresentable()
            sectionRepresentable.headerRepresentable = HeaderTableViewRepresentable(filterTitle: filter.title, headerId: index, headerCheckImageURL: "UnSelectedCircleImage.pdf", headerDropDownImageURL: "DownUnfilledArrowImage.pdf" , headerSelectDegree: 0)
            for (index2,option) in filter.filters.enumerated() {
                if self.SelectedFiltersOptions[index].contains(where:{$0.key == option.id}){
                    print("--------00000")
                    sectionRepresentable.cellsRepresentable.append((option.id,OptionTableViewCellRepresentable(optionTitle: option.name , optionCheckImageURL: "ThickSelectedCircleImage.pdf", cellID: index2, section: index)))
                }else{
                    sectionRepresentable.cellsRepresentable.append((option.id,OptionTableViewCellRepresentable(optionTitle: option.name , optionCheckImageURL: "UnSelectedCircleImage.pdf", cellID: index2, section: index)))
                }
            }
            if self.selectedFiltersName.contains(sectionRepresentable.headerRepresentable!.headerTitle){
                if sectionRepresentable.cellsRepresentable.count == self.SelectedFiltersOptions[index].count{
                    sectionRepresentable.headerRepresentable?.headerCheckImageURL = "ThickSelectedCircleImage.pdf"
                }else if  sectionRepresentable.cellsRepresentable.count == 0{
                    sectionRepresentable.headerRepresentable?.headerCheckImageURL = "UnSelectedCircleImage.pdf"
                }else{
                    sectionRepresentable.headerRepresentable?.headerCheckImageURL = "PartialSelectionImage.pdf"
                    
                }
            }
            self.representables.append(sectionRepresentable)
        }
        if !self.searching{
            self.filterdRepresentable = self.representables
        }else {
            searchBar(searchText: self.searchingText)
        }
        
    }
    
    /**
     Get number of  sections.
     - Returns: Number of sections as Int.
     */
    func numberOfSections() -> Int {
        return self.filterdRepresentable.count
    }
    
    /**
     Get number of rows in each section.
     - Parameter section: Section number as Int.
     - Returns: Number of rows in section as Int.
     */
    func numberOfRows(inSection section: Int) -> Int {
        if section < filterdRepresentable.count && filterdRepresentable[section].isExpanded{
            return self.filterdRepresentable[section].cellsRepresentable.count
        }else{
            return 0
        }
    }
    
    /**
     Get height for each row in the table.
     - Parameter indexPath: Index path.
     - Parameter tableView: Table View.
     - Returns: height of cell as CGFloat.
     */
    func heightForRow(at indexPath: IndexPath, tableView: UITableView) -> CGFloat {
        if let representable = representableForRow(at: indexPath) {
            if representable is LoadingTableViewCellRepresentable {
                return LoadingTableViewCell.getHeight(tableview: tableView)
            }else if let optionTableViewCellRepresentable = representable as? OptionTableViewCellRepresentable {
                return optionTableViewCellRepresentable.cellHeight
            }
        }
        return 0
    }
    
    /**
     Get cell representable at indexPath
     - Parameter indexPath: Index path.
     - Returns: Cell representable as TableViewCellRepresentable.
     */
    func representableForRow(at indexPath: IndexPath) -> CellsProtocole? {
        if self.filterdRepresentable.count > indexPath.section && self.filterdRepresentable[indexPath.section].cellsRepresentable.count > indexPath.row{
            return self.filterdRepresentable[indexPath.section].cellsRepresentable[indexPath.row].value
        }else{
            return nil
        }
    }
    
    /**
     Get representableForHeader at section
     - Parameter section: Int
     - Returns: Header Representable for section as HeaderTableViewRepresentable.
     */
    func representableForHeader(at section: Int) -> HeaderProtocole? {
        if self.filterdRepresentable.count > 0{
            return self.filterdRepresentable[section].headerRepresentable
        }else{
            return nil
        }

    }
    
    /**
     Get height for header for section in the table.
     - Parameter section: Int
     - Parameter tableView: UITableView
     - Returns: height of header as CGFloat.
     */
    func heightForHeaderInSection(at section: Int , tableView: UITableView )->CGFloat {
        return representableForHeader(at: section)?.headerHeight ?? 0
    }
    
    /**
     Check  which section pressed to update table view header data
     - Parameter section: Int
     */
    func dropDownPress(section: Int) {
            if section < self.filterdRepresentable.count{
                self.filterdRepresentable[section].isExpanded = !self.filterdRepresentable[section].isExpanded
                if self.filterdRepresentable[section].isExpanded{
                    self.filterdRepresentable[section].headerRepresentable?.headerDropDownImageURL = "UnfilledArrowImage.pdf"
                }else{
                    self.filterdRepresentable[section].headerRepresentable?.headerDropDownImageURL = "DownUnfilledArrowImage.pdf"
            }
        }
    }
    
    /**
     Check  which cell pressed in which section to update it's data
     - Parameter section: Int
     - Parameter cellID: Int
     */
    func checkImageForOptionCellPressed(cellID: Int , section: Int) {
        if let optionRepresentableTableViewCell = self.representables[section].cellsRepresentable[cellID].value as? OptionTableViewCellRepresentable{
            optionRepresentableTableViewCell.isSelected = !optionRepresentableTableViewCell.isSelected
            let idOfOption = self.representables[section].cellsRepresentable[cellID].key
            let nameOfOption = optionRepresentableTableViewCell.title
            let nameOfFilter = self.allFilters[section].title
            if optionRepresentableTableViewCell.isSelected == true {
                optionRepresentableTableViewCell.checkImageURL = "ThickSelectedCircleImage.pdf"
                if !self.selectedFiltersName.contains(nameOfFilter){
                    self.selectedFiltersName.insert(nameOfFilter)
                    self.representables[section].headerRepresentable?.headerCheckImageURL = "PartialSelectionImage.pdf"
                }
                if !self.SelectedFiltersOptions[section].contains(where: {$0.key == idOfOption}){
                    self.SelectedFiltersOptions[section][idOfOption]=nameOfOption
                    if self.SelectedFiltersOptions[section].count < self.allFilters[section].filters.count{
                        self.representables[section].headerRepresentable?.headerCheckImageURL = "PartialSelectionImage.pdf"
                        self.representables[section].headerRepresentable?.headerSelectDegree = 1
                        
                    }else if self.SelectedFiltersOptions[section].count == self.allFilters[section].filters.count {
                        self.representables[section].headerRepresentable?.headerCheckImageURL = "ThickSelectedCircleImage.pdf"
                        self.representables[section].headerRepresentable?.headerSelectDegree = 2
                        
                    }
                }
                
            }else{
                optionRepresentableTableViewCell.checkImageURL = "UnSelectedCircleImage.pdf"
                if self.SelectedFiltersOptions[section].contains(where: {$0.key == idOfOption}){
                    self.SelectedFiltersOptions[section].removeValue(forKey: idOfOption)
                    if self.SelectedFiltersOptions[section].isEmpty{
                        self.representables[section].headerRepresentable?.headerCheckImageURL = "UnSelectedCircleImage.pdf"
                        self.representables[section].headerRepresentable?.headerSelectDegree = 0
                        self.selectedFiltersName.remove(representables[section].headerRepresentable!.headerTitle)
                        
                    }else if self.SelectedFiltersOptions[section].count < self.allFilters[section].filters.count{
                        self.representables[section].headerRepresentable?.headerCheckImageURL = "PartialSelectionImage.pdf"
                        self.representables[section].headerRepresentable?.headerSelectDegree = 1
                    }
                }
            }
        }
    }
    
    /**
     Check  which header image clicked to update header data
     - Parameter headerId: Int
     */
    func checkImagePressedForHeader(headerId: Int) {
        if let headerRepresentable = self.representables[headerId].headerRepresentable {
            if headerRepresentable.headerSelectDegree == 2 {
                headerRepresentable.headerSelectDegree = 0
                if self.selectedFiltersName.contains(headerRepresentable.headerTitle){
                    self.selectedFiltersName.remove(headerRepresentable.headerTitle)
                }
                self.representables[headerId].headerRepresentable?.headerCheckImageURL = "UnSelectedCircleImage.pdf"
                self.SelectedFiltersOptions[headerId].removeAll()
                for rep in self.representables[headerId].cellsRepresentable{
                    if let optionRepresentable = rep.value as? OptionTableViewCellRepresentable {
                        optionRepresentable.isSelected = false
                        optionRepresentable.checkImageURL = "UnSelectedCircleImage.pdf"
                        
                    }
                }
                
            }else if headerRepresentable.headerSelectDegree == 1 {
                headerRepresentable.headerSelectDegree = 2
                self.representables[headerId].headerRepresentable?.headerCheckImageURL = "ThickSelectedCircleImage.pdf"
                if !self.selectedFiltersName.contains(headerRepresentable.headerTitle){
                    self.selectedFiltersName.insert(headerRepresentable.headerTitle)
                }
                for rep in self.representables[headerId].cellsRepresentable{
                    if let optionRepresentable = rep.value as? OptionTableViewCellRepresentable {
                        optionRepresentable.isSelected = true
                        optionRepresentable.checkImageURL = "ThickSelectedCircleImage.pdf"
                        if !self.SelectedFiltersOptions[headerId].contains(where: {$0.key == optionRepresentable.cellID}){
                            self.SelectedFiltersOptions[headerId][optionRepresentable.cellID] = optionRepresentable.title
                        }
                    }
                }
                
            }else if headerRepresentable.headerSelectDegree == 0{
                headerRepresentable.headerSelectDegree = 2
                self.representables[headerId].headerRepresentable?.headerCheckImageURL = "ThickSelectedCircleImage.pdf"
                if !self.selectedFiltersName.contains(headerRepresentable.headerTitle){
                    self.selectedFiltersName.insert(headerRepresentable.headerTitle)
                }
                for rep in self.representables[headerId].cellsRepresentable{
                    if let optionRepresentable = rep.value as? OptionTableViewCellRepresentable {
                        optionRepresentable.isSelected = true
                        optionRepresentable.checkImageURL = "ThickSelectedCircleImage.pdf"
                        if !self.SelectedFiltersOptions[headerId].contains(where: {$0.key == optionRepresentable.cellID}){
                            self.SelectedFiltersOptions[headerId][optionRepresentable.cellID] = optionRepresentable.title
                        }
                    }
                }
            }
        }
    }
    
    /**
     Delegate text written in search bar to update filterd representables on tableview
     - Parameter searchText : String
     */
    func searchBar(searchText: String) {
        self.searchingText = searchText
        if searchText != "" {
            self.searching = true
            self.filterdRepresentable = []
            typealias mytuple = (key: Int, value: OptionTableViewCellRepresentable)
            var arr: [mytuple] = []
            for rep in self.representables {
                let sectionRepresentable : SectionTableViewRepresentable
                if let optionRepresentablesCells = rep.cellsRepresentable as? [mytuple] {
                    arr = optionRepresentablesCells.filter{$0.value.title.lowercased().prefix(searchText.count) == searchText.lowercased()}

                }

                if !arr.isEmpty {
                    sectionRepresentable = SectionTableViewRepresentable()
                    sectionRepresentable.cellsRepresentable = arr
                    sectionRepresentable.headerRepresentable = rep.headerRepresentable
                    sectionRepresentable.isExpanded = true
                    self.filterdRepresentable.append(sectionRepresentable)
                }else{
                    if let headerRepresentable = rep.headerRepresentable {
                        if headerRepresentable.headerTitle.contains(searchText){
                            let sectionRepresentable = SectionTableViewRepresentable()
                            sectionRepresentable.headerRepresentable = headerRepresentable
                            sectionRepresentable.cellsRepresentable = []
                            sectionRepresentable.isExpanded = false
                            self.filterdRepresentable.append(sectionRepresentable)
                            
                        }
                    }
                }
            }
        }else{
            self.filterdRepresentable = self.representables
            self.searching = false
            
        }
    }
}

