//
//  HeaderView.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView {
    
    weak var delegate: HeaderTableViewDelegate?
    
    private var id : Int!
    
    @IBOutlet private weak var FilterTitleLabel: UILabel!
    
    @IBOutlet private weak var checkCircleImage: UIImageView!
    
    @IBOutlet private weak var dropDownImage: UIImageView!
    
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
        self.delegate?.checkImagePressedForHeader(indexPath: IndexPath(row: 0, section: self.id))
    }
    
    @objc func dropDownImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.delegate?.dropDownPress(headerId: self.id)
    }
    
    /**
     Get height for section's header
     - Returns: height of header
     */
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
    
    func setup(representable: HeaderTableViewRepresentable , section: Int) {
        self.FilterTitleLabel.text = representable.headerTitle
        self.id = section
        self.checkCircleImage.image = UIImage(named: representable.headerCheckImageName)
        self.dropDownImage.image =  UIImage(named: representable.headerDropDownImageName)
    }
    
}
protocol HeaderTableViewDelegate: AnyObject {
    func dropDownPress(headerId: Int)
    func checkImagePressedForHeader(indexPath: IndexPath)
}
