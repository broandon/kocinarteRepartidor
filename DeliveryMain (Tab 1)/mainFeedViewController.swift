//
//  mainFeedViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit
import NVActivityIndicatorView

class mainFeedViewController: UIViewController, NVActivityIndicatorViewable, showOrderDetail {
    
    //MARK: Outlets
    
    var pedidos: [Dictionary<String, Any>] = []
    let userID = UserDefaults.standard.string(forKey: "UserID")
    @IBOutlet weak var deliveryTableView: UITableView!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        downloadData()
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(refreshData), name: Notification.Name("orderAccepted"), object: nil)
    }
    
    //MARK: Funcs
    
    func showTheOrderDetail(idOrder: String, typeOfOrder: String) {
        let myViewController = profileDeliveryDetailViewController(nibName: "profileDeliveryDetailViewController", bundle: nil)
        if #available(iOS 13.0, *) {
            myViewController.isModalInPresentation = true
        } else {
            // Theres is no fallback in earlier versions. They will just use the button normally.
        }
        myViewController.idOrder = idOrder
        myViewController.typeOfOrder = typeOfOrder
        myViewController.comingFrom = "main"
        present(myViewController, animated: true, completion: nil)
    }
    
    @objc func refreshData() {
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        let url = URL(string: HTTPManager.baseURL())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getOrdersAvailable&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject>{
                print(dictionary)
                self.pedidos.removeAll()
                if let pedidos = dictionary["data"] {
                    for d in pedidos as! [Dictionary<String, AnyObject>] {
                        self.pedidos.append(d)
                    }
                }
            }
            DispatchQueue.main.async {
                self.stopAnimating()
                if self.pedidos.count > 0 {
                    self.deliveryTableView.reloadData()
                }
            }
        }.resume()
    }
    
    func downloadData() {
        startAnimating(type: .ballScaleMultiple, backgroundColor: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.2990421661))
        let url = URL(string: HTTPManager.baseURL())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getOrdersAvailable&id_user="+userID!
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil, response != nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            
            if let dictionary = json as? Dictionary<String, AnyObject>{
                print(dictionary)
                self.pedidos.removeAll()
                if let pedidos = dictionary["data"] {
                    for d in pedidos as! [Dictionary<String, AnyObject>] {
                        self.pedidos.append(d)
                    }
                }
            }
            DispatchQueue.main.async {
                self.stopAnimating()
                if self.pedidos.count > 0 {
                    self.deliveryTableView.reloadData()
                }
            }
        }.resume()
    }
    
    func setupTableView() {
        deliveryTableView.allowsSelection = true
        deliveryTableView.delegate = self
        deliveryTableView.dataSource = self
        deliveryTableView.tableFooterView = UIView()
        deliveryTableView.separatorStyle = .none
        let documentXib = UINib(nibName: "deliveryTableViewCell", bundle: nil)
        deliveryTableView.register(documentXib, forCellReuseIdentifier: deliveryTableViewCell.cellidentifier)
    }
}

//MARK: Extension

extension mainFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pedidos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: deliveryTableViewCell.cellidentifier, for: indexPath) as? deliveryTableViewCell else {
            return UITableViewCell()
        }
        let item = pedidos[indexPath.row]
        let platillo = item["platillo"]
        let costo = item["costo"]
        let fecha = item["fecha_compra"] as! String
        let estatus = item["estatus"] as! String
        let type = item["tipo"] as! String
        let ID = item["Id"] as! String
        cell.delegate = self
        let orderID = Int(ID)
        cell.showDetailsButton.tag = orderID!
        cell.typeOfOrder = type
        cell.nombreOrden.text = platillo as? String
        cell.estatusOrden.text = "Estatus: " + estatus
        cell.fechaOrden.text = "Fecha: " + fecha
        cell.costoOrden.text = "Costo: \(costo ?? "Error en el precio")"
        return cell
    }
}
