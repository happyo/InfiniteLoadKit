//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteLoadModifier: ViewModifier {
    let isEnable: Bool

    @State private var id: Int = 0
    @State private var headerUpdate: InfiniteHeaderUpdateKey.Value
    @State private var footerUpdate: InfiniteFooterUpdateKey.Value

    init(enable: Bool) {
        self.isEnable = enable
        self._headerUpdate = State(initialValue: InfiniteHeaderUpdateKey.defaultValue)
        self._footerUpdate = State(initialValue: InfiniteFooterUpdateKey.defaultValue)
    }

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .environment(\.infiniteHeaderUpdate, headerUpdate)
                .environment(\.infiniteFooterUpdate, footerUpdate)
                .backgroundPreferenceValue(InfiniteHeaderAnchorKey.self) { value in
                    Color.clear.onAppear {
                        self.updateHeader(proxy: proxy, value: value)
                    }
                }
                .backgroundPreferenceValue(InfiniteFooterAnchorKey.self) { value in
                    Color.clear.onAppear {
                        self.updateFooter(proxy: proxy, value: value)

                    }
                }
        }
    }

    func updateHeader(proxy: GeometryProxy, value: InfiniteHeaderAnchorKey.Value) {
        guard let item = value.first else { return }
        let bounds = proxy[item.bounds]

        print(bounds)
    }

    func updateFooter(proxy: GeometryProxy, value: InfiniteFooterAnchorKey.Value) {
        guard let item = value.first else { return }
        let bounds = proxy[item.bounds]

        print(bounds)
    }
}
