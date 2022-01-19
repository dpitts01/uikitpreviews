//
//  ViewController.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/14/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

#if canImport(SwiftUI) && DEBUG
import SwiftUI
#endif

class ViewController: UIViewController {
    
    // ----------------------------------------
    // MARK: Types
    // ----------------------------------------
    
    /**
     Any subtypes that you need to add to the ViewController should go here. Sometimes making Enums for different pieces of state is useful.
     For `modals`, they would be state-driven, .expanded/.collapsed type, included here.
     */
    
    // ----------------------------------------
    // MARK: View Model
    // ----------------------------------------
    
    /**
     The `viewModelFactory` property will be set by the Flow that creates this group and used
     to create the ViewModel. All of the configuration and dependency injection happens in the
     implementation of this closure.
     */
    //    var viewModelFactory: (EmptyView().UIInputs) -> EmptyView = { _ in fatalError("Must provide factory function first.") }
    
    // ----------------------------------------
    // MARK: UI Elements
    // ----------------------------------------
    
    /**
     Any UI elements that are created in code should be placed here. Usually these
     are UIBarButtonItems, but can be anything you need.
     Yep, this is good. If we use certain elements a lot, we can just instance them, too, and split them off SwiftUI style.
     */
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let vStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill // NOT fillProportionally or the text in the label gets clipped
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let placeholderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.tintColor = .systemRed
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        let string = "Let's start givi'n"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemPurple,
            .font: UIFont.systemFont(ofSize: 44, weight: .heavy)
        ]
        let attributedText = NSAttributedString(string: string, attributes: attributes)
        label.numberOfLines = 2
        label.attributedText = attributedText
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.text = "The Givi mobile app is the one stop shop for all your giving."
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Search Events", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let secondButton: UIButton = {
        let button = UIButton()
        button.setTitle("Option 2", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let modal: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .systemPurple
        return view
    }()
    
    // ----------------------------------------
    // MARK: Outlets
    // ----------------------------------------
    
    /**
     All of your IBOutlets will go here.
     Won't have a lot if not doing a lot of IB
     */
    
    //    @IBOutlet weak var tableView: UITableView!
    
    // ----------------------------------------
    // MARK: Properties
    // ----------------------------------------
    
    /// Tracks all disposables created in the ViewController
    let disposeBag = DisposeBag()
    
    /// Conformance to the stepper protocol, this will get the steps emitted from the ViewModel to the Flow
    //    let steps = PublishRelay<Step>()
    
    /// The ViewModel. We need to keep a reference to this to keep it from being deallocated. It's implicitly
    /// unwrapped here but for safety it can be an optional.
    //    var viewModel: ExampleViewModel!
    
    /// Any other properties go here
    var modalShowing = false
    var collapsed = false
    
    /// A UIRefreshControl used for the pull to refresh functionality of a UITableView
    //    private let refreshControl = UIRefreshControl()
    
    // ----------------------------------------
    // MARK: View Life Cycle
    // ----------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindView()
        setupView()
        
    }
    
    /**
     All of the one time setup code should be added here. Things like registering
     UITableViewCells, view configuration, etc.
     */
    private func setupView() {
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(vStackView)
        NSLayoutConstraint.activate([
        vStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
        vStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
        vStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
        vStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        vStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
        
        
        vStackView.addArrangedSubview(placeholderView)
        NSLayoutConstraint.activate([
            placeholderView.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            placeholderView.heightAnchor.constraint(equalToConstant: 128)
        ])
        
        vStackView.addArrangedSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 64),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.1)
        ])
        
        vStackView.addArrangedSubview(titleLabel)
        
        vStackView.addArrangedSubview(detailLabel)
        
        vStackView.addArrangedSubview(searchButton)
        NSLayoutConstraint.activate([
            searchButton.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            searchButton.heightAnchor.constraint(equalToConstant: 44)
        ])
       
        vStackView.addArrangedSubview(secondButton)
        NSLayoutConstraint.activate([
            secondButton.widthAnchor.constraint(equalTo: vStackView.widthAnchor),
            secondButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        view.addSubview(modal)
        view.bringSubviewToFront(modal)
        NSLayoutConstraint.activate([
            modal.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modal.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modal.heightAnchor.constraint(equalToConstant: 100),
            modal.topAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        /// This is how you register a UITableViewCell to be used with the UITableView.
        /// Note that the reuseIdentifier for the cell needs to be the name of the
        /// subclass. This is done automatically for you if you don't put anything.
        //        tableView.register(ExampleTableViewCell.self)
        
        /// This is a commonly used extension method that hides extra cells, to see
        /// more functionality available to you look at `QgivKit/Extensions/UITableView`
        //        tableView.hideEmptyCells()
        //        tableView.refreshControl = refreshControl
        
        /// This sets the UITableView delegate through RxSwift rather than the way you
        /// may be used to. It is important to use this syntax when setting the delegate.
        //        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        /// This is where navigation items get set.
        //        navigationItem.leftBarButtonItem = someButton
        
        /// This is a very common convenience method that adds a toolbar and done button
        /// to UITextFields and UISearchBars. This is used on almost every text input.
        //        searchBar.addDoneButton(disposedBy: disposeBag)
    }
    
    /**
     This is where the ViewModel gets connected to the ViewController and where
     the majority of things actually happen.
     
     This function creates the ViewModel using the `viewModelFactory` closure then
     binds all of the UIOutputs to view elements like UILabels and UITableViews.
     */
    private func bindView() {
        
        // ----------------------------------------
        // MARK: Local Properties
        // ----------------------------------------
        
        /**
         For lifecycle purposes you NEVER want to reference a property using `self` inside
         a closure. It will retain the property and create a reference cycle which causes the
         ViewController to not deallocate when necessary. To get around this you should create
         a local property and assign the value then you can refer to this local property inside
         the closure without causing problems.
         */
        
        
        // ----------------------------------------
        // MARK: View Model
        // ----------------------------------------
        
        /// Make any complex input sequences you need here.
        
        /// This is an example of getting an attendee from a UITableViewCell being tapped. Note
        /// that this is dependent on how the Section model is set up.
        //        let attendeeSelected = tableView
        //            .rx.modelSelected(AttendeeSectionItem.self)
        //            .deselectCurrentlySelectedCell(on: tableView)
        //            .map { selectedModel -> Attendee? in
        //                switch selectedModel {
        //                case .attendee(let attendee, _, _):
        //                    return attendee
        //                }
        //            }.filterNil()
        
        /// The inputs for the ViewModel
        //        let inputs = ExampleViewModel.UIInputs(
        //            searchText: .empty(),
        //            refresh: .empty(),
        //            submit: .empty()
        //
        //        )
        
        /// Create and set the viewModel property
        //        self.viewModel = viewModelFactory(inputs)
        
        // ----------------------------------------
        // MARK: Network Activity
        // ----------------------------------------
        
        /// This utilizes the `NetworkActivityIndicatable` protocol conformance to
        /// add a `UIActivityIndicator` to the view when the ViewModel is busy. This
        /// is a very common pattern you'll see a lot.
        //        viewModel
        //            .networkIsActive
        //            .drive(rx.networkIsActive)
        //            .disposed(by: disposeBag)
        
        /**
         Here is where all of the UI bindings will happen. I like to separate them out into
         groups using MARK statements which makes things easy to find.
         */
        
        /// Will bind view model logic here (Currently not utilizing VM therefore refrencing self here in the property for demo purposes.
        let button = self.searchButton
        
        let buttonTaps = button.rx.tap.asObservable()
        
        buttonTaps
            .bind(onNext: { self.loadNewVC() } )
            .disposed(by: disposeBag)
        
        let secondButton = self.secondButton
        
        let secondButtonTaps = secondButton.rx.tap.asObservable()
        
        secondButtonTaps
            .bind(onNext: { self.loadShortModal() } )
            .disposed(by: disposeBag)
        
        // ----------------------------------------
        // MARK: Title
        // ----------------------------------------
        
        /// This takes the title property from the ViewModel and binds it to the ViewControllers title.
        /// These types of statements are extremely common for all kinds of UI elements.
        //        viewModel
        //            .title
        //            .drive(rx.title)
        //            .disposed(by: disposeBag)
        
        // ----------------------------------------
        // MARK: Some Label
        // ----------------------------------------
        
        //        viewModel
        //            .someValue
        //            .drive(someLabel.rx.text)
        //            .disposed(by: disposeBag)
        
        // ----------------------------------------
        // MARK: UITableView
        // ----------------------------------------
        
        /**
         This is where you will bind the sections to the UITableView
         
         Our applications deal with collecting and displaying dynamic data and therefore binding Sections
         to UITableViews is something you will need to be very familiar with.
         
         To accomplish this we use RxDataSources (https://github.com/RxSwiftCommunity/RxDataSources)
         There are tons of examples throughout the application and things vary slightly but
         the overall setup is roughly the same.
         */
        
        /// Create the dataSource from the dataSource method.
        //        let dataSource = self.dataSource()
        
        /// Bind the sections from the ViewModel to the UITableView. This is the code that actually
        /// connects the Sections to the UITableView.
        //        viewModel
        //            .sections
        //            .drive(tableView.rx.items(dataSource: dataSource))
        //            .disposed(by: disposeBag)
        
        /// If you are using a refreshControl this will tell the table when to stop the refreshing animation.
        //        viewModel
        //            .isRefreshingTableView
        //            .drive(refreshControl.rx.isRefreshing)
        //            .disposed(by: disposeBag)
        
        /**
         Any other UITableView functionality like scrolling back to specific places in the UITableView
         or telling the UITableView to layout its cells.
         */
        
        // ----------------------------------------
        // MARK: Navigation
        // ----------------------------------------
        
        /**
         This is where the navigation steps that get emitted from the ViewModel are bound to the steps property.
         This statement is all you need to do to let the Flow know that there is a new step and will trigger
         the navigation to it.
         */
        //        viewModel
        //            .nextStep
        //            .bind(to: steps)
        //            .disposed(by: disposeBag)
    }
    
    /// Testing Live Preview methods
    private func changeColor() {
        searchButton.backgroundColor = [.systemRed, .systemOrange, .systemBlue, .systemPurple, .systemGreen, .systemGray][Int.random(in: 0...5)]
        print("tapped")
    }
    
    private func collapseText() {
        collapsed.toggle()
        detailLabel.numberOfLines = collapsed ? 4 : 0
    }
  
    private func loadShortModal() {
        print("showing?")
    }
    
    /// Handled in designated VC (Currently here for demo)
    private func loadNewVC() {
        let newVC = UIViewController()
        newVC.view.backgroundColor = .systemBlue
        newVC.modalPresentationStyle = .currentContext
        newVC.modalTransitionStyle = .flipHorizontal
        
        newVC.view.rx.swipeGesture(.down, .right)
            .subscribe(onNext: { swipe in
                newVC.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        present(newVC, animated: true)
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


// ----------------------------------------
// MARK: - dataSource
// ----------------------------------------

//extension ExampleViewController {
//
//    /**
//     This is where you will transform the section models that are emitted by the ViewModel into UI such as
//     UITableViewCells, section titles and to let the UITableView know what functionality it should have.
//
//     You might not need all of the parameters here, for example if you do not need editing or section titles
//     you can drop the last two parameters.
//     */
//    private func dataSource() -> RxTableViewSectionedReloadDataSource<ExampleSection> {
//        RxTableViewSectionedReloadDataSource(
//            configureCell: { dataSource, tableView, indexPath, _ in
//                switch dataSource[indexPath] {
//                case .someItem:
//                    /// Dequeues a reusable cell using a convenience function found in QgivKit.
//                    let cell: ExampleTableViewCell = tableView.dequeueReusableCell(for: indexPath)
//
//                    /// This is where you will do any cell configuration. If you only need one way data
//                    /// flow you will most likely follow the ViewModel pattern and if you need bi-directional
//                    /// data flow you should use the UITableView.UIInput/UITableViewCellOutputs. There are
//                    /// plenty of examples of both patterns in the codebase you can reference
//
//                    return cell
//                }
//            },
//            titleForHeaderInSection: { dataSource, index in
//                dataSource.sectionModels[index].title
//            },
//            canEditRowAtIndexPath: { dataSource, indexPath in
//                dataSource[indexPath].canEdit
//            }
//        )
//    }
//}

// ----------------------------------------
// MARK: - UITableViewDelegate
// ----------------------------------------

/**
 If you need further customization of the UITableView you can use delegate methods just as you normally would.
 
 Note that if you need to access properties on the section dataSource you will need to hold a strong reference
 to it in the ViewController and it can be accessed using the indexPath in the delegate method.
 */

//extension ExampleViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        75
//    }
//}

/**
 Extensions with no implementation should be at the very bottom of the file. Here we are
 conforming to the `NetworkActivityIndicatable` protocol which lets us add a UIActivityIndicator
 to any ViewController with no extra code in the ViewController itself.
 */

// ----------------------------------------
// MARK: - NetworkActivityIndicatable
// ----------------------------------------

//extension ExampleViewController: NetworkActivityIndicatable {}
