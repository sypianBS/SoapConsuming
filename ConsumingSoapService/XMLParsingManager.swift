//
//  XMLParsingManager.swift
//  ConsumingSoapService
//
//  Created by Beniamin on 15.05.22.
//

import Foundation

final class XMLParsingManager: NSObject {
    
    var xmlDict = [String: Any]()
    var xmlDictArr = [[String: Any]]()
    var currentElement = ""
    var numberOfStudents: String?
    
    static let shared = XMLParsingManager()
    
    private override init() {}
    
        
    func consumeSoap(urlRequest: URLRequest) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {data, response, error -> Void in
                  
            if error != nil {
                print(String(describing: (error)))
            }
            
            if let data = data {
                self.startParsing(data: data)
            }
            
        })
        task.resume()
    }
    
    private func startParsing(data: Data) {
        let xmlParser = XMLParser(data: data)
        xmlParser.delegate = self
        xmlParser.parse()
    }
    
    struct XMLRequestUtils {
        private static let idPlaceholder = "ID_PLACEHOLDER"
        
        private static let xmlMessageGetStudent: String = """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:std="http://www.bensypianskinamespace.com">
          <soap:Body>
            <std:getStudentRequest>
              <id>
        """
        + idPlaceholder +
        """
        </id>
            </std:getStudentRequest>
          </soap:Body>
        </soap:Envelope>
        """
        
        private static let xmlMessageGetNumberOfStudents: String = """
        <?xml version="1.0" encoding="utf-8"?>
        <soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:std="http://www.bensypianskinamespace.com">
          <soap:Body>
            <std:getNumberOfStudentsRequest>
            </std:getNumberOfStudentsRequest>
          </soap:Body>
        </soap:Envelope>
        """
        
        private static let soapServiceUrl = "http://localhost:8080/ws"
        
        private static var basicUrlRequest: URLRequest {
            var urlRequest = URLRequest(url: URL(string: soapServiceUrl)!)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            return urlRequest
        }
        
        static func getStudentSoapRequest(studentId: Int) -> URLRequest {
            var urlRequest = basicUrlRequest
            urlRequest.httpBody = xmlMessageGetStudent.replacingOccurrences(of: idPlaceholder, with: "\(studentId)").data(using: .utf8)
            return urlRequest
        }
        
        static func getNumberOfStudentsSoapRequest() -> URLRequest {
            var urlRequest = basicUrlRequest
            urlRequest.httpBody = xmlMessageGetNumberOfStudents.data(using: .utf8)
            return urlRequest
        }
    }
}

//parsing idea based on https://dev.to/midhetfatema94/xml-parsing-in-swift-4l8h
extension XMLParsingManager: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "student" {
            xmlDict = [:]
        } else {
            currentElement = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if currentElement == "numberOfStudents" {
                numberOfStudents = string
            } else if xmlDict[currentElement] == nil {
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
            print("student id: " + student.id.description)
            print("student name: " + student.name)
            xmlDict = [:] //prevent second print for another request
        }
        if let numberOfStudents = numberOfStudents {
            print("numberOfStudents: " + numberOfStudents)
        }
    }
}
