//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteFooterAnchorKey: PreferenceKey {
    static var defaultValue: [Item] = []
    
    struct Item {
        let bounds: Anchor<CGRect>
        let preloadOffset: CGFloat
        let refreshing: Bool
    }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.append(contentsOf: nextValue())
    }
}

struct InfiniteFooterUpdateKey: EnvironmentKey {
    static var defaultValue: InfiniteFooterUpdateValueModel = .init(enable: false)
}

extension EnvironmentValues {
    var infiniteFooterUpdate: InfiniteFooterUpdateValueModel {
        get { self[InfiniteFooterUpdateKey.self] }
        set { self[InfiniteFooterUpdateKey.self] = newValue }
    }
}

public struct InfiniteFooterUpdateValueModel {
    let enable: Bool
    var refresh: Bool = false
}
