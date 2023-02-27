//
//  CustomCollectionViewCell.swift
//  Filters
//
//  Created by Israa Usta on 11/01/2023.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    // TODO: - replace with button
    
    /// Outlet for button
    @IBOutlet weak var cancleButton: UIButton!
    /// Option ket
    private var optionKey: Int!
    
    /// outlet for title label
    @IBOutlet private weak var optionTitleKabel: UILabel!
    
    /// Tap Gesture Recognizer For Check Circle Image
    private var tapGestureRecognizerForCheckCircleImage: UITapGestureRecognizer!
    
    /// Delegate when cancle image tapped
    weak var delegate: CancleCollectionViewCellDelegate?
    
    /**
     Awake from nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.optionTitleKabel.textColor =  UIColor(red: 0, green: 0.5333, blue:0.866, alpha: 1)
        cancleButton.imageView?.contentMode = .scaleToFill

    }

    @IBAction func cancleButtonClicked(_ sender: Any) {
        self.delegate?.cancleButtonClicked(cellID: self.optionKey)
    }
    /**
     Setup collection view cell
     - parameter representable: CollectionViewCellRepresentable
     */
    func setup(representable: TitleCollectionViewCellRepresentable){
        self.optionKey = representable.idOfOption
        self.optionTitleKabel.text = representable.optionTitle
    }
    
    func setCornerRadious(radious: CGFloat){
        self.layer.cornerRadius = radious
    }
    
    /**
     Get ReuseIdentifier for the header
     */
    class func getReuseIdentifier()->String {
        return "CollectionViewCell"
    }
    
    class func registerCollectionViewCell(collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: "CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        if let font = UIFont(name: "OpenSans-Bold", size: 10) {
            let fontAttributes = [NSAttributedString.Key.font: font]
            let text = self.optionTitleKabel.text
            let size = (text! as NSString).size(withAttributes: fontAttributes)
            let w: Double = Double(size.width)
            let h: Double = Double(size.height)
            layoutIfNeeded()
            let newFrame = layoutAttributes.frame
            var newFrame2 = CGRect(x: newFrame.minX, y: newFrame.minY, width: w+20, height: h + 5)
            newFrame2.size.width = CGFloat(ceilf(Float(w+20)))
            if newFrame2.size.width > UIScreen.main.bounds.width - 20 {
                newFrame2.size.width = UIScreen.main.bounds.width - 30
                newFrame2.size.height = h * Double(self.optionTitleKabel.countLines())+5
            }

            layoutAttributes.frame = newFrame2
            }
        return layoutAttributes

    }

    
    @objc func checkCircleImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.delegate?.cancleButtonClicked(cellID: self.optionKey)
    }

}
protocol CancleCollectionViewCellDelegate: AnyObject {
    func cancleButtonClicked(cellID: Int)
}

extension UILabel {
  func countLines() -> Int {
    guard let myText = self.text as NSString? else {
      return 0
    }
    let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
    return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
  }
}
