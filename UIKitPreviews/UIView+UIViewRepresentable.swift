//
//  UIView+UIViewRepresentable.swift
//  UIKitPreviews
//
//  Created by Adam Herring on 1/20/22.
//

import SwiftUI
import UIKit

struct ViewPreview: UIViewRepresentable {
    let viewBuilder: () -> UIView
    
    init(_ viewBuilder: @escaping () -> UIView) {
        self.viewBuilder = viewBuilder
    }
    
    func makeUIView(context: Context) -> some UIView {
        return viewBuilder()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

//struct ViewPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewPreview {
//            ViewPreview()
//        }
//    }
//}
