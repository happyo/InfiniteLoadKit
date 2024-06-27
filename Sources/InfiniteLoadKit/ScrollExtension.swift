//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

extension ScrollView {
    public func enableInfiniteLoading(enable: Bool = true, minTriggerInterval: TimeInterval = 0.3) -> some View {
        modifier(InfiniteLoadModifier(enable: enable, minTriggerInterval: minTriggerInterval))
    }
}
