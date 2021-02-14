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
    @IBOutlet weak var newBankInfoButton: UIButton!
    
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
        newBankInfoButton.layer.cornerRadius = 15
    }
    
    func downloadData() {
        let url = URL(string: "http://kocinaarte.com/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getUserInfoBank&id_user="+userID
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
                        let titular = info["titular"] as? String
                        let RFC = info["rfc"] as? String
                        let CURP = info["curp"] as? String
                        let domicilioFiscal = info["domicilio_fiscal"] as? String
                        let banco = info["banco"] as? String
                        let noCuenta = info["no_cuenta"] as? String
                        let CLABE = info["clabe"] as? String
                        DispatchQueue.main.async {
                            self.titleName.text = titular
                            self.RFCInformation.text = RFC
                            self.CURPInformation.text = CURP
                            self.fiscalAddressInformation.text = domicilioFiscal
                            self.bankInformation.text = banco
                            self.accountInformation.text = noCuenta
                            self.CLABEInformation.text = CLABE
                        }
                        
                    } else {
                        print("Error al actualizar la informacion.")
                    }
                }
            }
        }.resume()
    }
    
    @IBAction func saveNewBankData(_ sender: Any) {
        // POST REQUEST
        let url = URL(string: "http://kocinaarte.com/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let RFC = RFCInformation.text!
        let CURP = CURPInformation.text!
        let domicilioFiscal = fiscalAddressInformation.text!
        let bank = bankInformation.text!
        let account = accountInformation.text!
        let CLABE = CLABEInformation.text!
        let string1 = "funcion=updateUserInfoBank&id_user="+userID
        let string2 = "&bank="+bank
        let string3 = "&account_number="+account
        let string4 = "&clabe="+CLABE
        let string5 = "&rfc="+RFC
        let string6 = "&curp="+CURP
        let string7 = "&fiscal="+domicilioFiscal
        let postString = string1+string2+string3+string4+string5+string6+string7
        request.httpBody = postString.data(using: .utf8) // SE codifica a UTF-8
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
            if let parseJSON = json {
                let userUpdated = parseJSON["state"] as? String
                
                if userUpdated == "200" {
                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: "¡Éxito!", message: "¡Se han actualizado tus datos correctamente!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
