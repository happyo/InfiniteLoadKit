//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteHeaderAnchorKey: PreferenceKey {
    static var defaultValue: [Item] = []

    struct Item: Equatable {
        let preloadOffset: CGFloat
        let bounds: Anchor<CGRect>
        let isLoading: Bool
    }

    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        let nextItems = nextValue()
        value = nextItems
    }
}

struct InfiniteHeaderUpdateKey: EnvironmentKey {
    static var defaultValue: InfiniteHeaderUpdateValueModel = .init(enable: true)
}

extension EnvironmentValues {
    var infiniteHeaderUpdate: InfiniteHeaderUpdateValueModel {
        get { self[InfiniteHeaderUpdateKey.self] }
        set { self[InfiniteHeaderUpdateKey.self] = newValue }
    }
}

public struct InfiniteHeaderUpdateValueModel: Equatable {
    let enable: Bool
    var shouldLoading: Bool = false
    var changeTrigger: Int = 0
}
