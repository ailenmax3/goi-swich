//
//  SceneDelegate.swift
//  DynamicFacets
//
//  Created by Vladislav Fitc on 01.04.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    setMain(DynamicFacetListDemoViewController(), for: scene)
  }

}
