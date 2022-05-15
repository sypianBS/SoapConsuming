//
//  ViewController.swift
//  ConsumingSoapService
//
//  Created by Beniamin on 15.05.22.
//

import UIKit

class ViewController: UIViewController {

    let xmlMessage: String = """
    <?xml version="1.0" encoding="utf-8"?>
    <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
    xmlns:std="http://www.bensypianskinamespace.com">
      <soap:Body>
        <std:getStudent>
          <id>1</id>
        </std:getStudent>
      </soap:Body>
    </soap:Envelope>
    """
    
    let soapServiceUrl = "http://localhost:8080/ws"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consumeSoap()
    }
    
    private func consumeSoap() {
        var urlRequest = URLRequest(url: URL(string: soapServiceUrl)!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = xmlMessage.data(using: .utf8)
        urlRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {data, response, error -> Void in
            let strData = String(data: data!, encoding: .utf8)
            print(String(describing: (strData)))
            
            if error != nil {
                print(String(describing: (error)))
            }
        })
        task.resume()
        
    }

}

