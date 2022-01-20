//
//  DemoView.swift
//  UIKitPreviews
//
//  Created by Adam Herring on 1/20/22.
//

import SwiftUI
import UIKit
import RxSwift
import RxCocoa

class DemoView: UIView {
    
    // ----------------------------------------
    // MARK: UI Elements
    // ----------------------------------------
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.systemPurple
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "Title"
        return label
    }()
    
    private let bidderNumberOutline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemBlue.cgColor
        return view
    }()
    
    private let bidderNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.text = "1"
        return label
    }()
    
    private let attendeeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 24)
        label.text = "Name"
        return label
    }()
    
    private let statisticTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 14)
        label.text = "Statistics Title"
        return label
    }()
    
    private let statisticValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor.black
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.text = "Statistics Value"
        return label
    }()
    
    // ----------------------------------------
    // MARK: Properties
    // ----------------------------------------
    
    private let disposeBag = DisposeBag()
    
    // ----------------------------------------
    // MARK: Initialization
    // ----------------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
//    convenience init(viewModel: ViewModel) {
//        self.init(frame: .zero)
//
//        configureView(with: viewModel)
//    }
    
    private func setupView() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
        
        addSubview(bidderNumberOutline)
        NSLayoutConstraint.activate([
            bidderNumberOutline.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            bidderNumberOutline.centerXAnchor.constraint(equalTo: centerXAnchor),
            bidderNumberOutline.widthAnchor.constraint(equalToConstant: 50),
            bidderNumberOutline.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        bidderNumberOutline.addSubview(bidderNumberLabel)
        NSLayoutConstraint.activate([
            bidderNumberLabel.centerXAnchor.constraint(equalTo: bidderNumberOutline.centerXAnchor),
            bidderNumberLabel.centerYAnchor.constraint(equalTo: bidderNumberOutline.centerYAnchor)
        ])
        
        addSubview(attendeeNameLabel)
        NSLayoutConstraint.activate([
            attendeeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            attendeeNameLabel.topAnchor.constraint(equalTo: bidderNumberOutline.bottomAnchor, constant: 12),
            attendeeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
        
        addSubview(statisticTitleLabel)
        NSLayoutConstraint.activate([
            statisticTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            statisticTitleLabel.topAnchor.constraint(equalTo: attendeeNameLabel.bottomAnchor, constant: 12),
            statisticTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24)
        ])
        
        addSubview(statisticValueLabel)
        NSLayoutConstraint.activate([
            statisticValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            statisticValueLabel.topAnchor.constraint(equalTo: statisticTitleLabel.bottomAnchor, constant: 6),
            statisticValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            statisticValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
}

// ----------------------------------------
// MARK: - ViewModel
// ----------------------------------------

//extension AttendeeStatisticsView {
//    struct ViewModel {
//        let title: Driver<String>
//        let bidderNumber: Driver<String>
//        let attendeeName: Driver<String>
//        let statisticTitle: Driver<String>
//        let statisticValue: Driver<String>
//
//        init(attendee: Observable<AuctionItemCategory.FinalStatistics.AttendeeBidStatistics>) {
//            title = .just("Attendee With Most Bids")
//
//            bidderNumber = attendee
//                .map { String($0.bidderNumber) }
//                .asDriverLogError()
//
//            attendeeName = attendee
//                .map { $0.name.fullName.or("Bidder #\($0.bidderNumber)") }
//                .asDriverLogError()
//
//            statisticTitle = .just("Total Bids")
//
//            statisticValue = attendee
//                .map { String($0.bidCount) }
//                .asDriverLogError()
//        }
//
//        init(attendee: Observable<AuctionItemCategory.FinalStatistics.AttendeeAmountStatistics>) {
//            title = .just("Attendee With Highest Total")
//
//            bidderNumber = attendee
//                .map { String($0.bidderNumber) }
//                .asDriverLogError()
//
//            attendeeName = attendee
//                .map { $0.name.fullName.or("Bidder #\($0.bidderNumber)") }
//                .asDriverLogError()
//
//            statisticTitle = .just("Total Amount")
//
//            statisticValue = attendee
//                .map { $0.amount.asCurrencyString() }
//                .asDriverLogError()
//        }
//    }
//}

// ----------------------------------------
// MARK: - configureView
// ----------------------------------------

//extension AttendeeStatisticsView {
//    func configureView(with viewModel: ViewModel) {
//        viewModel
//            .title
//            .drive(titleLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel
//            .bidderNumber
//            .drive(bidderNumberLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel
//            .attendeeName
//            .drive(attendeeNameLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel
//            .statisticTitle
//            .drive(statisticTitleLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        viewModel
//            .statisticValue
//            .drive(statisticValueLabel.rx.text)
//            .disposed(by: disposeBag)
//    }
//}


struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        ViewPreview {
            DemoView()
        }
    }
}
