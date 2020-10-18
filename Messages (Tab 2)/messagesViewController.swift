//
//  messagesViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit
import NVActivityIndicatorView

class messagesViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Outlets
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var mensajes: [Dictionary<String, Any>] = []
    let userID = UserDefaults.standard.string(forKey: "UserID")
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        downloadInfo()
        addObserver()
    }
    
    //MARK: Funcs
    
    func addObserver() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(refreshList), name: Notification.Name("messageSent"), object: nil)
    }
    
    func setupTableView() {
        messagesTableView.allowsSelection = true
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messagesTableView.tableFooterView = UIView()
        messagesTableView.separatorStyle = .none
        let documentXib = UINib(nibName: "messageTableViewCell", bundle: nil)
        messagesTableView.register(documentXib, forCellReuseIdentifier: messageTableViewCell.cellidentifier)
    }
    
    @objc func refreshList() {
        DispatchQueue.main.async {
            self.mensajes.removeAll()
            self.downloadInfo()
            self.messagesTableView.reloadData()
        }
    }
    
    func downloadInfo() {
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        let url = URL(string: "http://bilcom.mx/sazon_casero/administracion/webservice_repartidor/controller_last.php")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getChatList&id_user="+userID!
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
                    self.messagesTableView.reloadData()
                    self.stopAnimating()
                }
            }
        }.resume()
    }
    
    
}

//MARK: Extension

extension messagesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mensajes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: messageTableViewCell.cellidentifier, for: indexPath) as? messageTableViewCell else {
            return UITableViewCell()
        }
        let item = mensajes[indexPath.row]
        let titulo = item["titulo"] as? String
        let persona = item["persona"] as? String
        let mensaje = item["mensaje"] as? String
        cell.selectionStyle = .none
        cell.tituloMensaje.text = titulo
        cell.nombrePersona.text = persona
        cell.message.text = mensaje
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = mensajes[indexPath.row]
        let Id = item["Id"] as? String
        let titulo = item["titulo"] as? String
        let myViewController = chatDetailViewController(nibName: "chatDetailViewController", bundle: nil)
        if #available(iOS 13.0, *) {
            myViewController.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        myViewController.chatID = Id!
        myViewController.titulo = titulo!
        present(myViewController, animated: true, completion: nil)
    }
    
}
