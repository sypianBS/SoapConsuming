//
//  ViewController.swift
//  ConsumingSoapService
//
//  Created by Beniamin on 15.05.22.
//

import UIKit

class ViewController: UIViewController {
    
    let xMLParsingManager = XMLParsingManager.shared
    typealias requestUtils = XMLParsingManager.XMLRequestUtils
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get details for a specific student
        let getStudentUrlRequest = requestUtils.getStudentSoapRequest(studentId: 1)
        xMLParsingManager.consumeSoap(urlRequest: getStudentUrlRequest)
        
        //get total number of students
        let getTotalNumberOfStudents = requestUtils.getNumberOfStudentsSoapRequest()
        xMLParsingManager.consumeSoap(urlRequest: getTotalNumberOfStudents)
    }
    
}
