//
//  HeaderTableViewRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
/// Header TableView Representable
class HeaderTableViewRepresentable : TableViewHeaderRepresentable  {
    
    /// Header height
    private(set) var headerHeight: CGFloat
    
    /// Reuse identifire
    private(set) var reuseIdentifier: String
        
    /// header title
    private(set) var headerTitle: String
    
    /// Header check image url
    private(set) var headerCheckImageName: String
    
    /// Header drop down image url
    private(set) var headerDropDownImageName: String
    
    enum SelectionDegree {
        case zeroSelect
        case partialSelect
        case fullSelect
    }
        
    /**
     init without parameters
     */
    init(){
        self.headerTitle = ""
        self.reuseIdentifier = HeaderView.getReuseIdentifier()
        self.headerHeight = HeaderView.getHeight()
        self.headerDropDownImageName = ""
        self.headerCheckImageName = ""
    }
    
    /**
      init.
     - Parameter filterTitle: Filter title  as string.
     - Parameter headerId: header Id title  as Int.
     - Parameter headerCheckImageURL: Header check image URL  as string.
     - Parameter headerDropDownImageURL: Header drop down image URL  as string.
     - Parameter headerSelectDegree: Header select degree  as string.
     */
    convenience init(filterTitle: String , headerSelectionDegree: SelectionDegree, isExpanded: Bool) {
        self.init()
        self.headerTitle = filterTitle
        switch headerSelectionDegree {
        case .zeroSelect :
            self.headerCheckImageName = "UnSelectedCircleImage.pdf"
        case .partialSelect :
            self.headerCheckImageName = "PartialSelectionImage.pdf"
        case .fullSelect:
            self.headerCheckImageName = "ThickSelectedCircleImage"
        }
        if !isExpanded {
            self.headerDropDownImageName = "DownUnfilledArrowImage"
        }else{
            self.headerDropDownImageName = "UnfilledArrowImage.pdf"
        }
    }
    
    /**
     setter for check image
     */
    func setHeaderCheckImageName(selectionDegree: SelectionDegree){
        switch selectionDegree {
        case .zeroSelect :
            self.headerCheckImageName = "UnSelectedCircleImage.pdf"
        case .fullSelect :
            self.headerCheckImageName = "ThickSelectedCircleImage"
        case .partialSelect :
            self.headerCheckImageName = "PartialSelectionImage.pdf"

        }
    }
    
    /**
     setter for drop down image
     */
    func setHeaderDropDownImageURL(isExpanded: Bool){
        if isExpanded{
            self.headerDropDownImageName = "UnfilledArrowImage.pdf"
        }else{
            self.headerDropDownImageName = "DownUnfilledArrowImage"
        }
    }
    
}
