//
//  loginViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 16/10/20.
//

import UIKit

class loginViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Funcs
    
    func setupView() {
        mailTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        passwordTF.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        loginButton.layer.cornerRadius = 15
    }
    
    //MARK: Buttons
    
    @IBAction func loginButton(_ sender: Any) {
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "recoverAccountViewController") as! recoverAccountViewController
        self.present(nextVC, animated: true, completion: nil)
    }
    
}
