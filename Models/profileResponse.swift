//
//  profileResponse.swift
//  kocinarteRepartidor
//
//  Created by Brandon Gonzalez on 17/10/20.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let profileSCRProfileResponse = try? newJSONDecoder().decode(profileSCRProfileResponse.self, from: jsonData)

import Foundation

// MARK: - profileSCRProfileResponse
class profileSCRProfileResponse: Codable {
    let state, statusMsg: String?
    let data: profileSCRData?

    enum CodingKeys: String, CodingKey {
        case state
        case statusMsg = "status_msg"
        case data
    }

    init(state: String?, statusMsg: String?, data: profileSCRData?) {
        self.state = state
        self.statusMsg = statusMsg
        self.data = data
    }
}

// MARK: - profileSCRData
class profileSCRData: Codable {
    let info: profileSCRInfo?

    init(info: profileSCRInfo?) {
        self.info = info
    }
}

// MARK: - profileSCRInfo
class profileSCRInfo: Codable {
    let id, nombre, apellidos, telefono: String?
    let imagen: String?

    init(id: String?, nombre: String?, apellidos: String?, telefono: String?, imagen: String?) {
        self.id = id
        self.nombre = nombre
        self.apellidos = apellidos
        self.telefono = telefono
        self.imagen = imagen
    }
}
