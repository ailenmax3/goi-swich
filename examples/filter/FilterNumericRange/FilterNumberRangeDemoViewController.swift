//
//  NumericRangeDemoViewController.swift
//  development-pods-instantsearch
//
//  Created by Guy Daher on 14/06/2019.
//  Copyright © 2019 Algolia. All rights reserved.
//

import Foundation
import UIKit
import InstantSearch

class FilterNumberRangeDemoViewController: UIViewController {

  let controller: FilterNumberRangeDemoController
  let numericRangeController: NumericRangeController
  let searchDebugViewController: SearchDebugViewController

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    numericRangeController = NumericRangeController(rangeSlider: .init())
    controller = .init()
    searchDebugViewController = SearchDebugViewController(filterState: controller.filterState)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupUI()
  }

}

private extension FilterNumberRangeDemoViewController {
  
  func setup() {
    controller.rangeConnector.connectController(numericRangeController)
    addChild(searchDebugViewController)
    searchDebugViewController.didMove(toParent: self)

  }

  func setupUI() {
    view.backgroundColor = .white
    let mainStackView = UIStackView()
    mainStackView.axis = .vertical
    mainStackView.spacing = 10
    mainStackView.isLayoutMarginsRelativeArrangement = true
    mainStackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    
    let searchDebugView = searchDebugViewController.view!
    searchDebugView.translatesAutoresizingMaskIntoConstraints = false
    searchDebugView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    mainStackView.addArrangedSubview(searchDebugView)
    mainStackView.addArrangedSubview(numericRangeController.view)
    mainStackView.addArrangedSubview(.spacer)
    view.addSubview(mainStackView)
    mainStackView.pin(to: view.safeAreaLayoutGuide)
  }

}