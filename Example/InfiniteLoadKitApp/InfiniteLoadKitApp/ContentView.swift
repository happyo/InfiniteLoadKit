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
    @State private var scrollPosition: Int? = nil
    @State private var noMorePre: Bool = false
    @State private var noMoreNext: Bool = false

    @State private var isLoadingData: Bool = false
    
    @State private var dataList: [Int] = Array(1...20)

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                VStack {
                    InfiniteHeader(isLoading: $headerLoading) {
                        loadPre()
                    } label: {
                        ProgressView().frame(height: 100)
                    } noMoreLabel: {
                        Text("NoMore").frame(height: 30)
                    }
                    .preload(offset: 100)
                    .noMore(noMorePre)

                    ForEach(dataList, id: \.self) { index in
                        Text("Item \(index)")
                            .padding()
                            .id(index)
                    }
                    
                    InfiniteFooter(isLoading: $footerLoading) {
                        loadMore()
                    } label: {
                        ProgressView().frame(height: 100)
                    } noMoreLabel: {
                        Text("NoMore").frame(height: 30)
                    }
                    .preload(offset: 100)
                    .noMore(noMoreNext)

                }
            }
            .enableInfiniteLoading()
            .onChange(of: dataList) { _, _ in
                if let position = self.scrollPosition {
                    DispatchQueue.main.async {
                        scrollView.scrollTo(position, anchor: .top)
                        self.scrollPosition = nil
                    }
                }
            }
            .onAppear {
                print("scroll on a")
            }
        }
    }
    
    private func loadPre() {
        if isLoadingData {
            return
        }
        print("pre action")

        isLoadingData = true
        let item = DispatchWorkItem {
            self.isLoadingData = false
            self.headerLoading = false
            
            if let f = self.dataList.first {
                if f < -100 {
                    noMorePre = true
                }
                scrollPosition = f
                let preList = Array(f-20..<f)
                self.dataList.insert(contentsOf: preList, at: 0)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: item)
    }
    
    private func loadMore() {
        print("next action")
        let item = DispatchWorkItem {
            self.footerLoading = false
            
            if let last = self.dataList.last {
                if last >= 100 {
                    noMoreNext = true
                }
                scrollPosition = nil
                let nextList = Array(last+1...last+20)
                self.dataList.append(contentsOf: nextList)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: item)
    }
}
