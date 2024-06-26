//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

public struct InfiniteFooter<Label>: View where Label : View {
    let action: () -> Void
    let label: () -> Label
    @Binding var isLoading: Bool
    @Environment(\.infiniteFooterUpdate) var update

    public init(isLoading: Binding<Bool>, action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
        self._isLoading = isLoading
    }
    
    public var body: some View {
        VStack {
            label()
        }
    }
}
