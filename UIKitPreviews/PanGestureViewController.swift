//
//  PanGestureViewController.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/18/22.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class PanGestureViewController: UIViewController {
    
    var initialCenter = CGPoint(x: 100, y: 100)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let panView = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        panView.backgroundColor = .systemBlue
        view.addSubview(panView)
        
        panView.rx.panGesture()
            .subscribe(onNext: { pan in
                switch pan.state {
                case .began:
                    print("began")
                case .changed:
                    let translation = pan.translation(in: panView.superview)
                    panView.center = CGPoint(x: panView.center.x + translation.x, y: panView.center.y + translation.y)
                    self.initialCenter = panView.center
                    pan.setTranslation(.zero, in: panView.superview)
                default:
                    panView.center = self.initialCenter
                    print("ended or cancelled or failed")
                }
            } )
            .disposed(by: disposeBag)

        
    }
}

struct PanGestureViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            PanGestureViewController()
        }
        .previewDevice("iPhone 11")
    }
}
