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
    private var allFilters: [String: FilterCategory]
    
    /// Keys
    private var keys: Array<String>
    
    /// Representable
    private var representables: [SectionTableViewRepresentable]
    
    
    /// Filterd Representable for search operation
    private var filterdRepresentable: [SectionTableViewRepresentable]
    
    /// Selected Categories
    //TODO: - Rename to partail...
    private(set) var partialSelectedFiltersForFilterCategory: [String: Set<Int>]
    
    /// selectionDegree Foreach Section
    private var selectionDegreeForeachCategory: [String: SelectionDegree]
    
    /// Expanded Sections
    private var expandedSectionsName : Set<String>
    
    /// Bottom seletion view representabels
    private var bottomSeletionViewRepresentabel: [BottomSeletionViewRepresentabel] = []
    
    /// Searching text
    private var searchingText = ""
    
    ///Selection Degree
    enum SelectionDegree {
        case zeroSelect
        case partialSelect
        case fullSelect
    }
    
    /// init
    init() {
        self.allFilters = [:]
        self.representables = []
        self.filterdRepresentable = []
        self.partialSelectedFiltersForFilterCategory = [:]
        self.keys = []
        self.expandedSectionsName = []
        self.selectionDegreeForeachCategory = [:]
        let sectionRepresentableForLoadingCell = SectionTableViewRepresentable()
        sectionRepresentableForLoadingCell.cellsRepresentable.append(LoadingTableViewCellRepresentable())
        sectionRepresentableForLoadingCell.isExpanded = true
        self.filterdRepresentable.append(sectionRepresentableForLoadingCell)
    }
    
    /**
     Set filters
     */
    func setFilters(allFilters: [String: FilterCategory]) {
        self.allFilters = allFilters
        self.keys = self.allFilters.keys.sorted(by: {$0 < $1})
        
        for item in self.allFilters {
            
            if self.selectionDegreeForeachCategory[item.value.title] == nil {
                self.selectionDegreeForeachCategory[item.value.title] = .zeroSelect
            }
        }
        
        self.buildRepresentable()
    }
    
    /**
     Build representable.
     */
    private func buildRepresentable() {
        
        // Remove loading
        self.representables.removeAll()
        
        
        for filterCategoryName in self.keys {
            
            let sectionRepresentable = SectionTableViewRepresentable()
            sectionRepresentable.sectionKey = filterCategoryName
            sectionRepresentable.isExpanded = self.expandedSectionsName.contains(self.allFilters[filterCategoryName]!.title)
            sectionRepresentable.headerRepresentable = HeaderTableViewRepresentable(filterTitle: self.allFilters[filterCategoryName]!.title,  headerSelectionDegree: .zeroSelect, isExpanded: sectionRepresentable.isExpanded)
            
            guard let filters = self.allFilters[filterCategoryName]?.filters else {
                return
            }
            
        // TODO: - First step on Selection degree value
            for option in filters {

                let optionCellRepresentable = OptionTableViewCellRepresentable(optionTitle: option.name , isSelected: true, id: option.id)
                
                if self.selectionDegreeForeachCategory[self.allFilters[filterCategoryName]!.title] == .fullSelect{
                    optionCellRepresentable.setCheckImageName(isSelected: true)
                    sectionRepresentable.headerRepresentable?.setHeaderCheckImageName(selectionDegree: .fullSelect)
                    
                }else if  self.selectionDegreeForeachCategory[self.allFilters[filterCategoryName]!.title] == .partialSelect {
                    
                    sectionRepresentable.headerRepresentable?.setHeaderCheckImageName(selectionDegree: .partialSelect)
                    if self.partialSelectedFiltersForFilterCategory[allFilters[filterCategoryName]!.title]!.contains(option.id) {
                        optionCellRepresentable.setCheckImageName(isSelected: true)
                        
                    }else{
                        optionCellRepresentable.setCheckImageName(isSelected: false)
                    }
                }else {
                    sectionRepresentable.headerRepresentable?.setHeaderCheckImageName(selectionDegree: .zeroSelect)
                    optionCellRepresentable.setCheckImageName(isSelected: false)
                }
                sectionRepresentable.cellsRepresentable.append(optionCellRepresentable)
            }
            
            self.representables.append(sectionRepresentable)
        }
        
        if self.searchingText.isEmpty {
            self.filterdRepresentable = self.representables
        }else {
            self.searchBar(searchText: self.searchingText)
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
        
        if section < filterdRepresentable.count {
            if filterdRepresentable[section].isExpanded {
                return self.filterdRepresentable[section].cellsRepresentable.count
            }
        }
        
        return 0
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
                tableView.estimatedRowHeight = 70
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
    func representableForRow(at indexPath: IndexPath) -> TableViewCellRepresentable? {
        if self.filterdRepresentable.count > indexPath.section && self.filterdRepresentable[indexPath.section].cellsRepresentable.count > indexPath.row{
            return self.filterdRepresentable[indexPath.section].cellsRepresentable[indexPath.row]
        }else{
            return nil
        }
    }
    
    /**
     Get representableForHeader at section
     - Parameter section: Int
     - Returns: Header Representable for section as HeaderTableViewRepresentable.
     */
    func representableForHeader(at section: Int) -> TableViewHeaderRepresentable? {
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
    func toggleExpansionForSection(section: Int) {
        
        if section < self.filterdRepresentable.count {
            
            self.filterdRepresentable[section].isExpanded = !self.filterdRepresentable[section].isExpanded
            if self.filterdRepresentable[section].isExpanded {
                self.filterdRepresentable[section].headerRepresentable?.setHeaderDropDownImageURL(isExpanded: true)
                self.expandedSectionsName.insert(self.allFilters[self.filterdRepresentable[section].sectionKey]!.title)
            }else{
                self.filterdRepresentable[section].headerRepresentable?.setHeaderDropDownImageURL(isExpanded: false)
                self.expandedSectionsName.remove(self.allFilters[self.filterdRepresentable[section].sectionKey]!.title)
            }
        }
    }
    
    
    /**
     Check  which cell pressed in which section to update it's data
     - Parameter section: Int
     - Parameter cellID: Int
     */
    func toggleIsSelectedForFilter(indexPath: IndexPath) {
        
        
        if indexPath.section < self.filterdRepresentable.count {
            
            let sectionRepresentable = self.filterdRepresentable[indexPath.section]
            
            // TODO: - Merge guard with if
            guard let indexForSection: Int = self.keys.firstIndex(where: {$0 == sectionRepresentable.sectionKey}) , let optionFilterRepresentableCell = self.representableForRow(at: indexPath) as? OptionTableViewCellRepresentable  else {return}
            let nameOfSection: String = self.filterdRepresentable[indexPath.section].sectionKey
                let filterID = optionFilterRepresentableCell.id
                let nameOfFilter = self.allFilters[nameOfSection]!.title
                var flag = false
                if self.selectionDegreeForeachCategory[nameOfFilter] == .fullSelect || (self.selectionDegreeForeachCategory[nameOfFilter] == .partialSelect && self.partialSelectedFiltersForFilterCategory[nameOfFilter]!.contains(filterID)) {
                    flag = true
                }
                if !flag {
                    optionFilterRepresentableCell.setCheckImageName(isSelected: true)
                    
                    if self.selectionDegreeForeachCategory[nameOfFilter] == .zeroSelect {
                        self.partialSelectedFiltersForFilterCategory[nameOfFilter] = []
                    }
                    
                    self.partialSelectedFiltersForFilterCategory[nameOfFilter]?.insert(filterID)
                    
                    // TODO: - Fix for 1 value.
                    if (self.selectionDegreeForeachCategory[nameOfFilter] == .zeroSelect &&  self.allFilters[nameOfSection]!.filters.count  > 1) || (self.selectionDegreeForeachCategory[nameOfFilter] == .partialSelect && self.partialSelectedFiltersForFilterCategory[nameOfFilter]!.count < self.allFilters[nameOfSection]!.filters.count ) {
                        self.selectionDegreeForeachCategory[nameOfFilter] = .partialSelect
                        self.filterdRepresentable[indexPath.section].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .partialSelect)
                        
                    }else if (self.selectionDegreeForeachCategory[nameOfFilter] == .partialSelect &&  self.partialSelectedFiltersForFilterCategory[nameOfFilter]!.count == self.allFilters[nameOfSection]!.filters.count) || (self.selectionDegreeForeachCategory[nameOfFilter] == .zeroSelect &&   self.allFilters[nameOfSection]!.filters.count == 1) {
                        self.partialSelectedFiltersForFilterCategory[nameOfFilter]?.removeAll()
                        self.selectionDegreeForeachCategory[nameOfFilter] = .fullSelect
                        self.filterdRepresentable[indexPath.section].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .fullSelect)
                    }
                    
                }else{
                    optionFilterRepresentableCell.setCheckImageName(isSelected: false)
                    
                    if (self.selectionDegreeForeachCategory[nameOfFilter] == .partialSelect) || (self.selectionDegreeForeachCategory[nameOfFilter] == .fullSelect &&  self.allFilters[nameOfSection]!.filters.count == 1)  {
                        
                        self.partialSelectedFiltersForFilterCategory[nameOfFilter]?.remove(filterID)
                        if self.partialSelectedFiltersForFilterCategory[nameOfFilter]?.count == 0{
                            self.filterdRepresentable[indexPath.section].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .zeroSelect)
                            self.partialSelectedFiltersForFilterCategory[nameOfFilter] = nil
                            self.selectionDegreeForeachCategory[nameOfFilter] = .zeroSelect
                            
                        }else if (self.partialSelectedFiltersForFilterCategory[nameOfFilter]?.count ?? 0) < self.allFilters[nameOfSection]?.filters.count ?? 0{
                            self.selectionDegreeForeachCategory[nameOfFilter] = .partialSelect
                            self.filterdRepresentable[indexPath.section].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .partialSelect)
                        }
                    }
                    else if self.selectionDegreeForeachCategory[nameOfFilter] == .fullSelect {
                        self.selectionDegreeForeachCategory[nameOfFilter] = .partialSelect
                        self.filterdRepresentable[indexPath.section].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .partialSelect)
                        for optionCell in self.representables[indexForSection].cellsRepresentable{
                            if let optionCellRepresentable = optionCell as? OptionTableViewCellRepresentable {
                                if optionCellRepresentable.id != filterID {
                                    self.partialSelectedFiltersForFilterCategory[nameOfFilter]?.insert(optionCellRepresentable.id)
                                }
                            }
                        }
                    }
            }
        }
    }
    
    //TODO: - Rename
    /**
     Check  which header image clicked to update header data
     - Parameter headerId: Int
     */
    func toggleFilterCategory(indexPath: IndexPath) {
        
        if indexPath.section < self.filterdRepresentable.count {
            
            let optionFilterRepresentableSection = self.filterdRepresentable[indexPath.section]
            
            guard let indexForSection: Int = self.keys.firstIndex(where: {$0 == optionFilterRepresentableSection.sectionKey}) else {return}
            
            if let headerRepresentable = self.filterdRepresentable[indexPath.section].headerRepresentable {
                // TODO: - Remove
                switch self.selectionDegreeForeachCategory[headerRepresentable.headerTitle] {
                case .fullSelect:
                //TODO: - remove check
                    self.partialSelectedFiltersForFilterCategory[headerRepresentable.headerTitle] = nil
                    self.selectionDegreeForeachCategory[headerRepresentable.headerTitle] = .zeroSelect
                
                    self.filterdRepresentable[indexPath.section].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .zeroSelect)
                    
                    for rep in self.representables[indexForSection].cellsRepresentable {
                        if let optionRepresentable = rep as? OptionTableViewCellRepresentable {
                            optionRepresentable.setCheckImageName(isSelected: false)
                            
                        }
                    }
                    
                case .partialSelect, .zeroSelect:
                    self.filterdRepresentable[indexPath.section].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .fullSelect)
                    
                    self.partialSelectedFiltersForFilterCategory[headerRepresentable.headerTitle] = []
                    
                    for rep in self.representables[indexForSection].cellsRepresentable {
                        if let optionRepresentable = rep as? OptionTableViewCellRepresentable {
                            optionRepresentable.setCheckImageName(isSelected: true)
                        }
                    }
                    
                    self.selectionDegreeForeachCategory[headerRepresentable.headerTitle] = .fullSelect
                default :
                    print("")
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
            
            self.filterdRepresentable = []
            
            var filteredOptionsRepresentables: [OptionTableViewCellRepresentable] = []
            
            for rep in self.representables {
                let sectionRepresentable: SectionTableViewRepresentable
                
                if let optionRepresentablesCells = rep.cellsRepresentable as? [OptionTableViewCellRepresentable] {
                    filteredOptionsRepresentables = optionRepresentablesCells.filter{$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()}
                }
                
                if !filteredOptionsRepresentables.isEmpty {
                    sectionRepresentable = SectionTableViewRepresentable()
                    sectionRepresentable.sectionKey = rep.sectionKey
                    sectionRepresentable.cellsRepresentable = filteredOptionsRepresentables
                    sectionRepresentable.headerRepresentable = rep.headerRepresentable
                    sectionRepresentable.isExpanded = true
                    self.filterdRepresentable.append(sectionRepresentable)
                }else {
                    if let headerRepresentable = rep.headerRepresentable {
                        if headerRepresentable.headerTitle.contains(searchText){
                            let sectionRepresentable = SectionTableViewRepresentable()
                            sectionRepresentable.sectionKey = rep.sectionKey
                            sectionRepresentable.headerRepresentable = headerRepresentable
                            sectionRepresentable.cellsRepresentable = []
                            sectionRepresentable.isExpanded = false
                            self.filterdRepresentable.append(sectionRepresentable)
                        }
                    }
                }
            }
        } else {
            self.filterdRepresentable = self.representables
        }
    }
    
    func cancleImagePressed(key: Int, section: String){
        guard let indexForRepresentable: Int = self.representables.firstIndex(where: {$0.headerRepresentable?.headerTitle == section})else {return}
        if key == -1 {
            self.partialSelectedFiltersForFilterCategory[section] = nil
            let rep = self.representables[indexForRepresentable]
            let headerRep = rep.headerRepresentable
            headerRep?.setHeaderCheckImageName(selectionDegree: .zeroSelect)
            self.selectionDegreeForeachCategory[section] = .zeroSelect
            for optionCell in self.representables[indexForRepresentable].cellsRepresentable {
                if let optionCellRepresentable = optionCell as? OptionTableViewCellRepresentable {
                    optionCellRepresentable.setCheckImageName(isSelected: false)                }
            }
        }else if let cellsRepresentablesForSection = self.representables[indexForRepresentable].cellsRepresentable as? [OptionTableViewCellRepresentable]{
            for cellRepresentable in cellsRepresentablesForSection {
                if cellRepresentable.id == key {
                    cellRepresentable.setCheckImageName(isSelected: false)
                    self.partialSelectedFiltersForFilterCategory[section]?.remove(key)
                    if self.partialSelectedFiltersForFilterCategory[section]?.count == 0 {
                        self.partialSelectedFiltersForFilterCategory[section] = nil
                        self.representables[indexForRepresentable].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .zeroSelect)
                        self.selectionDegreeForeachCategory[section] = .zeroSelect
                    }else if self.partialSelectedFiltersForFilterCategory[section]!.count < self.representables[indexForRepresentable].cellsRepresentable.count{
                        self.representables[indexForRepresentable].headerRepresentable?.setHeaderCheckImageName(selectionDegree: .partialSelect)
                        self.selectionDegreeForeachCategory[section] = .partialSelect
                        
                    }
                    break
                }
            }
        }
    }
    
    func updateRepresentableForBottomViewWhenOptionCellPressed(indexPath: IndexPath)-> [BottomSeletionViewRepresentabel]{
        var sectionId: Int = indexPath.section
        var cellId = indexPath.row
        if self.searchingText != ""{
            let sectionKey = self.filterdRepresentable[indexPath.section].sectionKey
            let filterdOptionCell = self.filterdRepresentable[indexPath.section].cellsRepresentable[indexPath.row]
            for (index,item)in self.keys.enumerated() {
                if item == sectionKey {
                    sectionId = index
                    break
                }
            }
            for (index,cell) in self.representables[sectionId].cellsRepresentable.enumerated() {
                // to get index of option inside data get from api
                if let optionCellRep = filterdOptionCell as? OptionTableViewCellRepresentable {
                    if let optionCell = cell as? OptionTableViewCellRepresentable {
                        if optionCell.id == optionCellRep.id {
                            cellId = index
                            break
                        }
                    }
                }
            }
        }
        var indexOfRepresentable = -1
        for (index,rep) in self.bottomSeletionViewRepresentabel.enumerated() {
            if rep.categoryName == self.allFilters[self.keys[sectionId]]!.title{
                indexOfRepresentable = index
                break
            }
        }
        if indexOfRepresentable == -1 {
            // section not exist in bottom selection view representables
            let bottomSeletionViewRepresentabel = BottomSeletionViewRepresentabel()
            bottomSeletionViewRepresentabel.categoryName = self.allFilters[self.keys[sectionId]]!.title
            bottomSeletionViewRepresentabel.categoryCellsRepresentables.append(
                CollectionViewCellRepresentable(
                    optionTitle: self.allFilters[self.keys[sectionId]]!.filters[cellId].name,
                    optionKey: self.allFilters[self.keys[sectionId]]!.filters[cellId].id
                )
            )
            self.bottomSeletionViewRepresentabel.append(bottomSeletionViewRepresentabel)
        }else{
            // section exist
            var isSelected = false
            for item in self.bottomSeletionViewRepresentabel[indexOfRepresentable].categoryCellsRepresentables{
                if item.idOfOption == self.allFilters[self.keys[sectionId]]!.filters[cellId].id {
                    isSelected = true
                    break
                }
            }
            // if flag true option exist else not exist
            if !isSelected {
                // item not exist in representables --
                self.bottomSeletionViewRepresentabel[indexOfRepresentable].categoryCellsRepresentables.removeAll()
                if self.selectionDegreeForeachCategory[self.allFilters[self.keys[sectionId]]!.title] == .fullSelect{
                    self.bottomSeletionViewRepresentabel[indexOfRepresentable].categoryCellsRepresentables.append(
                        CollectionViewCellRepresentable(
                            optionTitle:  "All",
                            optionKey: -1)
                    )
                }else{
                    for (index,item) in self.self.allFilters[self.keys[sectionId]]!.filters.enumerated() {
                        if self.partialSelectedFiltersForFilterCategory[self.self.allFilters[self.keys[sectionId]]!.title]!.contains(item.id){
                            self.bottomSeletionViewRepresentabel[indexOfRepresentable].categoryCellsRepresentables.append(
                                CollectionViewCellRepresentable(
                                    optionTitle:  self.allFilters[self.keys[sectionId]]!.filters[index].name,
                                    optionKey: item.id)
                            )
                        }
                    }
                }
                
            }else {
                // item exist in representables , so i want to remove it from representable
                self.bottomSeletionViewRepresentabel[indexOfRepresentable].categoryCellsRepresentables.removeAll(where: {$0.idOfOption == self.allFilters[self.keys[sectionId]]!.filters[cellId].id })
                if  self.bottomSeletionViewRepresentabel[indexOfRepresentable].categoryCellsRepresentables.count == 0 {
                    self.bottomSeletionViewRepresentabel.removeAll(where: {$0.categoryName == self.allFilters[self.keys[sectionId]]!.title })
                }
            }
        }
        return self.bottomSeletionViewRepresentabel
    }
    
    func updateRepresentableForBottomViewWhenHeaderPressed(sectionID: Int)-> [BottomSeletionViewRepresentabel]{
        var sectionId = sectionID
        if self.searchingText != "" {
            let sectionKey = self.filterdRepresentable[sectionID].sectionKey
            for (index,item)in self.keys.enumerated() {
                if item == sectionKey {
                    sectionId = index
                    break
                }
            }
        }
        var isExist = -1
        for (index,rep) in self.bottomSeletionViewRepresentabel.enumerated() {
            if rep.categoryName == self.allFilters[self.keys[sectionId]]!.title{
                isExist = index
                break
            }
        }
        let sectionSelectionDegree : SelectionDegree = self.selectionDegreeForeachCategory[self.allFilters[self.keys[sectionId]]!.title]!
        switch sectionSelectionDegree {
        case .fullSelect :
            if isExist == -1 {
                let x = BottomSeletionViewRepresentabel()
                x.categoryName = self.allFilters[self.keys[sectionId]]!.title
                x.categoryCellsRepresentables.append(
                    CollectionViewCellRepresentable(
                        optionTitle: "All",
                        optionKey: -1
                    )
                )
                self.bottomSeletionViewRepresentabel.append(x)
            }else{
                let y = self.bottomSeletionViewRepresentabel[isExist]
                y.categoryCellsRepresentables.removeAll()
                self.bottomSeletionViewRepresentabel.removeAll(where: {$0.categoryName==self.allFilters[self.keys[sectionId]]!.title})
                let x = BottomSeletionViewRepresentabel()
                x.categoryName = self.allFilters[self.keys[sectionId]]!.title
                x.categoryCellsRepresentables.append(
                    CollectionViewCellRepresentable(
                        optionTitle: "All",
                        optionKey: -1
                    )
                )
                self.bottomSeletionViewRepresentabel.append(x)
            }
        case .zeroSelect :
            let x = self.bottomSeletionViewRepresentabel[isExist]
            x.categoryCellsRepresentables.removeAll()
            self.bottomSeletionViewRepresentabel.removeAll(where: {$0.categoryName==self.allFilters[self.keys[sectionId]]!.title})
        default :
            print("")
            
        }
        return self.bottomSeletionViewRepresentabel
    }
    
    func updateRepresentableForBottomViewWhenCancleImagepressed(optionID: Int , sectionName: String)->[BottomSeletionViewRepresentabel]{
        var indexOfSectionRep: Int = -1
        for (index,rep) in self.bottomSeletionViewRepresentabel.enumerated() {
            if sectionName == rep.categoryName {
                indexOfSectionRep = index
            }
        }
        if optionID == -1 {
            self.bottomSeletionViewRepresentabel.removeAll(where: {$0.categoryName == sectionName})
        }else {
            self.bottomSeletionViewRepresentabel[indexOfSectionRep].categoryCellsRepresentables.removeAll(where: {$0.idOfOption == optionID})
            if self.bottomSeletionViewRepresentabel[indexOfSectionRep].categoryCellsRepresentables.count == 0 {
                self.bottomSeletionViewRepresentabel.removeAll(where: {$0.categoryName == sectionName})
            }
        }
        return self.bottomSeletionViewRepresentabel
    }
    
    func numberOfItemsInSection(indexOfSelectedCategory: Int)-> Int{
        return self.bottomSeletionViewRepresentabel[indexOfSelectedCategory].categoryCellsRepresentables.count
    }
    
    func representableForItemAt(sectionIndex: Int,indexPath: IndexPath)-> CollectionViewCellRepresentable{
        return self.bottomSeletionViewRepresentabel[sectionIndex].categoryCellsRepresentables[indexPath.row]
    }
}
