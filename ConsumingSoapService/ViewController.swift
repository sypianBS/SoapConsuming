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
    
    var xmlDict = [String: Any]()
    var xmlDictArr = [[String: Any]]()
    var currentElement = ""

    
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
            
            let xmlParser = XMLParser(data: data!)
            xmlParser.delegate = self
            xmlParser.parse()
            
            if error != nil {
                print(String(describing: (error)))
            }
        })
        task.resume()
    }

}

//parsing idea based on https://dev.to/midhetfatema94/xml-parsing-in-swift-4l8h
extension ViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "student" {
               xmlDict = [:]
           } else {
               currentElement = elementName
           }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlDict[currentElement] == nil {
                xmlDict.updateValue(string, forKey: currentElement)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "student" {
            xmlDictArr.append(xmlDict)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if let student = Student(details: xmlDict) {
            print(student.id)
            print(student.name)
        }
    }
}

struct Student {
    let id: Int
    let name: String
    
    init?(details: [String: Any]) {
        if let stringId = details["id"] as? String, let intId = Int(stringId) {
            id = intId
        } else {
           return nil
        }
        name = details["name"] as? String ?? ""
    }
}

