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
    }

    @IBAction private func add(_ sender: UIButton) {
        let product = Product(context: coreDataManager.context)
        product.title = "Product"
        product.subTitle = "SubTitle"
        coreDataManager.save()
    }
    
    @IBAction private func fetch(_ sender: UIButton) {
        let products = coreDataManager.fetchObjects(entity: Product.self)
        print(products.count)
        print(products)
    }
}

