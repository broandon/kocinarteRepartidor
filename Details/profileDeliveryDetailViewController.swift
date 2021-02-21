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
    
    let userID = UserDefaults.standard.value(forKey: "UserID") as! String
    var idOrder: String = ""
    var typeOfOrder: String = ""
    @IBOutlet weak var menuName: UIButton!
    @IBOutlet weak var offeredBy: UIButton!
    @IBOutlet weak var dishesTableView: UITableView!
    @IBOutlet weak var mapInformation: MKMapView!
    @IBOutlet weak var quantityInfo: UILabel!
    @IBOutlet weak var costInfo: UILabel!
    @IBOutlet weak var shippingCostInfo: UILabel!
    @IBOutlet weak var totalInfo: UILabel!
    @IBOutlet weak var markAsButton: UIButton!
    
    //MARK: viewDid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeMapView()
        getInfo()
        setupView()
    }
    
    //MARK: Funcs
    
    func setupView() {
        markAsButton.layer.cornerRadius = 15
    }
    
    func buttonHandler(orderType: String) {
        switch orderType {
        case "Empty":
            DispatchQueue.main.async {
                print("The damn thing is empty")
                self.markAsButton.alpha = 0.5
                self.markAsButton.setTitle("Sin opciones disponibles.", for: .normal)
            }
        default:
            print("value is \(orderType)")
        }
    }
    
    func customizeMapView(){
        self.mapInformation.showsBuildings = true
        self.mapInformation.showsCompass = true
        self.mapInformation.showsPointsOfInterest = true
        self.mapInformation.showsUserLocation = false
        self.mapInformation.userTrackingMode = .none
        self.mapInformation.mapType = .standard
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapInformation.setRegion(coordinateRegion, animated: true)
    }
    
    func getInfo() {
        let url = URL(string: "http://kocinaarte.com/administracion/webservice_repartidor/controller_last.php")!
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
                        let cantidad = info["cantidad"] as? String
                        let costo = info["sub_total"] as? String
                        let costoEnvio = info["costo_envio"] as? String
                        let tipo = info["tipo"] as? String
                        self.buttonHandler(orderType: tipo ?? "Empty")
                        DispatchQueue.main.async {
                            self.menuName.setTitle(menuName, for: .normal)
                            self.offeredBy.setTitle( "Ofrecido por: \(anfitrion ?? "")", for: .normal)
                            self.totalInfo.text = total
                            self.centerMapOnLocation(location: initialLocation)
                            self.quantityInfo.text = cantidad
                            self.costInfo.text = "$ \(costo ?? "")"
                            self.shippingCostInfo.text = "$ \(costoEnvio ?? "")"
                        }
                        
                    } else {
                        print("Error al actualizar la informacion.")
                    }
                } else {
                    print("error with info")
                    self.buttonHandler(orderType: "Empty")
                }
            }
        }.resume()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
