//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

public struct InfiniteFooter<Label, NoMoreLabel>: View where Label : View, NoMoreLabel: View {
    let action: () -> Void
    let label: () -> Label
    let noMoreLabel: () -> NoMoreLabel
    @Binding var isLoading: Bool
    @Environment(\.infiniteFooterUpdate) var update
    private var preloadOffset: CGFloat = 0
    private var noMore: Bool = false
    
    public init(isLoading: Binding<Bool>, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label, @ViewBuilder noMoreLabel: @escaping () -> NoMoreLabel) {
        self.action = action
        self.label = label
        self.noMoreLabel = noMoreLabel
        self._isLoading = isLoading
    }
    
    public var body: some View {
        VStack {
            if isLoading {
                label()
            } else if noMore {
                noMoreLabel()
            } else {
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .anchorPreference(key: InfiniteFooterAnchorKey.self, value: .bounds, transform: { anchor in
            [.init(bounds: anchor, preloadOffset: preloadOffset, isLoading: isLoading)]
        })
        .onChange(of: update) { _ in
            if update.shouldLoading, !isLoading, !noMore, InfiniteHelper.shared.canTriggerRefresh(lastTriggerDate: update.lastTriggerDate) {
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
