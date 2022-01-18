//
//  ViewController+UIViewControllerRepresentable.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/17/22.
//

import UIKit
import SwiftUI

struct ViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController
    
    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

//struct ViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview {
//            ViewController()
//        }
//        .previewDevice("iPhone 11")
//    }
//}
