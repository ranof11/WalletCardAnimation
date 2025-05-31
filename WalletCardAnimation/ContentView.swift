//
//  ContentView.swift
//  WalletCardAnimation
//
//  Created by Rajesh Triadi Noftarizal on 25/05/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            Home(size: size, safeArea: safeArea)
                .ignoresSafeArea(.container, edges: .top)
        }
    }
}

#Preview {
    ContentView()
}
