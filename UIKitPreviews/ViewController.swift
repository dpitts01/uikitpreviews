//
//  ViewController.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/14/22.
//

import UIKit
import RxSwift
import RxCocoa

#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var vStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill // NOT fillProportionally or the text in the label gets clipped
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let button = UIButton()
    let secondButton = UIButton()
    let detailLabel = UILabel()
    var collapsed = false

    let image = UIImage(systemName: "heart.fill")
    let imageView = UIImageView()
    let heartOutline = UIImage(systemName: "heart")
    var filledIn = false
    
    var modalShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let placeholderView = UIView()
        placeholderView.backgroundColor = .systemGray5
        
        imageView.image = filledIn ? image : heartOutline
        imageView.tintColor = .systemRed
        
        let string = "Let's start givi'n"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemPurple,
            .font: UIFont.systemFont(ofSize: 44, weight: .heavy)
        ]
        
        let attributedText = NSAttributedString(string: string, attributes: attributes)
        
        let label = UILabel()
        label.numberOfLines = 2
        label.attributedText = attributedText
        
        detailLabel.numberOfLines = 0
        detailLabel.font = .preferredFont(forTextStyle: .body)
        detailLabel.adjustsFontForContentSizeCategory = true
        detailLabel.text = "The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs. The Givi mobile app is the one stop shop for all your giving & non-profit event needs."
        
        button.setTitle("Search Events", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        
        secondButton.setTitle("Option 2", for: .normal)
        secondButton.setTitleColor(.systemGreen, for: .normal)
        secondButton.layer.cornerRadius = 12
        secondButton.layer.borderColor = UIColor.systemGreen.cgColor
        secondButton.layer.borderWidth = 1
        
        vStackView.addArrangedSubview(placeholderView)
        vStackView.addArrangedSubview(imageView)
        vStackView.addArrangedSubview(label)
        vStackView.addArrangedSubview(detailLabel)
        vStackView.addArrangedSubview(button)
        vStackView.addArrangedSubview(secondButton)
        scrollView.addSubview(vStackView)
        view.addSubview(scrollView)
        
        
//        let modal = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let modal = UIView(frame: .zero)
        modal.backgroundColor = .systemPurple
        view.addSubview(modal)
        view.bringSubviewToFront(modal)
        
//        view.addSubview(shortModal)
//        view.bringSubviewToFront(shortModal)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
//            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
//            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor),
//            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            vStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            vStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            vStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            vStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),

            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.1),
            
            button.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            button.heightAnchor.constraint(equalToConstant: 44),
            
            secondButton.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            secondButton.heightAnchor.constraint(equalToConstant: 44),
                        
//            detailLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            placeholderView.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            placeholderView.heightAnchor.constraint(equalToConstant: 128),
            
//            shortModalTopConstraint,
//            shortModal.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            shortModal.widthAnchor.constraint(equalTo: view.widthAnchor),
//            shortModal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            shortModal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            shortModal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            shortModal.heightAnchor.constraint(equalToConstant: 100)
            
            modal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modal.heightAnchor.constraint(equalToConstant: 100),
            modal.topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bindView()
        
    }
    
    private func bindView() {
        let button = self.button
        
        let buttonTaps = button.rx.tap.asObservable()
        
        buttonTaps
            .bind(onNext: { self.loadNewVC() } )
            .disposed(by: disposeBag)
        
        let secondButton = self.secondButton
        
        let secondButtonTaps = secondButton.rx.tap.asObservable()
        
        secondButtonTaps
            .bind(onNext: { self.loadShortModal() } )
            .disposed(by: disposeBag)
        
    }
    
    private func changeColor() {
        button.backgroundColor = [.systemRed, .systemOrange, .systemBlue, .systemPurple, .systemGreen, .systemGray][Int.random(in: 0...5)]
        print("tapped")
    }
    
    private func loadNewVC() {
        let newVC = UIViewController()
        newVC.view.backgroundColor = .systemBlue
        newVC.modalPresentationStyle = .currentContext
        newVC.modalTransitionStyle = .flipHorizontal
        present(newVC, animated: true)
    }
    
    private func collapseText() {
        collapsed.toggle()
        detailLabel.numberOfLines = collapsed ? 4 : 0
    }
    
    private func unfillHeart() {
        filledIn.toggle()
        imageView.image = filledIn ? image : heartOutline
    }
    
    private func loadShortModal() {
        print("showing?")
    }

}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ViewController()
        }
        .previewDevice("iPhone 11")
    }
}

