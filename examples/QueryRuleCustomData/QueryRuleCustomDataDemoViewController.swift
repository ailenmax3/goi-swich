//
//  QueryRuleCustomDataDemoViewController.swift
//  DemoDirectory
//
//  Created by Vladislav Fitc on 12/10/2020.
//  Copyright © 2020 Algolia. All rights reserved.
//

import Foundation
import InstantSearch
import SDWebImage

class QueryRuleCustomDataDemoViewController: UIViewController {
    
  let searchBar = UISearchBar()
  
  let searcher: HitsSearcher
  
  let queryInputConnector: QueryInputConnector
  let textFieldController: TextFieldController
    
  let hitsConnector: HitsConnector<Hit<Product>>
  let hitsTableViewController: ProductsTableViewController
  
  let queryRuleCustomDataConnector: QueryRuleCustomDataConnector<Banner>
  let bannerViewController: BannerViewController
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    self.searcher = HitsSearcher(client: .demo, indexName: "instant_search")
    self.textFieldController = .init(searchBar: searchBar)
    self.hitsTableViewController = .init()
    self.bannerViewController = BannerViewController()
    self.queryInputConnector = .init(searcher: searcher,
                                     controller: textFieldController)
    self.hitsConnector = .init(searcher: searcher,
                               interactor: .init(),
                               controller: hitsTableViewController)
    self.queryRuleCustomDataConnector = .init(searcher: searcher,
                                              controller: bannerViewController)
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
  }
  
  private func setup() {
    
    addChild(bannerViewController)
    bannerViewController.didMove(toParent: self)
    
    addChild(hitsTableViewController)
    hitsTableViewController.didMove(toParent: self)
    hitsTableViewController.tableView.keyboardDismissMode = .onDrag
    
    bannerViewController.didTapBanner = { [weak self] in
      if let link = self?.bannerViewController.banner?.link {
        switch link.absoluteString {
        case "algoliademo://discounts":
          let submitViewController = TemplateViewController()
          submitViewController.label.textAlignment = .center
          submitViewController.label.text = "Redirect via banner tap"
          self?.present(UINavigationController(rootViewController: submitViewController), animated: true, completion: nil)
        default:
          UIApplication.shared.open(link)
        }
      }
    }
    
    queryInputConnector.interactor.onQuerySubmitted.subscribe(with: self) { (viewController, _) in
      guard let link = viewController.queryRuleCustomDataConnector.interactor.item?.link else { return }
      if link.absoluteString == "algoliademo://help" {
        UIApplication.shared.open(link)
        let submitViewController = TemplateViewController()
        submitViewController.label.textAlignment = .center
        submitViewController.label.text = "Redirect via submit"
        viewController.present(UINavigationController(rootViewController: submitViewController), animated: true, completion: nil)
      }
    }.onQueue(.main)

    searcher.search()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle.fill"),
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(presentInfo))
  }
  
  @objc func presentInfo() {
    let alertController = UIAlertController(title: "Help", message: QueryRuleCustomDataDemoController.helpMessage, preferredStyle: .alert)
    alertController.addAction(.init(title: "OK", style: .cancel, handler: nil))
    present(alertController, animated: true, completion: nil)
  }

}

private extension QueryRuleCustomDataDemoViewController {
  
  func configureUI() {
    view.backgroundColor = .white
    configureLayout()
  }
    
  func configureLayout() {
    searchBar.translatesAutoresizingMaskIntoConstraints = false
    searchBar.searchBarStyle = .minimal

    bannerViewController.view.isHidden = true
    bannerViewController.view.heightAnchor.constraint(lessThanOrEqualToConstant: 66.7).isActive = true
    
    let stackView = UIStackView()
    stackView.spacing = 16
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    stackView.addArrangedSubview(searchBar)
    stackView.addArrangedSubview(bannerViewController.view)
    stackView.addArrangedSubview(hitsTableViewController.view)
    view.addSubview(stackView)
    stackView.pin(to: view.safeAreaLayoutGuide)
  }
  
}
