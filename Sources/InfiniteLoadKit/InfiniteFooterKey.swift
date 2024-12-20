//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteFooterAnchorKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct InfiniteFooterUpdateKey: EnvironmentKey {
    static var defaultValue: InfiniteFooterUpdateValueModel = .init(enable: true)
}

extension EnvironmentValues {
    var infiniteFooterUpdate: InfiniteFooterUpdateValueModel {
        get { self[InfiniteFooterUpdateKey.self] }
        set {
            self[InfiniteFooterUpdateKey.self] = newValue
        }
    }
}

public struct InfiniteFooterUpdateValueModel: Equatable {
    let enable: Bool
    var shouldLoading: Bool = false
    var changeTrigger: Int = 0
}
