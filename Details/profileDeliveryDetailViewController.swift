//
//  profileDeliveryDetailViewController.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 11/02/21.
//

import UIKit
import MapKit

class profileDeliveryDetailViewController: UIViewController {
    
    //MARK: Outlets
    
    //Labels that change
    @IBOutlet weak var topLabel: UIButton!
    @IBOutlet weak var placeAddressLabel: UIButton!
    
    var platillos: [Dictionary<String, Any>] = []
    let userID = UserDefaults.standard.value(forKey: "UserID") as! String
    var idOrder: String = ""
    var typeOfOrder: String = ""
    let annotation = MKPointAnnotation()
    let reuseDocument = "DocumentCellMessages"
    var comingFrom: String = ""
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var menuName: UIButton!
    @IBOutlet weak var offeredBy: UIButton!
    @IBOutlet weak var dishesTableView: UITableView!
    @IBOutlet weak var mapInformation: MKMapView!
    @IBOutlet weak var quantityInfo: UILabel!
    @IBOutlet weak var costInfo: UILabel!
    @IBOutlet weak var shippingCostInfo: UILabel!
    @IBOutlet weak var totalInfo: UILabel!
    @IBOutlet weak var markAsButton: UIButton!
    
    // Values to change the order status and update it
    
    var idStatus:String = ""
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeMapView()
        getInfo()
        setupView()
        setupTableview()
    }
    
    //MARK: Funcs
    
    func setupTableview() {
        let documentXib = UINib(nibName: "dishesTableViewCell", bundle: nil)
        dishesTableView!.register(documentXib, forCellReuseIdentifier: reuseDocument)
        dishesTableView!.delegate = self
        dishesTableView!.dataSource = self
        dishesTableView!.separatorStyle = .none
        dishesTableView!.allowsSelection = false
        dishesTableView!.isScrollEnabled = false
    }
    
    func setupView() {
        markAsButton.layer.cornerRadius = 15
        if comingFrom == "main" {
            self.topLabel.setTitle("Detalle De Pedido Disponible", for: .normal)
            self.placeAddressLabel.setTitle("LUGAR DE ENTREGA", for: .normal)
        } else {
            self.topLabel.setTitle("Detalle De Pedido", for: .normal)
            self.placeAddressLabel.setTitle("DIRECCIÓN DE ESTABLECIMIENTO", for: .normal)
        }
    }
    
    func buttonHandler(orderType: String) {
        switch orderType {
        case "2":
            
            if comingFrom == "main" {
                DispatchQueue.main.async {
                    self.markAsButton.setTitle("Aceptar Pedido", for: .normal)
                }
            }
            
            if comingFrom == "profile" {
                DispatchQueue.main.async {
                    self.markAsButton.isHidden = true
                }
            }
        case "3":
            
            if comingFrom == "profile" {
                DispatchQueue.main.async {
                    self.markAsButton.isHidden = true
                }
            }
        case "4":
            
            if comingFrom == "profile" {
                DispatchQueue.main.async {
                    self.markAsButton.setTitle("Marcar como recibido", for: .normal)
                    self.idStatus = "5"

                }
            }
        case "5":
            
            if comingFrom == "profile" {
                DispatchQueue.main.async {
                    self.markAsButton.setTitle("Marcar como entregado", for: .normal)
                    self.idStatus = "6"
                }
            }
        default:
            DispatchQueue.main.async {
                self.markAsButton.alpha = 0.5
                self.markAsButton.isUserInteractionEnabled = false
                self.markAsButton.setTitle("Sin Opciones Disponibles", for: .normal)
            }
        }
    }
    
    func customizeMapView(){
        self.mapInformation.showsBuildings = true
        self.mapInformation.showsCompass = true
        self.mapInformation.showsPointsOfInterest = true
        self.mapInformation.showsUserLocation = true
        self.mapInformation.userTrackingMode = .none
        self.mapInformation.mapType = .standard
    }
    
    func centerMapOnLocation(location: CLLocation, latitude:Double, longtitude:Double, direccionPedido: String) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapInformation.setRegion(coordinateRegion, animated: true)
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        annotation.title = direccionPedido
        mapInformation.addAnnotation(annotation)
    }
    
    func getInfo() {
        let url = URL(string: HTTPManager.baseURL())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") // Headers
        request.httpMethod = "POST" // Metodo
        let postString = "funcion=getOrderDetail&id_user="+userID+"&id_order="+idOrder+"&type="+typeOfOrder
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
                        let menuName = info["nombre"] as? String
                        let anfitrion = info["anfitrion"] as? String
                        let total = info["total"] as? String
                        let latitud = info["latitud"] as? String
                        let longitud = info["longitud"] as? String
                        let initialLocation = CLLocation(latitude: Double(latitud ?? "0.0") ?? 0.0, longitude: Double(longitud ?? "0.0") ?? 0.0)
                        let DoubleLatitude = Double(latitud ?? "0.0")
                        let DoubleLongtitude = Double(longitud ?? "0.0")
                        let cantidad = info["cantidad"] as? String
                        let costo = info["sub_total"] as? String
                        let costoEnvio = info["costo_envio"] as? String
                        let estatus = info["estatus"] as? String
                        let direccionDeEntrega = info["direccion_cocinero_pedido"] as? String
                        self.buttonHandler(orderType: estatus ?? "Empty")
                        DispatchQueue.main.async {
                            self.menuName.setTitle(menuName, for: .normal)
                            self.offeredBy.setTitle( "Ofrecido por: \(anfitrion ?? "")", for: .normal)
                            self.totalInfo.text = total
                            self.centerMapOnLocation(location: initialLocation, latitude: DoubleLatitude ?? 0.0, longtitude: DoubleLongtitude ?? 0.0, direccionPedido: direccionDeEntrega ?? "")
                            self.quantityInfo.text = cantidad
                            self.costInfo.text = "$ \(costo ?? "")"
                            self.shippingCostInfo.text = "$ \(costoEnvio ?? "")"
                        }
                        
                    } else {
                        print("Error al actualizar la informacion.")
                    }
                    
                    if let extras = pedidos["extras"] as? [Dictionary<String, AnyObject>] {
                        for d in extras {
                            print(d)
                            self.platillos.append(d)
                        }
                    }
                } else {
                    print("error with info")
                    self.buttonHandler(orderType: "Empty")
                }
            }
            DispatchQueue.main.async {
                if self.platillos.count > 0 {
                    self.dishesTableView?.reloadData()
                    self.height.constant = self.dishesTableView.contentSize.height
                }
            }
        }.resume()
    }
    
    //MARK: Buttons
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeStatusButton(_ sender: Any) {
        if comingFrom == "main" {
            let alert = UIAlertController(title: "Confirmar", message: "¿De verdad quieres aceptar el pedido?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                self.acceptOrder()
            }))
            self.present(alert, animated: true)
        }
        
        if comingFrom == "profile" {
            let alert = UIAlertController(title: "Confirmar", message: "¿De verdad quieres actualizar el estatus de tu pedido?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { action in
                self.updateStatus()
            }))
         self.present(alert, animated: true)
        }
    }
    
    func acceptOrder() {
        let url = URL(string: HTTPManager.baseURL())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=acceptOrder&id_user="+userID+"&id_order="+idOrder
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
            if let parseJSON = json {
                let userUpdated = parseJSON["state"] as? String
                
                if userUpdated == "200" {
                    DispatchQueue.main.async {
                        print("Order Accepted")
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("orderAccepted"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    func updateStatus() {
        let url = URL(string: HTTPManager.baseURL())!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "funcion=updateStatusOrder&id_user="+userID+"&id_order="+idOrder+"&estatus="+idStatus
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            
            if let parseJSON = json {
                let userUpdated = parseJSON["state"] as? String
                
                if userUpdated == "200" {
                    DispatchQueue.main.async {
                        print("Order Accepted")
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name("orderUpdated"), object: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        task.resume()
    }
    
    
    @IBAction func acceptAndUpdateOrder(_ sender: Any) {
        //        let url = URL(string: "http://kocinaarte.com/administracion/webservice_repartidor/controller_last.php")!
        //        var request = URLRequest(url: url)
        //        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        //        request.httpMethod = "POST"
        //        let postString = ""
        //        request.httpBody = postString.data(using: .utf8)
        //        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        //            guard let data = data, error == nil else {
        //                return
        //            }
        //            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
        //
        //            if let parseJSON = json {
        //                let userUpdated = parseJSON["state"] as? String
        //
        //                if userUpdated == "200" {
        //                    DispatchQueue.main.async{
        //                        let alert = UIAlertController(title: "¡Éxito!", message: "¡Se han actualizado tus datos correctamente!", preferredStyle: .alert)
        //                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        //                        self.present(alert, animated: true)
        //                    }
        //                }
        //            }
        //        }
        //        task.resume()
    }
    
}

extension profileDeliveryDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        platillos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseDocument, for: indexPath) as? dishesTableViewCell else {
            return UITableViewCell()
        }
        let document = platillos[indexPath.row]
        let nombre = document["nombre"] as? String ?? ""
        let precioUnitario = document["precio_unitario"] as? String ?? ""
        let total = document["total"] as? String ?? ""
        let cantidad = document["cantidad"] as? String ?? ""
        cell.nombrePlatillo.text = "\(cantidad) \(nombre)"
        cell.precioDePlatillo.text = "$\(precioUnitario) = $\(total)"
        return cell
    }
    
}
