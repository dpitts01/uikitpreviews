//
//  DemoItem.swift
//  UIKitPreviews
//
//  Created by danielpitts on 1/19/22.
//

import Foundation
import Differentiator

struct DemoItem: Decodable, Hashable, IdentifiableType {
    typealias Identity = Int
    
    var identity: Identity
    let title: String
    let description: String
    let price: Int
    let category: DemoItemCategory
}

enum DemoItemCategory: String, Decodable, CaseIterable {
    case forSale, auction, food
}

extension DemoItem {
    static var demoItems: [DemoItem] {
        var items: [DemoItem] = []
        for int in 0...11 {
            let item = DemoItem(identity: int, title: "Item \(int)", description: "This is the description of Item \(int).", price: Int.random(in: 0...1000), category: [DemoItemCategory.food, DemoItemCategory.forSale, DemoItemCategory.auction][Int.random(in: 0...2)])
            items.append(item)
        }
        return items
    }
}

// MARK: DemoItemSection
struct DemoItemSection: Hashable, IdentifiableType {
    typealias Identity = Int
    var identity: Identity
    
    var title: String
    var items: [DemoItem]
}

extension DemoItemSection: AnimatableSectionModelType {
    typealias Item = DemoItem
    
    init(original: DemoItemSection, items: [Item]) {
        self = original
        self.items = items
    }
}
