//
//  YearView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 04/03/25.
//

import SwiftUI

struct YearView: View {
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Totali per Anno")) {
                    ForEach(viewModel.yearlyTotals.sorted(by: { $0.key > $1.key }), id: \ .key) { key, value in
                        NavigationLink(destination: PeriodExpenseDetailView(viewModel: viewModel, period: key)) {
                            VStack(alignment: .leading) {
                                Text("\(key): € \(value, specifier: "%.2f")")
                                if let userTotals = viewModel.userYearlyTotals[key] {
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
        }
        .navigationTitle("Spese Annuali")
    }
}

#Preview {
    YearView(viewModel: SpeseViewModel())
}
