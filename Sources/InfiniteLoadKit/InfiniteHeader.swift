//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

public struct InfiniteHeader<Label, NoMoreLabel>: View where Label: View, NoMoreLabel: View {
    let action: () -> Void
    let label: () -> Label
    let noMoreLabel: () -> NoMoreLabel
    @Binding var isLoading: Bool
    @Binding var noMore: Bool

    @Environment(\.infiniteHeaderUpdate) var update
    private var preloadOffset: CGFloat = 0

    public init(
        isLoading: Binding<Bool>, noMorePre: Binding<Bool>, action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder noMoreLabel: @escaping () -> NoMoreLabel
    ) {
        self.action = action
        self.label = label
        self.noMoreLabel = noMoreLabel
        self._isLoading = isLoading
        self._noMore = noMorePre
    }

    public var body: some View {
        VStack {
            if isLoading {
                label()
            } else if noMore {
                noMoreLabel()
            } else {
                GeometryReader { geo in
                    Color.clear
                        .preference(key: InfiniteHeaderAnchorKey.self, value: geo.frame(in: .named("InfiniteLoadSpace")).maxY)
                }
                .frame(height: 1)
            }
        }
        .onAppear {
            if !isLoading, !noMore {
                DispatchQueue.main.async {
                    self.isLoading = true
                    self.action()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
