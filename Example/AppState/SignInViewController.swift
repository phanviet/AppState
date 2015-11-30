//
//  SignInViewController.swift
//  AppState
//
//  Created by Phan Hong Viet on 11/30/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import AppState

class SignInViewController: UIViewController {
  
  var isClearInput = false
  
  @IBOutlet weak var userNameTextField: UITextField!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    let barBtnItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
    self.navigationItem.leftBarButtonItem = barBtnItem
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    if isClearInput {
      resetInput()
    }
  }
  
  func back() {
    AppWorkflow.sharedInstance.transitTo("backLandingPage")
  }
  
  private func resetInput() {
    print("@signIn: Reset Input")
    userNameTextField.text = ""
  }
  
  private func showSignInPage(context: StateContext?) {
    // Reset input
    if let context = context, isClearInput = context["isClearInput"] as? Bool {
      self.isClearInput = isClearInput
    } else {
      self.isClearInput = false
    }
    
    AppWorkflow.currentViewControllerPushOrPopController(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
  @IBAction func signInDidTouch(sender: AnyObject) {
    var context = [String: AnyObject]()
    context["username"] = userNameTextField.text
    AppWorkflow.sharedInstance.transitTo("showWelcomePage", context: context)
  }
}

extension SignInViewController: AppStateDelegate {
  func onEnterState(eventName: String, currentState: String, from: String, to: String, context: StateContext?) {
    switch eventName {
      case "showSignInPage":
        showSignInPage(context)
        break
      default:
        break
    }
  }
}
