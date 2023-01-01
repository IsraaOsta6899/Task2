//
//  HeaderView.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: FiltersViewController?
    var headerId : Int!
    @IBOutlet weak var FilterTitleLabel: UILabel!
    
    @IBOutlet weak var checkCircleImage: UIImageView!
    
    @IBOutlet weak var dropDownImage: UIImageView!
    
    override  func awakeFromNib() {
        let tapGestureRecognizerForCheckCircleImage = UITapGestureRecognizer(target: self, action: #selector(checkCircleImageTapped(tapGestureRecognizer:)))
        checkCircleImage.isUserInteractionEnabled = true
        checkCircleImage.addGestureRecognizer(tapGestureRecognizerForCheckCircleImage)
        
        let tapGestureRecognizerForDropDownImage = UITapGestureRecognizer(target: self, action: #selector(dropDownImageTapped(tapGestureRecognizer:)))
        dropDownImage.isUserInteractionEnabled = true
        dropDownImage.addGestureRecognizer(tapGestureRecognizerForDropDownImage)
        
        
    }
    @objc func checkCircleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.delegate?.checkImagePressedForHeader(headerId: headerId)
    }
    
    @objc func dropDownImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.delegate?.dropDownPress(headerId: headerId)
    }
    
    class func getHeight()->CGFloat {
        return UITableView.automaticDimension
    }
    
    /**
     Get ReuseIdentifier for the header
     */
    class func getReuseIdentifier()->String {
        return "header"
    }
    
    class func registerHeaderView(tableView: UITableView) {
        tableView.register(UINib(nibName: "HeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "header")
    }
    
    func setup(representable: HeaderTableViewRepresentable) {
        self.FilterTitleLabel.text = representable.headerTitle
        self.headerId = representable.headerId
        self.checkCircleImage.image = UIImage(named: representable.headerCheckImageURL)
        self.dropDownImage.image =  UIImage(named: representable.headerDropDownImageURL)
    }
    
}
