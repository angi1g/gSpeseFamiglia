//
//  SpeseAggregateView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 25/02/25.
//

import SwiftUI

struct SpeseAggregateView: View {
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        VStack {
            Text("Totale spese per mese")
                .font(.headline)
            List(viewModel.monthlyTotals.sorted { $0.key > $1.key }, id: \ .key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text("€ \(value, specifier: "%.2f")")
                }
            }
            
            Text("Totale spese per quadrimestre")
                .font(.headline)
            List(viewModel.quarterlyTotals.sorted { $0.key > $1.key }, id: \ .key) { key, value in
                HStack {
                    Text(key)
                    Spacer()
                    Text("€ \(value, specifier: "%.2f")")
                }
            }
            
            Text("Totale spese per anno")
                .font(.headline)
            List(viewModel.yearlyTotals.sorted { $0.key > $1.key }, id: \ .key) { key, value in
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
    SpeseAggregateView(viewModel: SpeseViewModel())
}
