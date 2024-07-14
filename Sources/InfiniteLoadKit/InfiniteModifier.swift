//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteLoadModifier: ViewModifier {
    @ObservedObject var viewModel: InfiniteLoadViewModel

    init(enable: Bool, minTriggerCount: Int = 5) {
        viewModel = InfiniteLoadViewModel(enable: enable, minTriggerCount: minTriggerCount)
    }

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .environment(\.infiniteHeaderUpdate, viewModel.headerUpdate)
                .environment(\.infiniteFooterUpdate, viewModel.footerUpdate)
                .onPreferenceChange(
                    InfiniteHeaderAnchorKey.self,
                    perform: { value in
                        self.viewModel.updateHeader(proxy: proxy, value: value)
                    }
                )
                .onPreferenceChange(
                    InfiniteFooterAnchorKey.self,
                    perform: { value in
                        self.viewModel.updateFooter(proxy: proxy, value: value)
                    })
        }
    }

}
