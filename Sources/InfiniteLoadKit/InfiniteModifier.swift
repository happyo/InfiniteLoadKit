//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

struct InfiniteLoadModifier: ViewModifier {
    @ObservedObject var viewModel: InfiniteLoadViewModel

    init(enable: Bool) {
        viewModel = InfiniteLoadViewModel(enable: enable)
    }

    func body(content: Content) -> some View {
        content
            .coordinateSpace(name: "InfiniteLoadSpace")
    }
}
