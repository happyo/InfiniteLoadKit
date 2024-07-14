//
//  Created by belyenochi on 2024/06/26.
//

import SwiftUI

extension ScrollView {
    public func enableInfiniteLoading(enable: Bool = true, minTriggerCount: Int = 5) -> some View {
        modifier(InfiniteLoadModifier(enable: enable, minTriggerCount: minTriggerCount))
    }
}
