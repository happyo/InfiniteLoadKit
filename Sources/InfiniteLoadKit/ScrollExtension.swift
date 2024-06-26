//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

extension ScrollView {
    public func enableInfiniteLoading(_ enable: Bool = true) -> some View {
        modifier(InfiniteLoadModifier(enable: enable))
    }
}
