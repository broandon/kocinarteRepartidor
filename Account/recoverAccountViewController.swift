//
//  recoverAccountViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 16/10/20.
//

import UIKit

class recoverAccountViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var mailTF: UITextField!
    
    //MARK: ViewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Funcs
    
    func setupView() {
        mailTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
    }
    
    //MARK: Buttons
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recoverAction(_ sender: Any) {
        if mailTF.text?.isEmpty == true {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "¿No olvidas algo?", message: "Debes de escribir una dirección de correo electrónico para recuperar tu cuenta.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok.", style: .default, handler: nil))
                self.present(alert, animated: true)
                return
            }
        } else {
            let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
            request.httpMethod = "POST" // Metodo
            let postString = "funcion=recoverAccount&email="+mailTF.text!
            request.httpBody = postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil, response != nil else {
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)

                if let dictionary = json as? Dictionary<String, Any> {

                    if let state = dictionary["state"] {
                        print(state)
                    }
                    
                    if let data = dictionary["data"] as? Dictionary<String, Any> {
                        print(data)
                        if let state = data["state"] {
                            print(state)
                        }
                    }
                }
            }.resume()
        }
    }
}

