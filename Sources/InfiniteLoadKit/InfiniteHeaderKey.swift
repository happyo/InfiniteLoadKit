//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteHeaderAnchorKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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
}
