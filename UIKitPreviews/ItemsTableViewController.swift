//
//  ItemsTableViewController.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/19/22.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class ItemsTableViewController: UIViewController {
    
    var categoryView = UIStackView()
    var tableView = UITableView()
    
    let disposeBag = DisposeBag()
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<DemoItemSection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCategoryView()
        setupTableView()
        createDataSource()
        

    }
    
    private func setupCategoryView() {
        view.addSubview(categoryView)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.backgroundColor = .systemGray
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: view.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 128)
        ])
        
        let categoryButtons: [CategoryButton] = DemoItemCategory.allCases.map { category in
            let button = CategoryButton(category: category)
            button.frame = CGRect(x: 0, y: 0, width: 128, height: 44)
            button.setTitle(category.rawValue, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 12
            button.layer.borderColor = UIColor.systemGray2.cgColor
            button.layer.borderWidth = 2
            return button
        }
        
        categoryButtons.map {
            categoryView.addArrangedSubview($0)
        }
        
        categoryView.spacing = 12
        categoryView.axis = .horizontal
        categoryView.distribution = .fillEqually
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.backgroundColor = .systemBlue
        
//        tableView.setEditing(true, animated: true)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: categoryView.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createDataSource() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<DemoItemSection>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .top,
                reloadAnimation: .fade,
                deleteAnimation: .left),
            configureCell: { dataSource, tableView, _, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "ItemCell")
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.category.rawValue
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].title
            },
            canEditRowAtIndexPath: { dataSource, index in
                return true
            },
            canMoveRowAtIndexPath: { dataSource, index in
                return true
            }
        )
        
        self.dataSource = dataSource
        
        let sections = [
            DemoItemSection(identity: 0, title: DemoItemCategory.forSale.rawValue, items: DemoItem.demoItems.filter { $0.category == DemoItemCategory.forSale }),
            DemoItemSection(identity: 0, title: DemoItemCategory.auction.rawValue, items: DemoItem.demoItems.filter { $0.category == DemoItemCategory.auction }),
            DemoItemSection(identity: 0, title: DemoItemCategory.food.rawValue, items: DemoItem.demoItems.filter { $0.category == DemoItemCategory.food })
        ]
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
//        tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
    }


}
//
//extension ItemsTableViewController: UITableViewDelegate {
//
//}

class CategoryButton: UIButton {
    let category: DemoItemCategory
    
    init(category: DemoItemCategory) {
        self.category = category
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct ItemsTableViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            ItemsTableViewController()
        }
        .previewDevice("iPhone 11")
    }
}
