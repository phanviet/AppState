//
//  AppWorkflow.swift
//  AppState
//
//  Created by Phan Hong Viet on 11/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import AppState

struct AppWorkflow {

  static var sharedInstance = AppState(initialState: "root", events: [
    AppStateEvent(name: "showLandingPage", from: "root", to: "landingPage"),
    AppStateEvent(name: "backLandingPage", from: ["signInPage", "welcomePage"], to: "landingPage")
  ])
  
  static var currentViewController = UIViewController()
  
  init() {
  
    // Init all sub workflow
    _ = SignInWorkflow()
  
    // Add delegate for root view controller
    AppWorkflow.sharedInstance.registerViewController(UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("viewController"), forState: "landingPage")
  }
  
  /**
  Check whether a view controller instance is in navigation stack
  */
  static func isViewControllerInStack(view : UIViewController) -> Bool {
    for var index = 0; index < AppWorkflow.currentViewController.navigationController?.viewControllers.count; index++ {
      if ((AppWorkflow.currentViewController.navigationController?.viewControllers[index].isKindOfClass(view.dynamicType))! == true) {
        return true
      }
    }
    
    return false
  }
  
  static func currentViewControllerPushOrPopController(controller: UIViewController) {
    if AppWorkflow.isViewControllerInStack(controller) {
      AppWorkflow.currentViewController.navigationController?.popToViewController(controller, animated: true)
    } else {
      AppWorkflow.currentViewController.navigationController?.pushViewController(controller, animated: true)
    }
  }
  
}