//
//  ContentView.swift
//  InfiniteLoadKitApp
//
//  Created by belyenochi on 2024/6/26.
//

import SwiftUI
import InfiniteLoadKit

struct ContentView: View {
    @State private var isAtTop = true
    @State private var isAtBottom = false
    @State private var headerLoading = false
    @State private var footerLoading = false

    var body: some View {
        ScrollView {
            VStack {
                InfiniteHeader(isLoading: $headerLoading) {
                    
                } label: { f in
                    ProgressView()
                }

                ForEach(0..<100) { index in
                    Text("Item \(index)")
                        .padding()
                }
                
                InfiniteFooter(isLoading: $footerLoading) {
                    
                } label: {
                    ProgressView()
                }

            }
        }
        .enableInfiniteLoading()
    }
}
