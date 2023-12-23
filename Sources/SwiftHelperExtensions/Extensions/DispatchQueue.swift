import SwiftUI

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> String?)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
}
