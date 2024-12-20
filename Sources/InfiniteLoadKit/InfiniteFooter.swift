//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

public struct InfiniteFooter<Label, NoMoreLabel>: View where Label: View, NoMoreLabel: View {
    let action: () -> Void
    let label: () -> Label
    let noMoreLabel: () -> NoMoreLabel
    @Binding var isLoading: Bool
    @Binding var noMore: Bool

    public init(
        isLoading: Binding<Bool>, noMoreNext: Binding<Bool>, action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder noMoreLabel: @escaping () -> NoMoreLabel
    ) {
        self.action = action
        self.label = label
        self.noMoreLabel = noMoreLabel
        self._isLoading = isLoading
        self._noMore = noMoreNext
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
                        .preference(key: InfiniteFooterAnchorKey.self, value: geo.frame(in: .named("InfiniteLoadSpace")).maxY)
                }
                .frame(height: 1)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            if !isLoading, !noMore {
                DispatchQueue.main.async {
                    self.isLoading = true
                    self.action()
                }
            }
        }
    }
}
