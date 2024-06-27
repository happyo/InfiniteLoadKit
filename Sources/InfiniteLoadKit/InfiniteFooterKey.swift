//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteFooterAnchorKey: PreferenceKey {
    static var defaultValue: [Item] = []
    
    struct Item:Equatable {
        let bounds: Anchor<CGRect>
        let preloadOffset: CGFloat
        let isLoading: Bool
    }

    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}

struct InfiniteFooterUpdateKey: EnvironmentKey {
    static var defaultValue: InfiniteFooterUpdateValueModel = .init(enable: true)
}

extension EnvironmentValues {
    var infiniteFooterUpdate: InfiniteFooterUpdateValueModel {
        get { self[InfiniteFooterUpdateKey.self] }
        set { self[InfiniteFooterUpdateKey.self] = newValue }
    }
}

public struct InfiniteFooterUpdateValueModel: Equatable {
    let enable: Bool
    var shouldLoading: Bool = false
    var lastTriggerDate: Date = Date.distantPast
}
