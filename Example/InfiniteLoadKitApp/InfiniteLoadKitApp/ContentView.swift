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
    @State private var scrollPosition: Int? = 10
    @State private var noMorePre: Bool = false
    @State private var noMoreNext: Bool = false

    @State private var isLoadingData: Bool = false
    
    @State private var dataList: [Int] = Array(1...20)

    var body: some View {
        ScrollView {
            LazyVStack {
                InfiniteHeader(isLoading: $headerLoading, noMorePre: $noMorePre) {
                    loadPre()
                } label: {
                    ProgressView().frame(height: 100)
                } noMoreLabel: {
                    Text("NoMore").frame(height: 30)
                }

                ForEach(dataList, id: \.self) { index in
                    Text("Item \(index)")
                        .padding()
                        .id(index)
                }

                InfiniteFooter(isLoading: $footerLoading, noMoreNext: $noMoreNext) {
                    loadMore()
                } label: {
                    ProgressView().frame(height: 100)
                } noMoreLabel: {
                    Text("NoMore").frame(height: 30)
                }
            }
            
        }
        .enableInfiniteLoading()
        .scrollPosition(id: $scrollPosition, anchor: .top)
    }
    
    private func loadPre() {
        if isLoadingData {
            return
        }
        print("pre action")

        isLoadingData = true
        let item = DispatchWorkItem {
            
            
            if let f = self.dataList.first {
                if f < -100 {
                    noMorePre = true
                }
                
                scrollPosition = f
                let preList = Array(f-20..<f)
                self.dataList.insert(contentsOf: preList, at: 0)
                
                self.isLoadingData = false
                self.headerLoading = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
    }
    
    private func loadMore() {
        print("next action")
        let item = DispatchWorkItem {
            self.footerLoading = false
            
            if let last = self.dataList.last {
                if last >= 100 {
                    noMoreNext = true
                }
                let nextList = Array(last+1...last+20)
                self.dataList.append(contentsOf: nextList)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: item)
    }
}
