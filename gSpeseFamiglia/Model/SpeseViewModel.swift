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
    
    @Published var userMonthlyTotals: [String: [String: Double]] = [:]
    @Published var userQuarterlyTotals: [String: [String: Double]] = [:]
    @Published var userYearlyTotals: [String: [String: Double]] = [:]
    @Published var categoryTotals: [String: Double] = [:] // Totale per categoria
    @Published var categoryUserTotals: [String: [String: Double]] = [:] // Totale per categoria suddiviso per utente
    
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
        
        var userMonthlySums: [String: [String: Double]] = [:]
        var userQuarterlySums: [String: [String: Double]] = [:]
        var userYearlySums: [String: [String: Double]] = [:]
        
        var categorySums: [String: Double] = [:]
        var categoryUserSums: [String: [String: Double]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        
        for expense in spese {
            let userId = expense.addedBy

            let monthKey = dateFormatter.string(from: expense.addedOn)
            let yearKey = "\(Calendar.current.component(.year, from: expense.addedOn))"
            let quarter = (Calendar.current.component(.month, from: expense.addedOn) - 1) / 3 + 1
            let quarterKey = "\(yearKey)-Q\(quarter)"
            
            monthlySums[monthKey, default: 0] += expense.euro
            quarterlySums[quarterKey, default: 0] += expense.euro
            yearlySums["\(yearKey)", default: 0] += expense.euro
            
            /*
            userMonthlySums[userId, default: [:]][monthKey, default: 0] += expense.euro
            userQuarterlySums[userId, default: [:]][quarterKey, default: 0] += expense.euro
            userYearlySums[userId, default: [:]]["\(yearKey)", default: 0] += expense.euro
            */
            
            userMonthlySums[monthKey, default: [:]][userId, default: 0] += expense.euro
            userQuarterlySums[quarterKey, default: [:]][userId, default: 0] += expense.euro
            userYearlySums[yearKey, default: [:]][userId, default: 0] += expense.euro
            
            categorySums[expense.categoria, default: 0] += expense.euro
            categoryUserSums[expense.categoria, default: [:]][userId, default: 0] += expense.euro
        }
        
        self.monthlyTotals = monthlySums
        self.quarterlyTotals = quarterlySums
        self.yearlyTotals = yearlySums
        
        self.userMonthlyTotals = userMonthlySums
        self.userQuarterlyTotals = userQuarterlySums
        self.userYearlyTotals = userYearlySums
        
        self.categoryTotals = categorySums
            .sorted { $0.value > $1.value } // Ordina per importo decrescente
            .reduce(into: [:]) { $0[$1.key] = $1.value }
        
        self.categoryUserTotals = categoryUserSums.mapValues { userTotals in
            userTotals.sorted { $0.value > $1.value } // Ordina i totali degli utenti per categoria
                .reduce(into: [:]) { $0[$1.key] = $1.value }
        }
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
