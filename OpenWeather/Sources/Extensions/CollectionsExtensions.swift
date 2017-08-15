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
