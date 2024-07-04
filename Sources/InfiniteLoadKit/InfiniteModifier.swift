//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteLoadModifier: ViewModifier {
    let isEnable: Bool
    let minTriggerInterval: TimeInterval

    @State private var headerUpdate: InfiniteHeaderUpdateKey.Value
    @State private var footerUpdate: InfiniteFooterUpdateKey.Value
    
    @State private var isHeaderLoading: Bool = false
    @State private var isFooterLoading: Bool = false

    @State private var loadAttempts = 0 // 添加加载尝试次数计数器

    init(enable: Bool, minTriggerInterval: TimeInterval = 0.3) {
        self.isEnable = enable
        self.minTriggerInterval = minTriggerInterval
        self._headerUpdate = State(initialValue: .init(enable: enable))
        self._footerUpdate = State(initialValue: .init(enable: enable))
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
            loadAttempts = 10
        } else {
            shouldLoading = bounds.minY >= -item.preloadOffset
            
            if shouldLoading {
                loadAttempts += 1
                if loadAttempts > 9 {
                    shouldLoading = false
                    loadAttempts = 0
                }
            } else {
                loadAttempts = 10
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
        
        let shouldLoading = proxy.size.height - bounds.minY + item.preloadOffset > 0
        
        update.shouldLoading = shouldLoading
        footerUpdate = update
    }
    
}
