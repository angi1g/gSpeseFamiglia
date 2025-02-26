//
//  SpeseViewModel.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 18/02/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class SpeseViewModel: ObservableObject {
    @Published var spese: [Spesa] = []
    @Published var totalePerUtente: [(userId: String, total: Double)] = [] // Totale per ogni utente ordinato
    
    @Published var monthlyTotals: [String: Double] = [:]
    @Published var quarterlyTotals: [String: Double] = [:]
    @Published var yearlyTotals: [String: Double] = [:]
    
    private var db = Firestore.firestore()
    
    init() {
        fetch()
        fetchTotalePerUtente()
    }
    
    func fetch() {
        db.collection("spese").order(by: "addedOn", descending: true).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.spese = documents.compactMap { queryDocumentSnapshot -> Spesa? in
                let data = queryDocumentSnapshot.data()
                //print(data)
                guard let id = data["id"] as? String,
                      let euro = data["euro"] as? Double,
                      let nota = data["nota"] as? String,
                      let categoria = data["categoria"] as? String,
                      let addedBy = data["addedBy"] as? String,
                      let addedOn = data["addedOn"] as? Timestamp else {
                    return nil
                }
                //print(euro)
                return Spesa(id: UUID(uuidString: id)!, euro: Double(euro), nota: nota, categoria: categoria, addedBy: addedBy, addedOn: addedOn.dateValue())
            }
            self.calculateAggregatedTotals()
        }
    }
    
    func calculateAggregatedTotals() {
        var monthlySums: [String: Double] = [:]
        var quarterlySums: [String: Double] = [:]
        var yearlySums: [String: Double] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        for expense in spese {
            let monthKey = dateFormatter.string(from: expense.addedOn)
            let yearKey = Calendar.current.component(.year, from: expense.addedOn)
            let quarter = (Calendar.current.component(.month, from: expense.addedOn) - 1) / 3 + 1
            let quarterKey = "\(yearKey)-Q\(quarter)"
            
            monthlySums[monthKey, default: 0] += expense.euro
            quarterlySums[quarterKey, default: 0] += expense.euro
            yearlySums["\(yearKey)", default: 0] += expense.euro
        }
        
        self.monthlyTotals = monthlySums
        self.quarterlyTotals = quarterlySums
        self.yearlyTotals = yearlySums
    }
    
    func fetchTotalePerUtente() {
        db.collection("spese").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            var userSums: [String: Double] = [:]
            for document in documents {
                let data = document.data()
                if let userId = data["addedBy"] as? String, let amount = data["euro"] as? Double {
                    userSums[userId, default: 0.0] += amount
                }
            }
            self.totalePerUtente = userSums.map { ($0.key, $0.value) }.sorted { $0.total > $1.total }
        }
    }
    
    func add(spesa: Spesa) {
        let data: [String: Any] = ["id": spesa.id.uuidString, "euro": spesa.euro, "nota": spesa.nota, "categoria": spesa.categoria, "addedBy": spesa.addedBy, "addedOn": Timestamp(date: spesa.addedOn)]
        db.collection("spese").addDocument(data: data)
    }
    
    func remove(at offsets: IndexSet) {
        for index in offsets {
            let spesa = spese[index]
            if spesa.addedBy != Auth.auth().currentUser!.email {
                print("l'utente non ha il permesso di eliminare questa spesa")
                return
            }
            db.collection("spese").whereField("id", isEqualTo: spesa.id.uuidString)
                .getDocuments { (querySnapshot, error) in
                    if let documents = querySnapshot?.documents {
                        for document in documents {
                            document.reference.delete()
                        }
                    }
                }
        }
    }
}
