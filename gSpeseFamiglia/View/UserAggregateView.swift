//
//  UserAggregateView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 27/02/25.
//

import SwiftUI

struct UserAggregateView: View {
    var userId: String
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        VStack {
            Text("Totale spese per mese")
                .font(.headline)
            List((viewModel.userMonthlyTotals[userId]?.sorted { $0.key > $1.key }) ?? [], id: \ .key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text("€ \(value, specifier: "%.2f")")
                }
            }
            
            Text("Totale spese per quadrimestre")
                .font(.headline)
            List(viewModel.userQuarterlyTotals[userId]?.sorted { $0.key > $1.key } ?? [], id: \ .key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text("€ \(value, specifier: "%.2f")")
                }
            }
            
            Text("Totale spese per anno")
                .font(.headline)
            List(viewModel.userYearlyTotals[userId]?.sorted { $0.key > $1.key } ?? [], id: \ .key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text("€ \(value, specifier: "%.2f")")
                }
            }
        }
        .navigationTitle("Statistiche Spese")
    }
}

#Preview {
    UserAggregateView(userId: "angi1g@gmail.com", viewModel: SpeseViewModel())
}
