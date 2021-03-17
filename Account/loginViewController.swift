//
//  loginViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 16/10/20.
//

import UIKit
import NVActivityIndicatorView
import Hero

class loginViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        logInCheckUp()
        let pushManager = PushNotificationManager(userID: "currently_logged_in_user_id")
        print(pushManager.getToken())
    }
    
    //MARK: Funcs
    
    func setupView() {
        mailTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        loginButton.layer.cornerRadius = 15
    }
    
    func goToRoot(){
        DispatchQueue.main.async {
                self.stopAnimating()
                self.hero.isEnabled = true
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainScreen") as! UITabBarController
                newViewController.hero.modalAnimationType = .uncover(direction: .up)
                self.hero.replaceViewController(with: newViewController)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
        }
    }
    
    func logInCheckUp() {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homePage = storyBoard.instantiateViewController(withIdentifier: "mainScreen") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate
                appDelegate?.window??.rootViewController = homePage
        }
    }
    
    //MARK: Buttons
    
    @IBAction func loginButton(_ sender: Any) {
        
        if mailTF.text?.isEmpty == true {
            let alert = UIAlertController(title: "El campo de correo no puede estar vacío", message: "Ingresa tu correo electrónico.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if passwordTF.text?.isEmpty == true {
            let alert = UIAlertController(title: "El campo de contraseña no puede estar vacío", message: "Ingresa tu contraseña.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=login&email="+mailTF.text!+"&password="+passwordTF.text!
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            
            if let data = data {
                let loginInfo = try? JSONDecoder().decode(octSCRLoginResponse.self, from: data)
                
                if loginInfo?.state == "200" {
                    
                    if let dictionary = json as? Dictionary<String, AnyObject> {

                        if let items = dictionary["data"] as? Dictionary<String, Any> {
                            let name = items["first_name"] as! String
                            let surname = items["last_name"] as! String
                            let email = items["email"] as! String
                            let id = items["id_user"] as! String
                            let type = items["tipo"]
                            let tipoDeUser = "\(type ?? "2")"
                            UserDefaults.standard.set(id, forKey: "UserID")
                            UserDefaults.standard.set(name, forKey: "firstName")
                            UserDefaults.standard.set(surname, forKey: "lastName")
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(tipoDeUser, forKey: "typeOfUser")
                            self.stopAnimating()
                            self.goToRoot()
                        }
                    }
                }
                
                if loginInfo?.state == nil {
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        let alert2 = UIAlertController(title: "Ha habido un error al recibir tu información.", message: "Por favor intentalo de nuevo mas tarde.", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
                        self.present(alert2, animated: true)
                        return
                    }
                }
                
                if loginInfo?.state == "101" {
                    DispatchQueue.main.async {
                        self.stopAnimating()
                        let alert = UIAlertController(title: "Error", message: "Tu contraseña es incorrecta o ese correo no está registrado", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            }
        }
        task.resume()
    }
    
    @IBAction func Crearcuenta(_ sender: Any) {
        let alert = UIAlertController(title: "Creando cuenta", message: "Iras a nuestro portal para crear tu cuenta. Despues regresa a la app e inicia sesión.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ya tengo cuenta", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Crear cuenta", style: .default, handler: { action in
            if let url = URL(string: "https://www.kocinaarte.com/administracion/login.php") {
                UIApplication.shared.open(url)
            }

        }))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "recoverAccountViewController") as! recoverAccountViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
