//
//  ViewController.swift
//  Filters
//
//  Created by Israa Usta on 23/12/2022.
//

import UIKit
/// Filters view controller
class FiltersViewController: UIViewController {
    
    /// outlet for filters table view
    @IBOutlet weak var filtersTableView: UITableView!
    
    /// viewModel instance for filters view controller
    var filterViewModel: FilterViewModel!
    
    /// search bar instance
    let searchBar = UISearchBar()
    
    /// Bottom Selection View
    var bottomSelectionView: BottomSelectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.filterViewModel = FilterViewModel()
        self.fetchData()
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search for filters"
        searchBar.sizeToFit()
        bottomSelectionView = BottomSelectionView(frame: CGRect(x: 0, y: self.view.frame.height*0.85, width: view.frame.width,height:  self.view.frame.height*0.15))

    }
    
    /**
     Fetch data
     */
    func fetchData() {
        FiltersModel.getFilters {
            result in
            switch result {
            case .failure(_):
                break
            case .success(let filters):
                self.filterViewModel.setFilters(allFilters: filters)
                self.filtersTableView.reloadData()
                self.filtersTableView.tableHeaderView = self.searchBar
                self.filtersTableView.refreshControl?.endRefreshing()
            }

        }
        
    }
    
    /**
     Setup table view
     */
    func setUpTableView() {
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
//        filtersTableView.tableFooterView = UIView()
//        filtersTableView.bounces = false
        HeaderView.registerHeaderView(tableView: self.filtersTableView)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getData), for: .valueChanged)
        self.filtersTableView.refreshControl = refreshControl
        if #available(iOS 15.0, *) {
            self.filtersTableView.sectionHeaderTopPadding = .zero
        }
    }
    
    /**
     Get data from API 
     */
    @objc func getData(refreshControl: UIRefreshControl) {
        self.fetchData()
    }

}



