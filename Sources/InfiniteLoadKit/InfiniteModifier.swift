//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteLoadModifier: ViewModifier {
    let isEnable: Bool
    let minTriggerInterval: TimeInterval

    @State private var id: Int = 0
    @State private var headerUpdate: InfiniteHeaderUpdateKey.Value
    @State private var footerUpdate: InfiniteFooterUpdateKey.Value
    
    @State private var isHeaderLoading: Bool = false
    @State private var isFooterLoading: Bool = false

    init(enable: Bool, minTriggerInterval: TimeInterval = 0.5) {
        self.isEnable = enable
        self.minTriggerInterval = minTriggerInterval
        self._headerUpdate = State(initialValue: .init(enable: enable))
        self._footerUpdate = State(initialValue: .init(enable: enable))

        InfiniteHelper.shared.minTriggerInterval = minTriggerInterval
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
                .id(self.id)
        }
    }

    func updateHeader(proxy: GeometryProxy, value: InfiniteHeaderAnchorKey.Value) {
        guard let item = value.first else { return }
        guard isEnable else { return }
        guard !isFooterLoading else { return }

        isHeaderLoading = item.isLoading
        
        guard !isHeaderLoading else { return }

        let bounds = proxy[item.bounds]
        
        var update = headerUpdate
        
        update.shouldLoading = bounds.minY >= -(item.preloadOffset + bounds.height)
        
        if update.shouldLoading == headerUpdate.shouldLoading {
            if InfiniteHelper.shared.canTriggerRefresh(lastTriggerDate: update.lastTriggerDate) {
                update.lastTriggerDate = Date()
                
                headerUpdate = update
            } else {
                return
            }
        } else {
            headerUpdate = update
        }
        
    }

    func updateFooter(proxy: GeometryProxy, value: InfiniteFooterAnchorKey.Value) {
        guard let item = value.first else { return }
        guard isEnable else { return }
        guard !isHeaderLoading else { return }
        
        isFooterLoading = item.isLoading

        guard !isFooterLoading else { return }

        let bounds = proxy[item.bounds]
        
        var update = footerUpdate
        
        update.shouldLoading = proxy.size.height - bounds.minY + item.preloadOffset > 0
        
        if update.shouldLoading == footerUpdate.shouldLoading {
            if InfiniteHelper.shared.canTriggerRefresh(lastTriggerDate: update.lastTriggerDate) {
                update.lastTriggerDate = Date()
                
                footerUpdate = update
            } else {
                return
            }
        } else {
            footerUpdate = update
        }
    }
    
}
