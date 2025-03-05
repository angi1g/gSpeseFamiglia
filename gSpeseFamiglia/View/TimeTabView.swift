//
//  TimeTabView.swift
//  gSpeseFamiglia
//
//  Created by Giacomo on 04/03/25.
//

import SwiftUI

struct TimeTabView: View {
    @ObservedObject var viewModel: SpeseViewModel
    
    var body: some View {
        TabView {
            MonthView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "m.circle")
                    Text("Mese")
                }
            
            QuarterView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "q.circle")
                    Text("Quadrimestre")
                        .font(.title)
                        .padding()
                }
            
            YearView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "a.circle")
                    Text("Anno")
                        .font(.title)
                        .padding()
                }
        }
    }
}

#Preview {
    TimeTabView(viewModel: SpeseViewModel())
}
