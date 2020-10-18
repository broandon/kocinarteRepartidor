//
//  chatDetailViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit
import NVActivityIndicatorView

class chatDetailViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messagesTableView: UITableView!
    
    var chatID: String = ""
    var titulo: String = ""
    
    var mensajes: [Dictionary<String, Any>] = []
    let userID = UserDefaults.standard.string(forKey: "UserID")
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        getInfo()
    }
    
    //MARK: Funcs
    
    func setupView() {
        messageTextField.addLine(position: .LINE_POSITION_BOTTOM, color: #colorLiteral(red: 1, green: 0, blue: 0.009361755543, alpha: 1), width: 3)
        self.titleLabel.text = titulo
    }
    
    func setupTableView() {
        messagesTableView.transform = CGAffineTransform(rotationAngle: (-.pi))
        messagesTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: messagesTableView.bounds.size.width - 10)
        messagesTableView.allowsSelection = false
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.tableFooterView = UIView()
        messagesTableView.separatorStyle = .none
        let documentXib = UINib(nibName: "messageTableViewCell", bundle: nil)
        messagesTableView.register(documentXib, forCellReuseIdentifier: messageTableViewCell.cellidentifier)
    }
    
    func getInfo() {
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getChatDetail&id_user="+userID!+"&id_chat="+chatID
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject> {
                print(dictionary)
                if let items = dictionary["data"] {
                    for d in items as! [Dictionary<String, AnyObject>] {
                        self.mensajes.append(d)
                    }
                }
            }
            DispatchQueue.main.async {
                
                if self.mensajes.count > 0 {
                    self.stopAnimating()
                    self.messagesTableView.reloadData()
                }
            }
        }.resume()
    }
    
    //MARK: Buttons
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        if messageTextField.text?.isEmpty == true {
            print("No text.")
            return
        } else {
            print("Sending Message")
            let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
            request.httpMethod = "POST" // Metodo
            let postString = "funcion=sendMessageChat&id_user="+userID!+"&message="+messageTextField.text!+"&id_chat="+chatID+"&tipo=2"
            request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil, response != nil else {
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                if let dictionary = json as? Dictionary<String, Any> {
                    if let state = dictionary["state"] {
                        print(state)
                        let stateNumber = state as! String
                        
                        if stateNumber == "200" {
                            DispatchQueue.main.async {
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.mensajes.removeAll()
                                    self.getInfo()
                                    self.messagesTableView.reloadData()
                                    self.messageTextField.text = ""
                                })
                            }
                            let nc = NotificationCenter.default
                            nc.post(name: Notification.Name("messageSent"), object: nil)
                        }
                    }
                }
                DispatchQueue.main.async {
                    if self.mensajes.count > 0 {
                        self.messagesTableView.reloadData()
                    }
                }
            }.resume()
        }
    }
}

extension chatDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mensajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: messageTableViewCell.cellidentifier, for: indexPath) as? messageTableViewCell else {
            return UITableViewCell()
        }
        mensajes.sort { ($0["Id"] as! String) > ($1["Id"] as! String) }
        let item = mensajes[indexPath.row]
        let persona = item["persona"] as? String
        let comentarios = item["comentarios"]
        let tipo = item["tipo"] as? String
        
        if tipo == "1" {
            cell.messageBackground.backgroundColor = #colorLiteral(red: 0.2800812721, green: 0.6464880705, blue: 0.6470355392, alpha: 1)
        }
        cell.tituloMensaje.text = ""
        cell.nombrePersona.text = persona
        cell.message.text = comentarios as! String
        cell.titleHeight.constant = 0
        cell.nameTopConstraint.constant = 0
        cell.transform = CGAffineTransform(rotationAngle: (-.pi))
        return cell
    }
    
    
}
