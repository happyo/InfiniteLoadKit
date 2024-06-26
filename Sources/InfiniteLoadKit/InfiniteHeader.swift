//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

public struct InfiniteHeader<Label>: View where Label : View {
    let action: () -> Void
    let label: (CGFloat) -> Label
    @Binding var isLoading: Bool
    @Environment(\.infiniteHeaderUpdate) var update

    public init(isLoading: Binding<Bool>, action: @escaping () -> Void, @ViewBuilder label: @escaping (CGFloat) -> Label) {
        self.action = action
        self.label = label
        self._isLoading = isLoading
    }
    
    public var body: some View {
        VStack {
            label(0)
        }
        .frame(maxWidth: .infinity)
        .anchorPreference(key: InfiniteHeaderAnchorKey.self, value: .bounds, transform: { anchor in
            [.init(bounds: anchor, refreshing: self.isLoading)]
        })
    }
}
