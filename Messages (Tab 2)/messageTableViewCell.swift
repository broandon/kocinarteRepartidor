//
//  messageTableViewCell.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

import UIKit

class messageTableViewCell: UITableViewCell {

    //MARK: Outlets
    
    static let cellidentifier = "messageTableViewCell"
    
    @IBOutlet weak var messageBackground: UIView!
    @IBOutlet weak var tituloMensaje: UILabel!
    @IBOutlet weak var nombrePersona: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    
    //MARK: ViewDid
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackground.layer.cornerRadius = 14
    }
    
    //MARK: Funcs

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
