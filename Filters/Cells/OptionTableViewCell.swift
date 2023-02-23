//
//  OptionTableViewCell.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var checkImage: UIImageView!
    
    @IBOutlet private weak var optionTitleLabel: UILabel!
    
    private var indexPath: IndexPath!
    
    private weak var delegate: OptionTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGestureRecognizerForCheckCircleImage = UITapGestureRecognizer(target: self, action: #selector(checkCircleImageTapped(tapGestureRecognizer:)))
        checkImage.isUserInteractionEnabled = true
        checkImage.addGestureRecognizer(tapGestureRecognizerForCheckCircleImage)
    }
    
    @objc func checkCircleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        delegate?.checkImageForOptionCellPressed(indexPath: self.indexPath)
    }
    
    class func getHeight()->CGFloat {
        return UITableView.automaticDimension
    }
    
    /**
     Get ReuseIdentifier for the header
     */
    class func getReuseIdentifier()->String {
        return "Option"
    }
    
    func setDelegate(delegate: OptionTableViewCellDelegate ){
        self.delegate = delegate
    }
    
    func setup(representable: OptionTableViewCellRepresentable , indexPath: IndexPath) {
        self.optionTitleLabel.text = representable.title
        self.checkImage.image = UIImage(named: representable.checkImageName)
        self.indexPath = indexPath
    }
}


protocol OptionTableViewCellDelegate: AnyObject {
    func checkImageForOptionCellPressed(indexPath: IndexPath)
}
