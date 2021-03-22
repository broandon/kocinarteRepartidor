//
//  HTTPManager.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 21/03/21.
//

import Foundation
import Alamofire
import AlamofireImage

class HTTPManager {
    
    class func baseURL() -> String {
        let baserURLString = "http://kocinaarte.com/administracion/webservice_repartidor/controller_last.php"
        return baserURLString
    }
    
    class func uploadImage( image:UIImage, completionHandler: @escaping (_ responseData: String, _ errorMessage: String?) -> ()) {
        
        func convertToBase64(image: UIImage) -> String {
            return image.pngData()!
                .base64EncodedString()
        }
        
        let imageString = convertToBase64(image: image)
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append("uploadImage".data(using: String.Encoding.utf8)!, withName: "funcion")
            multipartFormData.append(imageString.data(using: String.Encoding.utf8)!, withName: "image")
        }, to: HTTPManager.baseURL(), usingThreshold: UInt64.init(), method: .post, headers: headers).response{ response in
            if response.error == nil {
                do {
                    if let jsonData = response.data {
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        if let data = parsedData["data"] as? Dictionary<String, String> {
                            let image = data["image_name"]
                            completionHandler(image!, "")
                        }
                    }
                }
                catch {
                    
                }
            }
        }
    }
    
    class func postRequest( params: [String: Any] = [:], completionHandler: @escaping (_ responseData: Dictionary<String, AnyObject>, _ errorMessage: String?) -> ()) {
        print("Making a request.")
        AF.request(HTTPManager.baseURL(), method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        let resultRequest = try! JSONSerialization.jsonObject(with: data, options: [])
                        if let resultParsedToDictionary = resultRequest as? Dictionary<String, AnyObject> {
                            print(resultParsedToDictionary)
                            if (resultParsedToDictionary["status_msg"] as? String) == "OK" &&
                                (resultParsedToDictionary["state"] as? String) == "200" {
                                completionHandler(resultParsedToDictionary, "")
                            }
                            else {
                                completionHandler(Dictionary(), "error_get_info")
                            }
                        } else {
                            completionHandler(Dictionary(), "error_get_info")
                        }
                    } else {
                        completionHandler(Dictionary(), "error_get_info")
                    }
                    break
                case .failure(let error):
                    completionHandler(Dictionary(), "\(error.localizedDescription)")
                }
            }
    }
    
} // HTTP Manager Class
