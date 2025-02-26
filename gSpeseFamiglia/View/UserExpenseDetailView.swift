//
//  UserExpenseDetailView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 26/02/25.
//

import SwiftUI

struct UserExpenseDetailView: View {
    var userId: String
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        List {
            Section(header: Text("Spese Mensili")) {
                ForEach(viewModel.userMonthlyTotals[userId]?.sorted(by: { $0.key > $1.key }) ?? [], id: \ .key) { key, value in
                    Text("Mese \(key): €\(value, specifier: "%.2f")")
                }
            }
            Section(header: Text("Spese per Quadrimestre")) {
                ForEach(viewModel.userQuarterlyTotals[userId]?.sorted(by: { $0.key > $1.key }) ?? [], id: \ .key) { key, value in
                    Text("Quadrimestre \(key): €\(value, specifier: "%.2f")")
                }
            }
            Section(header: Text("Spese Annuali")) {
                ForEach(viewModel.userYearlyTotals[userId]?.sorted(by: { $0.key > $1.key }) ?? [], id: \ .key) { key, value in
                    Text("Anno \(key): €\(value, specifier: "%.2f")")
                }
            }
        }
        .navigationTitle("Dettagli Spese Utente")
    }
}
