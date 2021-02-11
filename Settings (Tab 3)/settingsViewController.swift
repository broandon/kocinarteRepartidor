//
//  settingsViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit

class settingsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: Buttons
    
    @IBAction func openProfileController(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "profileViewController") as! profileViewController
        present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func myDeliveries(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "myDeliveriesViewController") as! myDeliveriesViewController
        present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func openPrivacyButton(_ sender: Any) {
        if let url = URL(string: "http://bilcom.mx/sazon_casero/privacidad/privacidad.pdf") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func bankData(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "bankDataViewController") as! bankDataViewController
        present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func termsAndConditionsButton(_ sender: Any) {
        if let url = URL(string: "http://kocinaarte.com/aviso/aviso_privacidad_app_repartidor.pdf") {
            UIApplication.shared.open(url)
        }
    }
    
    
    @IBAction func closeSessionAction(_ sender: Any) {
        let alert = UIAlertController(title: "Cerrar Sesión", message: "¿De verdad quieres cerrar sesión? Tendrás que introducir tu usuario y contraseña nuevamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Volver", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cerrar Sesión", style: .destructive, handler: { action in
            self.present(alert, animated: true)
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            self.hero.isEnabled = true
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController") as! loginViewController
            newViewController.hero.modalAnimationType = .cover(direction: .down)
            self.hero.replaceViewController(with: newViewController)
            
        }))
        present(alert, animated: true, completion: nil)
    }
}
