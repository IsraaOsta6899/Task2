//
//  FiltersTableView + SearchBar.swift
//  Filters
//
//  Created by Israa Usta on 26/12/2022.
//

import Foundation
import UIKit
extension FiltersViewController: UISearchBarDelegate {
    /**
     Get matching data according to text written in search bar .
     - Parameter searchBar: .UISearchBar component
     - Parameter textDidChange: text written in search bar.
     */
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.filterViewModel.searchBar(searchText: searchText)
            self.filtersTableView.reloadData()
        }
}
