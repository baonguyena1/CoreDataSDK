//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Bao Nguyen on 24/12/2020.
//

import UIKit
import CoreDataSDK

class ViewController: UIViewController {
    
    private var coreDataManager: CoreDataManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        let bundle = Bundle.main
        coreDataManager = CoreDataManager(momdName: "Sample", bundle: bundle)
        
        let product = Product(context: coreDataManager.context)
        product.title = "Product"
        product.subTitle = "SubTitle"
        coreDataManager.save()
        
        let products = coreDataManager.fetchObjects(entity: Product.self)
        print(products.count)
        print(products)
    }


}

