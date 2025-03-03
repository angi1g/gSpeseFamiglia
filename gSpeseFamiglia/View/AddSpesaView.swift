//
//  AddSpesaView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 19/02/25.
//

import SwiftUI

struct AddSpesaView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var speseVM: SpeseViewModel
    @State private var note = ""
    @State private var euro = ""
    //@State private var categoria = ""
    @State private var categoria: Categoria = .altro
    @State private var date: Date = Date()
    /*
    let categorie = [
        "Abbigliamento", "Abitazione", "Alimentari", "Altro", "Intrattenimento", "Istruzione", "Regali", "Salute", "Sport", "Trasporti", "Vacanze"
    ]
    */
    var body: some View {
        NavigationView {
            Form {
                TextField("Euro", text: $euro)
                    .keyboardType(.decimalPad)
                TextField("Note", text: $note)
                //TextField("Categoria", text: $categoria)
                Picker("Categoria", selection: $categoria) {
                    ForEach(Categoria.allCases, id: \.self) { category in
                        Text(category.rawValue)
                    }
                }
                .pickerStyle(.wheel)
                DatePicker("Data", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Aggiungi Spesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Annulla") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salva") {
                        if let amountValue = Double(euro.replacingOccurrences(of: ",", with: ".")) {
                            let spesa = Spesa(euro: amountValue, nota: note.trimmingCharacters(in: .whitespacesAndNewlines), categoria: categoria.rawValue, addedOn: date)
                            speseVM.add(spesa: spesa)
                            dismiss()
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddSpesaView(speseVM: SpeseViewModel())
}
