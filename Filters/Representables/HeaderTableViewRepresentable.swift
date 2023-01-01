//
//  HeaderTableViewRepresentable.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import Foundation
class HeaderTableViewRepresentable : HeaderProtocole  {
    
    /// Header height
    var headerHeight: CGFloat
    
    /// Reuse identifire
    var reuseIdentifier: String
    
    /// Header id
    var headerId : Int
    
    /// header title
    var headerTitle: String
    
    /// Header check image url
    var headerCheckImageURL: String
    
    /// Header drop down image url
    var headerDropDownImageURL: String
    
    /// Header selection degree
    var headerSelectDegree: Int
    
    /**
     init without parameters
     */
    init(){
        self.headerTitle = ""
        self.headerId = 0
        self.reuseIdentifier = HeaderView.getReuseIdentifier()
        self.headerHeight = HeaderView.getHeight()
        self.headerDropDownImageURL = ""
        self.headerCheckImageURL = ""
        self.headerSelectDegree = 0
    }
    
    /**
      init.
     - Parameter filterTitle: Filter title  as string.
     - Parameter headerId: header Id title  as Int.
     - Parameter headerCheckImageURL: Header check image URL  as string.
     - Parameter headerDropDownImageURL: Header drop down image URL  as string.
     - Parameter headerSelectDegree: Header select degree  as string.
     */
    convenience init(filterTitle: String , headerId : Int , headerCheckImageURL: String , headerDropDownImageURL: String , headerSelectDegree: Int) {
        self.init()
        self.headerTitle = filterTitle
        self.headerId = headerId
        self.headerCheckImageURL = headerCheckImageURL
        self.headerDropDownImageURL = headerDropDownImageURL
        self.headerSelectDegree = headerSelectDegree
        
    }
}
