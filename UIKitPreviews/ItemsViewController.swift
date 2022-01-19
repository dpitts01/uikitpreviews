//
//  ItemsViewController.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/18/22.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import RxDataSources

class ItemsViewController: UIViewController {
    
    var tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        bindTableView()
    }
    
    private func bindTableView() {
        let items = Observable.of(["item1", "item2", "item3"])
        
        items
            .bind(to: tableView.rx.items) {
                (tableView: UITableView, index: Int, element: String) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.textLabel?.text = element
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: { [weak self] model in
                let itemDetailVC = UIViewController()
                itemDetailVC.modalPresentationStyle = .pageSheet
                itemDetailVC.view.backgroundColor = .systemGray3.withAlphaComponent(0.95)
                itemDetailVC.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                itemDetailVC.view.layer.cornerRadius = 12
                
                let labelView = UILabel()
                labelView.translatesAutoresizingMaskIntoConstraints = false
                labelView.text = model.description
                itemDetailVC.view.addSubview(labelView)
                
                let closeButton = UIButton()
                closeButton.translatesAutoresizingMaskIntoConstraints = false
                closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
                itemDetailVC.view.addSubview(closeButton)
                                
                closeButton.rx.tap
                    .subscribe(onNext: {
                        itemDetailVC.dismiss(animated: true)
                    }) // not disposed properly
                
                NSLayoutConstraint.activate([
                    labelView.leadingAnchor.constraint(equalTo: itemDetailVC.view.leadingAnchor, constant: 16),
                    labelView.topAnchor.constraint(equalTo: itemDetailVC.view.topAnchor, constant: 16),
                    closeButton.trailingAnchor.constraint(equalTo: itemDetailVC.view.trailingAnchor, constant: -16),
                    closeButton.topAnchor.constraint(equalTo: itemDetailVC.view.topAnchor, constant: 16)
                ])
                
                self?.present(itemDetailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

struct ItemsViewController_Preview: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ItemsViewController()
        }
        .previewDevice("iPhone 11")
    }
    
}
