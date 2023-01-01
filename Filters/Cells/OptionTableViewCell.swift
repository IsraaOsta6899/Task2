//
//  OptionTableViewCell.swift
//  Filters
//
//  Created by Israa Usta on 24/12/2022.
//

import UIKit

class OptionTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var optionTitleLabel: UILabel!
    var cellID: Int!
    var sectionIDForCell: Int!
    weak var delegate: FiltersViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGestureRecognizerForCheckCircleImage = UITapGestureRecognizer(target: self, action: #selector(checkCircleImageTapped(tapGestureRecognizer:)))
        checkImage.isUserInteractionEnabled = true
        checkImage.addGestureRecognizer(tapGestureRecognizerForCheckCircleImage)
    }
    
    @objc func checkCircleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        delegate?.checkImageForOptionCellPressed(cellID: cellID, section: sectionIDForCell)
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
    
    func setup(representable: OptionTableViewCellRepresentable) {
        self.optionTitleLabel.text = representable.title
        self.checkImage.image = UIImage(named: representable.checkImageURL)
        self.cellID = representable.cellID
        self.sectionIDForCell = representable.section
    }

}
