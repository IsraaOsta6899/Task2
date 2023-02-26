//
//  BottomSelectionView.swift
//  Filters
//
//  Created by Israa Usta on 06/01/2023.
//

import Foundation
import UIKit
import JNSegmentedControl

/// Bottom Selection View
class BottomSelectionView: UIView , UIScrollViewDelegate, UICollectionViewDataSource, CancleCollectionViewCellDelegate {
    
    /// Outlet for swap view
    @IBOutlet weak var pannerView: UIView!
    
    /// Outlet for collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// Outlet for all view
    @IBOutlet var content: BottomSelectionView!
    
    /// delegate for view model
    weak var delegateViewModel: FilterViewModel?
    
    /// Outlet for all blue view ( contain collection view and segment or label )
    @IBOutlet weak var blueView: UIView!
    
    /// delegate for view controller
    weak var delegate: FiltersViewController?
    
    /// Representables
    var representables: [BottomSeletionViewRepresentabel] = []
    
    /// selected segment index
    var selectedIndex: Int = 0
    
    /// positions Of Y Axis For Swap View
    var positionsOfYAxisForSwapView: [CGFloat] = []
    
    /// index of selected category
    var indexOfClickedCategory: Int = 0
    
    /// selected category name
    var selectedCategoryName: String?
    
    /// FilterCategory
    enum FilterCategory: String{
        case Classifications
        case Cusine
        case Positions
        case Skills
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.representables = []
        initSubviews()
        initCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     setup method to build view
     - Parameter representable: [BottomSeletionViewRepresentabel]
     */
    func setup(representable: [BottomSeletionViewRepresentabel]){
        self.representables = representable
        self.indexOfClickedCategory = 0
        if self.representables.count == 1{
            self.selectedCategoryName = self.representables[0].categoryName
            self.selectedIndex = 0
        }else if self.representables.count > 1{
            self.selectedCategoryName = self.representables[self.representables.count-1].categoryName
            self.selectedIndex = self.representables.count-1
        
        }
        self.reloadView()
    }
    
    /**
     Initialize all bottom selection view
     */
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "BottomSelectionView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        content.frame = bounds
        addSubview(content)
        content.addSubview(self.pannerView)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(_:)))
        self.pannerView.addGestureRecognizer(panGestureRecognizer)
        self.blueView.layer.cornerRadius = 10
        self.blueView.backgroundColor =  UIColor(red: 0, green: 0.5333, blue:0.866, alpha: 1)
        self.content.layer.cornerRadius = 10
        self.pannerView.layer.cornerRadius = 2.5
    }
    
    /**
     Initialize Collection View
     */
    func initCollectionView() {
        CustomCollectionViewCell.registerCollectionViewCell(collectionView: self.collectionView)
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 0, green: 0.5333, blue:0.866, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8 , bottom: 0, right: 10)
        let layout = LeftAlignedCellsCustomFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        self.collectionView.collectionViewLayout = layout
    }
    
    /**
     give number Of Items In Section
     - Parameter collectionView: UICollectionView
     - Parameter section: Int
     - Returns number of cells in this section
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegateViewModel?.numberOfItemsInSection(indexOfSelectedCategory: self.indexOfClickedCategory) ?? 0
    }
    
    /**
     get cell  At index path
     - Parameter collectionView: UICollectionView
     - Parameter indexPath: IndexPath
     - Returns collection view cell
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.getReuseIdentifier(), for: indexPath) as! CustomCollectionViewCell
        let representable = self.delegateViewModel?.representableForItemAt(sectionIndex: self.indexOfClickedCategory, indexPath: indexPath)
        cell.setup(representable: representable!)
        
        // TODO: - Move to cell
        cell.setCornerRadious(radious: 4)
        cell.delegate = self
        return cell
    }
    
    @objc private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let screenSize: CGRect = UIScreen.main.bounds
        let contentView = content!
        let superView = contentView.superview!
        let translation = gestureRecognizer.translation(in: contentView)
        if gestureRecognizer.state == .began {
            self.positionsOfYAxisForSwapView.append(translation.y)
            let x = superView.frame.size.height - translation.y
            if  x < screenSize.height*0.88 && screenSize.height*0.15 < x{
                superView.frame.size.height = x
                superView.frame = CGRect(x: 0, y: screenSize.height - x, width: screenSize.width, height: x)
            }
        }
        if gestureRecognizer.state == .changed {
            self.positionsOfYAxisForSwapView.append(translation.y)
            let x = superView.frame.size.height - (positionsOfYAxisForSwapView[positionsOfYAxisForSwapView.count-1]-positionsOfYAxisForSwapView[positionsOfYAxisForSwapView.count-2])
            if  x < screenSize.height*0.88 && screenSize.height*0.15 < x{
                superView.frame.size.height = x
                superView.frame = CGRect(x: 0, y: screenSize.height - x, width: screenSize.width, height: x)
            }
        }
    }
    
    /**
     Reload view to update it
     */
    func reloadView(){
        let screenSize: CGRect = UIScreen.main.bounds
        if self.representables.count < 2 {
            for view in self.blueView.subviews {
                if let labelView =  view as? UILabel {
                    labelView.removeFromSuperview()
                }else if let segmentView = view as? JNSegmentedCollectionView {
                    segmentView.removeFromSuperview()
                }
            }
            let label = UILabel(frame: CGRect(x: 10, y: 0, width: screenSize.width * 0.7, height: screenSize.height*0.05))
            label.text = "selected "+(self.selectedCategoryName ?? "")
            self.selectedCategoryName = self.representables[0].categoryName
            label.textColor = .white
            label.font = UIFont(name: "OpenSans-Bold", size: 10)
            self.blueView.addSubview(label)
        }else{
            var arrOfSegmentItemsStrings: [NSAttributedString] = []
            for (index,category) in self.representables.enumerated() {
                if index == self.selectedIndex {
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
                    arrOfSegmentItemsStrings.append(NSAttributedString(string: category.categoryName,attributes: myAttribute))
                    
                }else{
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
                    arrOfSegmentItemsStrings.append(NSAttributedString(string: category.categoryName,attributes: myAttribute))
                }
            }
            for view in self.blueView.subviews {
                if let segmentView = view as? JNSegmentedCollectionView {
                    segmentView.removeFromSuperview()
                }
            }
            let segmentedControlView = reBuildSegmentView(arrOfSegmentItems: arrOfSegmentItemsStrings)
            segmentedControlView.selectedIndex = self.indexOfClickedCategory
            self.blueView.addSubview(segmentedControlView)
        }
        self.collectionView.reloadData()
    }
    
    /**
     cancle Image Tapped
     - parameter cellID: Int
     */
    func cancleButtonClicked(cellID: Int) {
        self.delegate?.cancleImagePressed(key: cellID, section: self.selectedCategoryName!)
    }
    
    /**
     Build segment view
     - parameter arrOfSegmentItems: [NSAttributedString]
     - returns segment view
     */
    func reBuildSegmentView (arrOfSegmentItems: [NSAttributedString]) -> JNSegmentedCollectionView {
        let screenSize: CGRect = UIScreen.main.bounds
        let segmentedControlView = JNSegmentedCollectionView()
        segmentedControlView.frame = CGRect(x: self.blueView.frame.minX+2, y: 2, width: self.blueView.frame.width-5 , height: screenSize.height*0.03)
        
        let jNSegmentedCollectionItemVerticalSeparatorOptions = JNSegmentedCollectionItemVerticalSeparatorOptions (
            heigthRatio: 0.0,
            width: 0,
            color: UIColor.blue
        )
        let jNSegmentedCollectionItemOptions =  JNSegmentedCollectionItemOptions(cornerRadius:6.93,
                                                                                 backgroundColor:  UIColor(red: 0, green: 0.5333, blue:0.866, alpha: 1),
                                                                                 selectedBackgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                                                                 badgeBackgroundColor: .white,
                                                                                 selectedBadgeBackgroundColor: .white,
                                                                                 badgeFont: UIFont.systemFont(ofSize: 16.0),
                                                                                 selectedBadgeFont: UIFont.systemFont(ofSize: 16.0),
                                                                                 badgeTextColor: .gray, selectedBadgeTextColor: .gray)
        let jNSegmentedCollectionOptions = JNSegmentedCollectionOptions(
            backgroundColor: UIColor.systemBlue,
            layoutType: JNSegmentedCollectionLayoutType.fixed(maxVisibleItems: 2), itemOptionType: .single(option:jNSegmentedCollectionItemOptions),
            verticalSeparatorOptions: jNSegmentedCollectionItemVerticalSeparatorOptions,
            scrollEnabled: true,
            contentItemLayoutMargins: 10.0
        )
        
        segmentedControlView.setup(
            items: arrOfSegmentItems,
            selectedItems: [arrOfSegmentItems[self.representables.count-1]],
            options: jNSegmentedCollectionOptions,
            badgeCounts: []
        )
        segmentedControlView.selectedIndex = self.selectedIndex
        segmentedControlView.didSelectItem = { segment in
            if arrOfSegmentItems[segment].string == "Classifications" {
                self.selectedCategoryName = FilterCategory.Classifications.rawValue
                self.collectionView.reloadData()
                
                
            }else if arrOfSegmentItems[segment].string == "Cusine" {
                self.selectedCategoryName = FilterCategory.Cusine.rawValue
                self.collectionView.reloadData()
                
            }else if arrOfSegmentItems[segment].string == "Positions" {
                self.selectedCategoryName = FilterCategory.Positions.rawValue
                self.collectionView.reloadData()
            }else {
                self.selectedCategoryName = FilterCategory.Skills.rawValue
                self.collectionView.reloadData()
            }
            self.selectedIndex = segment
            self.indexOfClickedCategory = segmentedControlView.selectedIndex
            var arrOfSegmentItems2 : [NSAttributedString] = []
            for (index,category) in self.representables.enumerated() {
                if index == self.selectedIndex {
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
                    arrOfSegmentItems2.append(NSAttributedString(string: category.categoryName,attributes: myAttribute))
                    
                }else{
                    let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.white ]
                    arrOfSegmentItems2.append(NSAttributedString(string: category.categoryName,attributes: myAttribute))
                }
            }
            segmentedControlView.setup(
                items: arrOfSegmentItems2,
                selectedItems: [arrOfSegmentItems2[self.selectedIndex]],
                options: jNSegmentedCollectionOptions
            )
        }
        
        self.indexOfClickedCategory = segmentedControlView.selectedIndex
        let i = segmentedControlView.selectedIndex
        
        if arrOfSegmentItems[i].string == "Classifications" {
            self.selectedCategoryName = FilterCategory.Classifications.rawValue
            
        }else if arrOfSegmentItems[i].string == "Cusine" {
            self.selectedCategoryName = FilterCategory.Cusine.rawValue
            
        }else if arrOfSegmentItems[i].string == "Positions" {
            self.selectedCategoryName = FilterCategory.Positions.rawValue
            
        }else {
            self.selectedCategoryName = FilterCategory.Skills.rawValue
        }
        segmentedControlView.layer.masksToBounds = true;
        return segmentedControlView
    }
    
}
