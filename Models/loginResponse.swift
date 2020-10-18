//
//  loginResponse.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 16/10/20.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let octSCRLoginResponse = try? newJSONDecoder().decode(octSCRLoginResponse.self, from: jsonData)

import Foundation

// MARK: - octSCRLoginResponse
class octSCRLoginResponse: Codable {
    let state, statusMsg: String?
    let data: octSCRData?

    enum CodingKeys: String, CodingKey {
        case state
        case statusMsg = "status_msg"
        case data
    }

    init(state: String?, statusMsg: String?, data: octSCRData?) {
        self.state = state
        self.statusMsg = statusMsg
        self.data = data
    }
}

// MARK: - octSCRData
class octSCRData: Codable {
    let idUser, firstName, lastName, email: String?
    let tipo: Int?

    enum CodingKeys: String, CodingKey {
        case idUser = "id_user"
        case firstName = "first_name"
        case lastName = "last_name"
        case email, tipo
    }

    init(idUser: String?, firstName: String?, lastName: String?, email: String?, tipo: Int?) {
        self.idUser = idUser
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.tipo = tipo
    }
}
