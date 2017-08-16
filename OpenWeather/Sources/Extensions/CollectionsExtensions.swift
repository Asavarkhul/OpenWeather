//
//  CollectionsExtensions.swift
//  OpenWeather
//
//  Created by Bertrand on 14/08/2017.
//  Copyright © 2017 Bertrand Bloc'h. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {
    /**
     Returns a reusable table-view cell object located by its Class.
     
     - parameter UITableViewCell.Type: The class of the cell which should be dequeued.
     
     - returns: A UITableViewCell object or nil if no such object exists in the reusable-cell queue.
     */
    public func dequeueReusableCellWithClass<T: UITableViewCell>(_ cellClass: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: cellClass.defaultReuseIdentifier()) as! T
    }
    
    /**
     Shortcut for registerNib:forCellReuseIdentifier: which uses the value returned by defaultReuseIdentifier for the reuse identifier.
     
     - parameter UITableViewCell.Type: A class which is a subclass of UITableViewCell.
     */
    public func registerNib(name nibName: String, cellClass: UITableViewCell.Type) {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: cellClass))
        self.register(nib, forCellReuseIdentifier: cellClass.defaultReuseIdentifier())
    }
    
    /**
     Shortcut for registerNib:forCellReuseIdentifier: which uses the value returned by defaultReuseIdentifier for the reuse identifier.
     
     - parameter UITableViewCell.Type: A class which is a subclass of UITableViewCell.
     */
    public func registerNib(cellClass: UITableViewCell.Type) {
        self.registerNib(name: cellClass.defaultReuseIdentifier(), cellClass: cellClass)
    }
}

public extension UICollectionView {
    /**
     Returns a reusable collection-view cell object located by its Class.
     
     - parameter UICollectionViewCell.Type: The class of the cell which should be dequeued.
     
     - parameter indexPath: The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the table view.
     
     - returns: A UICollectionViewCell object.
     */
    public func dequeueReusableCellWithClass<T: UICollectionViewCell>(_ cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.defaultReuseIdentifier(), for: indexPath) as! T
    }
    
    /**
     Shortcut for registerNib:forCellWithReuseIdentifier: which uses the value returned by defaultReuseIdentifier for the reuse identifier.
     
     - parameter UICollectionViewCell: A class which is a subclass of UICollectionViewCell.
     */
    public func registerNib(name nibName: String, cellClass: UICollectionViewCell.Type) {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: cellClass))
        self.register(nib, forCellWithReuseIdentifier: cellClass.defaultReuseIdentifier())
    }
    
    /**
     Shortcut for registerNib:forCellWithReuseIdentifier: which uses the value returned by defaultReuseIdentifier for the reuse identifier.
     
     - parameter UICollectionViewCell: A class which is a subclass of UICollectionViewCell.
     */
    public func registerNib(cellClass: UICollectionViewCell.Type) {
        self.registerNib(name: cellClass.defaultReuseIdentifier(), cellClass: cellClass)
    }
}

public extension UITableViewCell {
    /**
     A default reuse identifier for queuing in UITableView
     
     - returns: A reuse identifier based on Class Name
     */
    public class func defaultReuseIdentifier() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

public extension UICollectionViewCell {
    /**
     A default reuse identifier for queuing in UITableView
     
     - returns: A reuse identifier based on Class Name
     */
    public class func defaultReuseIdentifier() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UICollectionViewFlowLayout {
    
    /**
     Calculates an item size that will meets the given ratio/length requirements inside the flow.
     This function also takes in account parameters of the flow such as scrollDirection, minimumInteritemSpacing, and sectionInsets in order to calculates the best item size.
     
     - parameter ratio: A ratio wich the item size should be constrained to.
     - parameter itemLengthRange: A range representing the min & max length that an item can have. Use Int.max for no limit, or use nil to display 1 item per line or column.
     
     - returns: An item size that meets both ratio & min/max values provided.
     
     'length' here means the width OR the height of an item. The function tranlates the given length range to a width value if the flow layout's scrollDirection is set to Vertical, because you need to fit the items in the available width inside the UICollectionView, not the height. Length because height if we're in an Horizontal scroll direction.
     */
    public func itemSizeThatFits(constrainedToRatio ratio: CGFloat, andConstrainedToLength itemLengthRange: CountableRange<Int>?) -> CGSize {
        if let collectionView = self.collectionView {
            
            let availableBounds: CGRect = collectionView.frame - collectionView.contentInset
            let sectionInsetsLength: Int = Int(self.scrollDirection == .horizontal ? self.sectionInset.top + self.sectionInset.bottom : self.sectionInset.left + self.sectionInset.right)
            let availableLength: Int = Int(self.scrollDirection == .horizontal ? availableBounds.height : availableBounds.width) - sectionInsetsLength
            
            var itemLength = itemLengthRange?.startIndex ?? availableLength
            var numberOfItems: Int = 1
            var currentInteritemSpacing: CGFloat = 0.0
            
            if let range = itemLengthRange {
                repeat {
                    if itemLength >= range.endIndex-1 || itemLength >= availableLength {
                        break
                    }else {
                        itemLength += 1
                    }
                    
                    numberOfItems = availableLength / itemLength
                    let remainder = CGFloat(availableLength) - CGFloat(itemLength * numberOfItems)
                    currentInteritemSpacing = (remainder / CGFloat(numberOfItems-1))
                    
                    
                } while floor(currentInteritemSpacing) > self.minimumInteritemSpacing+1
                
                if itemLength >= availableLength {
                    itemLength = availableLength
                }
            }
            return CGSize(
                width: self.scrollDirection == .vertical ? CGFloat(itemLength) : ceil(CGFloat(itemLength) * ratio),
                height: self.scrollDirection == .horizontal ? CGFloat(itemLength) : ceil(CGFloat(itemLength) / (ratio * 2))
            )
        }
        return CGSize.zero
    }
}
