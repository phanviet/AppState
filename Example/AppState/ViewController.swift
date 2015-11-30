//
//  ViewController.swift
//  AppState
//
//  Created by Viet Phan on 11/27/2015.
//  Copyright (c) 2015 Viet Phan. All rights reserved.
//

import UIKit
import AppState

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func backLandingPage(context: StateContext?) {
    AppWorkflow.currentViewControllerPushOrPopController(self)
  }
  
  private func showLandingPage(context: StateContext?) {
    if let context = context, window = context["window"] as? UIWindow {
      let nav = UINavigationController()
      nav.viewControllers = [self]
      window.rootViewController = nav
      window.makeKeyAndVisible()
      AppWorkflow.currentViewController = self
    }
  }

  @IBAction func signInDidTouch(sender: AnyObject) {
    var context = [String: AnyObject]()
    context["isClearInput"] = true
    AppWorkflow.sharedInstance.transitTo("showSignInPage", context: context)
  }
}

extension ViewController: AppStateDelegate {
  
  func onEnterState(eventName: String, currentState: String, from: String, to: String, context: StateContext?) {
    print("@onEnter")
    print("@eventName: \(eventName)")
    print("@currentState: \(currentState)")
    print("@from: \(from)")
    print("@to: \(to)")
    print("@context: \(context)")
    
    switch eventName {
      case "showLandingPage":
        showLandingPage(context)
        break
      case "backLandingPage":
        backLandingPage(context)
      default:
        break
    }
  }
  
  func onLeaveState(eventName: String, currentState: String, from: String, to: String, context: StateContext?) {
    print("@onLeave")
    print("@eventName: \(eventName)")
    print("@currentState: \(currentState)")
    print("@from: \(from)")
    print("@to: \(to)")
    print("@context: \(context)")
  }
}