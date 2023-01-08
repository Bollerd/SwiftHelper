import SwiftUI

public extension View {
    func snapshot<T: ObservableObject>(environmentObject: T,backgroundColor: Color?, namedColor: String?) -> UIImage {
        let controller = UIHostingController(rootView: self.environmentObject(environmentObject))
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        if let colorName = namedColor {
            view?.backgroundColor = UIColor(named: colorName)
            
        }
        
        if let bgColor = backgroundColor {
            view?.backgroundColor = UIColor(bgColor)
        }
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func snapshot(backgroundColor: Color?, namedColor: String?) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        if let colorName = namedColor {
            view?.backgroundColor = UIColor(named: colorName)
            
        }
        
        if let bgColor = backgroundColor {
            view?.backgroundColor = UIColor(bgColor)
        }
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

