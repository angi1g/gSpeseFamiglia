//
//  Spesa.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 18/02/25.
//

import Foundation
import FirebaseAuth

struct Spesa: Identifiable, Codable {
    var id = UUID()
    var euro: Double
    var nota: String
    var categoria: String
    var addedBy = Auth.auth().currentUser?.email ?? ""
    var addedOn = Date()
}
