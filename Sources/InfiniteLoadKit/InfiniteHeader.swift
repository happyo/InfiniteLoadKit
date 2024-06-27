//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

public struct InfiniteHeader<Label>: View where Label : View {
    let action: () -> Void
    let label: () -> Label
    @Binding var isLoading: Bool
    @Environment(\.infiniteHeaderUpdate) var update
    private var preloadOffset: CGFloat = 0
    private var noMore: Bool = false

    public init(isLoading: Binding<Bool>, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
        self._isLoading = isLoading
    }
    
    public var body: some View {
        VStack {
            if isLoading {
                label()
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .anchorPreference(key: InfiniteHeaderAnchorKey.self, value: .bounds, transform: { anchor in
            [.init(preloadOffset: self.preloadOffset, bounds: anchor, isLoading: self.isLoading)]
        })
        .onChange(of: update) { _ in
            if update.shouldLoading, !isLoading {
                isLoading = true
                DispatchQueue.main.async {
                    self.action()
                }
            }
        }
    }
    
    public func noMore(_ noMore: Bool) -> Self {
        var view = self
        view.noMore = noMore
        return view
    }
    
    public func preload(offset: CGFloat) -> Self {
        var view = self
        view.preloadOffset = offset
        return view
    }
}
