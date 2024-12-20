//
//  Created by happyo on 2024/07/14.
//

import SwiftUI

class InfiniteLoadViewModel: ObservableObject {
    let isEnable: Bool
    
    @Published var headerUpdate: InfiniteHeaderUpdateValueModel
    @Published var footerUpdate: InfiniteFooterUpdateValueModel

    @Published private var isHeaderLoading: Bool = false
    @Published private var isFooterLoading: Bool = false

    init(enable: Bool) {
        self.isEnable = enable
        self.headerUpdate = InfiniteHeaderUpdateValueModel(enable: enable)
        self.footerUpdate = InfiniteFooterUpdateValueModel(enable: enable)
    }

//    func updateHeader(proxy: GeometryProxy, value: InfiniteHeaderAnchorKey.Value) {
//        guard let item = value.first else { return }
//        guard isEnable else { return }
//        guard !isFooterLoading else { return }
//
//        isHeaderLoading = item.isLoading
//
//        guard !isHeaderLoading else { return }
//    }
//
//    func updateFooter(proxy: GeometryProxy, value: InfiniteFooterAnchorKey.Value) {
//        guard let item = value.first else { return }
//        guard isEnable else { return }
//        guard !isHeaderLoading else { return }
//
//        isFooterLoading = item.isLoading
//
//        guard !isFooterLoading else { return }
//
//    }
}
