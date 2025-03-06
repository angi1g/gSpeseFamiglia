//
//  PeriodExpenseDetailView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 05/03/25.
//

import SwiftUI

struct PeriodExpenseDetailView: View {
    var viewModel: SpeseViewModel
    var period: String
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Totali per Categoria")) {
                    ForEach(viewModel.periodCategoryTotals[period]?.sorted(by: { $0.value > $1.value }) ?? [], id: \.0) { key, value in
                        VStack(alignment: .leading) {
                            Text("\(key): € \(value, specifier: "%.2f")")
                            if let userTotals = viewModel.periodCategoryUserTotals[period]?[key] {
                                ForEach(userTotals.sorted(by: { $0.value > $1.value }), id: \.0) { userId, userValue in
                                    Text("  - \(userId): € \(userValue, specifier: "%.2f")")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Dettagli \(period)")
        /*
        List {
            if let categoryData = viewModel.periodCategoryUserTotals[period] {
                ForEach(categoryData.keys.sorted(), id: \ .self) { category in
                    Section(header: Text(category)) {
                        ForEach(categoryData[category]!.sorted(by: { $0.value > $1.value }), id: \ .key) { userId, amount in
                            Text("  - Utente \(userId): €\(amount, specifier: "%.2f")")
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("Dettagli \(period)")
         */
    }
}
