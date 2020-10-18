//
//  profileViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class profileViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var saveProfileInfoButton: UIButton!
    
    let userID = UserDefaults.standard.value(forKey: "UserID") as! String
    
    //MARK: ViewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        downloadData()
    }
    
    //MARK: Funcs
    
    func setupView() {
        nameTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        surnameTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        phoneTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        profileImage.makeRounded()
        saveProfileInfoButton.layer.cornerRadius = 15
    }
    
    func downloadData() {
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getUserInfo&id_user="+userID
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
                            self.nameTF.text = name
                            self.profileImage.sd_setImage(with: URL(string: image ?? ""), completed: nil)
                            self.surnameTF.text = surname
                            self.phoneTF.text = phone
                            self.stopAnimating()
                        }
                        
                    } else {
                        print("Error al actualizar la informacion.")
                    }
                }
            }
        }.resume()
    }
    
    //MARK: Buttons
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveNewInfo(_ sender: Any) {
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        if nameTF.text?.isEmpty == true {
            let alert = UIAlertController(title: "Error", message: "No puedes dejar tu nombre vacio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Escribir un nombre", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.stopAnimating()
            return
        }
        
        if surnameTF.text?.isEmpty == true {
            let alert = UIAlertController(title: "Error", message: "No puedes dejar tu apellido vacio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Escribir un apellido", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.stopAnimating()
            return
        }
        
        
        if phoneTF.text?.isEmpty == true {
            let alert = UIAlertController(title: "Error", message: "No puedes dejar tu numero telefonico vacio.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Escribir un teléfono", style: .default, handler: nil))
            self.present(alert, animated: true)
            self.stopAnimating()
            return
        }
        
        
        // POST REQUEST
        let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let name = nameTF.text!
        let surname = surnameTF.text!
        let phone = phoneTF.text!
        let string1 = "funcion=updateUser&id_user="+userID
        let string2 =  "&first_name="+name
        let string3 = "&last_name="+surname
        let string4 = "&phone="+phone
        let postString = string1+string2+string3+string4
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
                        self.stopAnimating()
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        task.resume()
    }
    
}
