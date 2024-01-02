import SwiftUI

protocol iCloudFileHelperModel: ObservableObject {
     var fileName: String {get set}
     var fileContent: String {get set}
}

class Model: ExtensionModel {
    @Published var s = "start"
    @Published var i = 0
}

extension DispatchQueue {
    static func background<T>(delay: Double = 0.0, data: T, background: (()->Void)? = nil, completion: (() -> String?)? = nil) where T: ExtensionModel {
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
