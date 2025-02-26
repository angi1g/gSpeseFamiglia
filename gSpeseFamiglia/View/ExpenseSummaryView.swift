//
//  ExpenseSummaryView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 26/02/25.
//

import SwiftUI

struct ExpenseSummaryView: View {
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Totali Generali")) {
                    ForEach(viewModel.monthlyTotals.sorted(by: { $0.key > $1.key }), id: \ .key) { key, value in
                        Text("Mese \(key): €\(value, specifier: "%.2f")")
                    }
                    ForEach(viewModel.quarterlyTotals.sorted(by: { $0.key > $1.key }), id: \ .key) { key, value in
                        Text("Quadrimestre \(key): €\(value, specifier: "%.2f")")
                    }
                    ForEach(viewModel.yearlyTotals.sorted(by: { $0.key > $1.key }), id: \ .key) { key, value in
                        Text("Anno \(key): €\(value, specifier: "%.2f")")
                    }
                }
                
                Section(header: Text("Totali per Utente")) {
                    ForEach(viewModel.userMonthlyTotals.keys.sorted(), id: \ .self) { userId in
                        Text("Utente: \(userId)")
                        ForEach(viewModel.userMonthlyTotals[userId]!.sorted(by: { $0.key > $1.key }), id: \ .key) { key, value in
                            Text("Mese \(key): €\(value, specifier: "%.2f")")
                        }
                    }
                }
            }
        }
        .navigationTitle("Riepilogo Spese")
    }
}
