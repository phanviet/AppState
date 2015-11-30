//
//  SignInWorkflow.swift
//  AppState
//
//  Created by Phan Hong Viet on 11/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit

struct SignInWorkflow {
  
  init() {
    AppWorkflow.sharedInstance.addEvents([
      AppStateEvent(name: "showSignInPage", from: ["landingPage", "welcomePage"], to: "signInPage"),
      AppStateEvent(name: "showWelcomePage", from: "signInPage", to: "welcomePage")
    ])
    
    // Add delegate for this workflow
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    AppWorkflow.sharedInstance.registerViewController(storyboard.instantiateViewControllerWithIdentifier("signInViewController"), forState: "signInPage")
    AppWorkflow.sharedInstance.registerViewController(storyboard.instantiateViewControllerWithIdentifier("welcomeViewController"), forState: "welcomePage")
  }
}