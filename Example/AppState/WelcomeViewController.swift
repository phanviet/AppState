//
//  WelcomeViewController.swift
//  AppState
//
//  Created by Phan Hong Viet on 11/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import AppState

class WelcomeViewController: UIViewController {
  
  @IBOutlet weak var usernameLabel: UILabel!
  
  var username = ""
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let barBtnItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
    self.navigationItem.leftBarButtonItem = barBtnItem
  }
  
  func back() {
    AppWorkflow.sharedInstance.transitTo("showSignInPage")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    resetData()
    print(username)
    usernameLabel.text = username
  }
  
  private func resetData() {
    usernameLabel.text = ""
  }
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  private func showWelcomePage(context: StateContext?) {
    if let context = context, username = context["username"] as? String {
      self.username = username
    } else {
      self.username = ""
    }
    
    AppWorkflow.currentViewControllerPushOrPopController(self)
  }
  
  @IBAction func backToLandingPageDidTouch(sender: AnyObject) {
    AppWorkflow.sharedInstance.transitTo("backLandingPage")
  }
}

extension WelcomeViewController: AppStateDelegate {
  func onEnterState(eventName: String, currentState: String, from: String, to: String, context: StateContext?) {
    switch eventName {
      case "showWelcomePage":
        showWelcomePage(context)
        break
      default:
        break
    }
  }
}
