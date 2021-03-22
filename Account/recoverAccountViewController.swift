//
//  recoverAccountViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 16/10/20.
//

import UIKit
import NVActivityIndicatorView

class recoverAccountViewController: UIViewController, NVActivityIndicatorViewable {
    
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
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        if mailTF.text?.isEmpty == true {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "¿No olvidas algo?", message: "Debes de escribir una dirección de correo electrónico para recuperar tu cuenta.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok.", style: .default, handler: nil))
                self.present(alert, animated: true)
                self.stopAnimating()
                return
            }
        } else {
            let url = URL(string: HTTPManager.baseURL())!
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
                        
                        if state as? String == "200" {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "¡Éxito!", message: "Se ha enviado un correo con las instrucciones para reestablecer tu cuenta.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Regresar", style: .cancel, handler: { action in
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    
                                }))
                                self.stopAnimating()
                                self.present(alert, animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "¡Error!", message: "No hemos encontrado tu correo o hemos encontrado un problema en nuestro servidor. Verifica tus datos o intentalo en unos minutos.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                                self.stopAnimating()
                                self.present(alert, animated: true)
                            }
                        }
                    }
                }
            }.resume()
        }
    }
}

