//
//  CategoryView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 03/03/25.
//
//  NON UTILIZZATA

import SwiftUI

struct CategoryView: View {
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Totali per Categoria")) {
                    ForEach(viewModel.categoryTotals.sorted(by: { $0.value > $1.value }), id: \ .key) { key, value in
                        VStack(alignment: .leading) {
                            Text("\(key): € \(value, specifier: "%.2f")")
                            if let userTotals = viewModel.categoryUserTotals[key] {
                                ForEach(userTotals.sorted(by: { $0.value > $1.value }), id: \ .key) { userId, userValue in
                                    Text("  - \(userId): € \(userValue, specifier: "%.2f")")
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Riepilogo Spese")
    }
}

