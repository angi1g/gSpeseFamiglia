//
//  ContentView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 18/02/25.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var speseVM = SpeseViewModel()
    @State private var showingAddExpense = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                List(speseVM.totalePerUtente, id: \ .userId) { userTotal in
                    NavigationLink(destination: UserExpenseDetailView(userId: userTotal.userId, viewModel: speseVM)) {
                        HStack {
                            Text("\(userTotal.userId)")
                            Spacer()
                            Text("€ \(userTotal.total, specifier: "%.2f")")
                        }
                    }
                }
                .frame(maxHeight: 150)
                List {
                    ForEach(speseVM.spese) { spesa in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    if spesa.categoria != "" {
                                        Text("[\(spesa.categoria)]")
                                    }
                                    Text(spesa.nota)
                                }
                                    .font(.headline)
                                HStack {
                                    Text(spesa.addedOn.formatted(date: .numeric, time: .omitted))
                                    Text(spesa.addedBy)
                                }
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("€ \(spesa.euro, specifier: "%.2f")")
                                .font(.headline)
                        }
                    }
                    .onDelete(perform: speseVM.remove)
                }
            }
            .navigationTitle("Spese Famiglia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Esci") {
                        do {
                            try Auth.auth().signOut()
                            print("Signout Successfull!")
                            dismiss()
                        } catch {
                            print("Signout Error: \(error.localizedDescription)")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddExpense = true }) {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        SpeseAggregateView(viewModel: speseVM)
                        //ExpenseSummaryView(viewModel: speseVM)
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }

                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddSpesaView(speseVM: speseVM)
            }
        }
    }
}

#Preview {
    ContentView()
}
