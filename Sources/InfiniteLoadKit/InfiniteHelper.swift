//
//  Created by belyenochi on 2024/06/27.
//

import SwiftUI

class InfiniteHelper {
    var minTriggerInterval: TimeInterval = 0.5

    public static let shared = InfiniteHelper()

    private init() {}
    
    func canTriggerRefresh(lastTriggerDate: Date) -> Bool {
        let interval = Date().timeIntervalSince(lastTriggerDate)
        
        return interval >= minTriggerInterval
    }
}
