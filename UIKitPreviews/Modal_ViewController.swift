//
//  Modal+ViewController.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/17/22.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import RxGesture

class Modal_ViewController: UIViewController {
    
    let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        return button
    }()
        
    let popUpModal = UIView()
    var topAnchor = NSLayoutConstraint()
    var popUpPresented = false
    var initialCenterY = 0.0

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pop up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        setupPopUpVC()
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 128),
            button.heightAnchor.constraint(equalToConstant: 44),
//            topAnchor
        ])
        
        bindVC()
    }
    
    func setupPopUpVC() {
        self.view.addSubview(popUpModal)
        
        popUpModal.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        popUpModal.layer.cornerRadius = 12
        popUpModal.translatesAutoresizingMaskIntoConstraints = false
        popUpModal.backgroundColor = .systemYellow
        popUpModal.layer.shadowColor = UIColor(white: 0.25, alpha: 0.25).cgColor
        popUpModal.layer.shadowRadius = 15
        popUpModal.layer.shadowOpacity = 1
        
        popUpModal.rx.panGesture()
            .subscribe(onNext: { [weak self] pan in
                guard let self = self else { return }
                let translation = pan.translation(in: self.popUpModal.superview)

                switch pan.state {
                case .began:
                    self.initialCenterY = self.popUpModal.center.y
                case .changed:
                    let translation = pan.translation(in: self.popUpModal.superview)
                    self.popUpModal.center = CGPoint(x: self.popUpModal.center.x, y: self.popUpModal.center.y + translation.y)
                    self.initialCenterY = self.popUpModal.center.y
                    pan.setTranslation(.zero, in: self.popUpModal.superview)
                    
                case .ended:
                    // change to popUpModal states, add enum to VC or View
                    let finalY = self.popUpModal.center.y + translation.y
                    UIView.animate(withDuration: 0.3) {
                        if finalY < self.popUpModal.frame.height {
                            self.popUpModal.center.y = self.popUpModal.frame.height * 0.5 + 44
                        } else if finalY < self.popUpModal.frame.height * 1.5 - 128 {
                            self.popUpModal.center.y = self.popUpModal.frame.height * 1.5 - 128
                        } else {
                            self.popUpModal.center.y = self.popUpModal.frame.height * 1.5 - 44
                        }
                    }
                    
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        topAnchor = popUpModal.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -44)
        
        NSLayoutConstraint.activate([
            popUpModal.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            popUpModal.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            popUpModal.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            topAnchor
        ])
        
//        self.view.layoutIfNeeded()
        
        
        // animate motion here
    }
    
    private func bindVC() {
        let button = self.button
        
        let buttonTap = button.rx.tap.asObservable()
        
        buttonTap
            .map { _ in self.popUpPresented.toggle() }
            .bind(onNext: { _ in self.presentPopUp() } )
            .disposed(by: disposeBag)
                
    }
    
    private func presentPopUp() {
        topAnchor.constant = popUpPresented ? -128 : -44
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

struct Modal_ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            Modal_ViewController()
        }
        .previewDevice("iPhone 11")
    }
}
