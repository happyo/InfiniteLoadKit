//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteLoadModifier: ViewModifier {
    let isEnable: Bool
    let minTriggerCount: Int

    @State private var headerUpdate: InfiniteHeaderUpdateKey.Value
    @State private var footerUpdate: InfiniteFooterUpdateKey.Value
    
    @State private var isHeaderLoading: Bool = false
    @State private var isFooterLoading: Bool = false

    @State private var headerLoadAttempts = 5
    @State private var footerLoadAttempts = 5

    init(enable: Bool, minTriggerCount: Int = 5) {
        self.isEnable = enable
        self.minTriggerCount = minTriggerCount
        self._headerUpdate = State(initialValue: .init(enable: enable))
        self._footerUpdate = State(initialValue: .init(enable: enable))
        self._headerLoadAttempts = State(initialValue: minTriggerCount)
        self._footerLoadAttempts = State(initialValue: minTriggerCount)
    }

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .environment(\.infiniteHeaderUpdate, headerUpdate)
                .environment(\.infiniteFooterUpdate, footerUpdate)
                .onPreferenceChange(InfiniteHeaderAnchorKey.self, perform: { value in
                    self.updateHeader(proxy: proxy, value: value)
                })
                .onPreferenceChange(InfiniteFooterAnchorKey.self, perform: { value in
                    self.updateFooter(proxy: proxy, value: value)
                })
        }
    }

    func updateHeader(proxy: GeometryProxy, value: InfiniteHeaderAnchorKey.Value) {
        guard let item = value.first else { return }
        guard isEnable else { return }
        guard !isFooterLoading else { return }

        isHeaderLoading = item.isLoading
        
        guard !isHeaderLoading else { return }

        var update = headerUpdate

        let bounds = proxy[item.bounds]
       
        let minY = bounds.minY
        
        var shouldLoading = true
        
        print(minY)
        
        if minY > 0 {
            shouldLoading = false
            headerLoadAttempts = minTriggerCount
        } else {
            shouldLoading = bounds.minY >= -item.preloadOffset
            
            if shouldLoading {
                headerLoadAttempts += 1
                if headerLoadAttempts >= minTriggerCount {
                    shouldLoading = false
                    headerLoadAttempts = 0
                }
            } else {
                headerLoadAttempts = minTriggerCount
            }
        }
        
        update.shouldLoading = shouldLoading
        headerUpdate = update
    }

    func updateFooter(proxy: GeometryProxy, value: InfiniteFooterAnchorKey.Value) {
        guard let item = value.first else { return }
        guard isEnable else { return }
        guard !isHeaderLoading else { return }
        
        isFooterLoading = item.isLoading

        guard !isFooterLoading else { return }

        let bounds = proxy[item.bounds]
        
        var update = footerUpdate
        
        var shouldLoading = proxy.size.height - bounds.minY + item.preloadOffset > 0
        
        if shouldLoading {
            footerLoadAttempts += 1
            if footerLoadAttempts > minTriggerCount {
                shouldLoading = false
                footerLoadAttempts = 0
            } else {
                shouldLoading = true
            }
        } else {
            footerLoadAttempts = minTriggerCount
        }
        
        update.shouldLoading = shouldLoading
        footerUpdate = update
    }
    
}
