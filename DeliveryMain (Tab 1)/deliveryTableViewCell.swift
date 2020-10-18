//
//  deliveryTableViewCell.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit

class deliveryTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    static let cellidentifier = "activeOrdersTableViewCell"
    
    @IBOutlet weak var nombreOrden: UILabel!
    @IBOutlet weak var fechaOrden: UILabel!
    @IBOutlet weak var estatusOrden: UILabel!
    @IBOutlet weak var costoOrden: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
