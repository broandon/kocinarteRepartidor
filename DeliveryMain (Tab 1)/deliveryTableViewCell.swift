//
//  deliveryTableViewCell.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit

protocol showOrderDetail {
    func showTheOrderDetail(idOrder:String, typeOfOrder:String)
}

class deliveryTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    static let cellidentifier = "activeOrdersTableViewCell"
    
    @IBOutlet weak var nombreOrden: UILabel!
    @IBOutlet weak var fechaOrden: UILabel!
    @IBOutlet weak var estatusOrden: UILabel!
    @IBOutlet weak var costoOrden: UILabel!
    @IBOutlet weak var showDetailsButton: UIButton!
    
    var delegate : showOrderDetail!
    var typeOfOrder: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func showTheDetail(_ sender: UIButton) {
        let orderID = "\(sender.tag)"
        self.delegate.showTheOrderDetail(idOrder: orderID, typeOfOrder: typeOfOrder)
    }
}
