//
//  ViewController.swift
//  ConsumingSoapService
//
//  Created by Beniamin on 15.05.22.
//

import UIKit

class ViewController: UIViewController {
    
    let xMLParsingManager = XMLParsingManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        xMLParsingManager.consumeSoap()
    }
    
}
