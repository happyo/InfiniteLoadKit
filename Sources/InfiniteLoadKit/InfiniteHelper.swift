//
//  Created by belyenochi on 2024/06/27.
//

import SwiftUI

class InfiniteHelper {
    static func canTriggerRefresh(lastTriggerDate: Date, minTriggerInterval: TimeInterval) -> Bool {
        let interval = Date().timeIntervalSince(lastTriggerDate)
        
        return interval >= minTriggerInterval
    }
}
