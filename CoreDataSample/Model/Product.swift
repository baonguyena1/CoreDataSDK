//
//  Product.swift
//  CoreDataSample
//
//  Created by Bao Nguyen on 24/12/2020.
//

import Foundation
import CoreData

@objc(Product)
class Product: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var subTitle: String?
}
