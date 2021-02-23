//
//  dishesTableViewCell.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 13/02/21.
//

import UIKit

class dishesTableViewCell: UITableViewCell {
    
    //MARK: Outlets
    
    @IBOutlet weak var nombrePlatillo: UILabel!
    @IBOutlet weak var precioDePlatillo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
