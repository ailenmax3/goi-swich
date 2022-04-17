//
//  RelevantSortDemoSwiftUI.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 19/07/2021.
//  Copyright © 2021 Algolia. All rights reserved.
//

import Foundation
import InstantSearchCore
import InstantSearchSwiftUI
import SwiftUI

struct RelevantSortDemoSwiftUI: SwiftUIDemo, PreviewProvider {
  
  class Controller {
    
    let relevantSortController: RelevantSortObservableController
    let sortByController: SelectableSegmentObservableController
    let hitsController: HitsObservableController<Hit<Product>>
    let queryInputController: QueryInputObservableController
    let statsController: StatsTextObservableController
    let demoController: RelevantSortDemoController
    
    init() {
      relevantSortController = RelevantSortObservableController()
      sortByController = SelectableSegmentObservableController()
      hitsController = HitsObservableController()
      queryInputController = QueryInputObservableController()
      statsController = StatsTextObservableController()
      demoController = RelevantSortDemoController()
      demoController.sortByConnector.connectController(sortByController) { indexName in
        switch indexName {
        case "test_Bestbuy":
          return "Most relevant"
        case "test_Bestbuy_vr_price_asc":
          return "Relevant Sort - Lowest Price"
        case "test_Bestbuy_replica_price_asc":
          return "Hard Sort - Lowest Price"
        default:
          return indexName.rawValue
        }
      }
      demoController.relevantSortConnector.connectController(relevantSortController)
      demoController.hitsConnector.connectController(hitsController)
      demoController.queryInputConnector.connectController(queryInputController)
      demoController.statsConnector.connectController(statsController)
    }
    
  }
  
  struct ContentView: View {
    
    @ObservedObject var queryInputController: QueryInputObservableController
    @ObservedObject var sortByController: SelectableSegmentObservableController
    @ObservedObject var relevantSortController: RelevantSortObservableController
    @ObservedObject var hitsController: HitsObservableController<Hit<Product>>
    @ObservedObject var statsController: StatsTextObservableController
    
    @State var isEditing: Bool = false
    
    var body: some View {
      VStack {
        HStack {
          Text(statsController.stats)
          Spacer()
          Menu {
            ForEach(0 ..< sortByController.segmentsTitles.count, id: \.self) { index in
              let indexName = sortByController.segmentsTitles[index]
              Button(indexName) {
                sortByController.select(index)
              }
            }
          } label: {
            if let selectedSegmentIndex = sortByController.selectedSegmentIndex {
              Label(sortByController.segmentsTitles[selectedSegmentIndex], systemImage: "arrow.up.arrow.down.circle")
            }
          }
        }.padding()
        if let state = relevantSortController.state {
          HStack {
            Text(state.hintText)
              .foregroundColor(.gray)
              .font(.footnote)
            Spacer()
            Button(state.toggleTitle,
                   action: relevantSortController.toggle)
          }.padding()
        }
        HitsList(hitsController) { hit, _ in
          if let hit = hit {
            ShopItemRow(productHit: hit)
          } else {
            EmptyView()
          }
        }
      }
      .searchable(text: $queryInputController.query)
    }
    
  }
  
  static func contentView(with controller: Controller) -> ContentView {
    ContentView(queryInputController: controller.queryInputController,
                sortByController: controller.sortByController,
                relevantSortController: controller.relevantSortController,
                hitsController: controller.hitsController,
                statsController: controller.statsController)
    
  }
  
  static let controller = Controller()
  static var previews: some View {
    NavigationView {
      contentView(with: controller)
        .navigationBarTitle("Relevant Sort")
    }
  }
  
  
}
