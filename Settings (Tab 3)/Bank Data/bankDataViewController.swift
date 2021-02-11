//
//  bankDataViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 11/02/21.
//

import UIKit

class bankDataViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var RFCInformation: UITextField!
    @IBOutlet weak var CURPInformation: UITextField!
    @IBOutlet weak var fiscalAddressInformation: UITextField!
    @IBOutlet weak var bankInformation: UITextField!
    @IBOutlet weak var accountInformation: UITextField!
    @IBOutlet weak var CLABEInformation: UITextField!
    
    let userID = UserDefaults.standard.value(forKey: "UserID") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        downloadData()
    }

    func setupView() {
        RFCInformation.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        CURPInformation.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        fiscalAddressInformation.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        bankInformation.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        accountInformation.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        CLABEInformation.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
    }
    
    func downloadData() {
        let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getBankInfo&id_user="+userID
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject>{
                print("This is the dictionary")
                print(dictionary)
                if let pedidos = dictionary["data"] as? Dictionary<String, AnyObject> {
                    
                    if let info = pedidos["info"] as? Dictionary<String, AnyObject>{
                        let image = info["imagen"] as? String
                        let name = info["nombre"] as? String
                        let surname = info["apellidos"] as? String
                        let phone = info["telefono"] as? String
                        
                        DispatchQueue.main.async {
                            
                        }
                        
                    } else {
                        print("Error al actualizar la informacion.")
                    }
                }
            }
        }.resume()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
