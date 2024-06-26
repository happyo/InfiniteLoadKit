//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteHeaderAnchorKey: PreferenceKey {
    static var defaultValue: [Item] = []
    
    struct Item {
        let bounds: Anchor<CGRect>
        let refreshing: Bool
    }

    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}

struct InfiniteHeaderUpdateKey: EnvironmentKey {
    static var defaultValue: InfiniteHeaderUpdateValueModel = .init(enable: false)
}

extension EnvironmentValues {
    var infiniteHeaderUpdate: InfiniteHeaderUpdateValueModel {
        get { self[InfiniteHeaderUpdateKey.self] }
        set { self[InfiniteHeaderUpdateKey.self] = newValue }
    }
}

public struct InfiniteHeaderUpdateValueModel {
    let enable: Bool
    var progress: CGFloat = 0
    var refresh: Bool = false
}
