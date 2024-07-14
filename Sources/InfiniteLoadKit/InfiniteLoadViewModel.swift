//
//  Created by happyo on 2024/07/14.
//

import SwiftUI

class InfiniteLoadViewModel: ObservableObject {
    let isEnable: Bool
    let minTriggerCount: Int

    @Published public var headerUpdate: InfiniteHeaderUpdateKey.Value
    @Published public var footerUpdate: InfiniteFooterUpdateKey.Value

    @Published private var isHeaderLoading: Bool = false
    @Published private var isFooterLoading: Bool = false

    @Published private var headerLoadAttempts = 5
    @Published private var footerLoadAttempts = 5

    init(enable: Bool, minTriggerCount: Int = 5) {
        self.isEnable = enable
        self.minTriggerCount = minTriggerCount
        self.headerUpdate = .init(enable: enable)
        self.footerUpdate = .init(enable: enable)
        self.headerLoadAttempts = minTriggerCount
        self.footerLoadAttempts = minTriggerCount
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
            update.changeTrigger += 1
            headerLoadAttempts = minTriggerCount
        } else {
            shouldLoading = bounds.minY >= -item.preloadOffset

            if shouldLoading {
                headerLoadAttempts += 1
                if headerLoadAttempts >= minTriggerCount {
                    update.changeTrigger += 1
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
                update.changeTrigger += 1
                footerLoadAttempts = 0
            }
        } else {
            footerLoadAttempts = minTriggerCount
        }

        update.shouldLoading = shouldLoading
        footerUpdate = update
    }
}
