//
//  ExpenseTabView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 03/03/25.
//

import SwiftUI

struct ExpenseTabView: View {
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        TabView {
            
            TimeTabView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendario")
                }
            
            CategoryView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Categorie")
                }
        }
    }
}

#Preview {
    ExpenseTabView(viewModel: SpeseViewModel())
}
