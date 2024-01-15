import SwiftUI

public protocol iCloudFileHelperModel: ObservableObject {
     var fileName: String {get set}
     var fileContent: String {get set}
}

public extension DispatchQueue {
    static func background<T>(delay: Double = 0.0, data: T, background: (()->Void)? = nil, completion: (() -> Void?)? = nil) where T: iCloudFileHelperModel {
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
