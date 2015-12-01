# AppState

[![CI Status](http://img.shields.io/travis/Viet Phan/AppState.svg?style=flat)](https://travis-ci.org/Viet Phan/AppState)
[![Version](https://img.shields.io/cocoapods/v/AppState.svg?style=flat)](http://cocoapods.org/pods/AppState)
[![License](https://img.shields.io/cocoapods/l/AppState.svg?style=flat)](http://cocoapods.org/pods/AppState)
[![Platform](https://img.shields.io/cocoapods/p/AppState.svg?style=flat)](http://cocoapods.org/pods/AppState)

## What is it

It's small library written by Swift used as router management in iOS app.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

- Define route via `AppStateEvent`

  ```swift
  let appState = AppState(initialState: "root", events: [
    AppStateEvent(name: "showLandingPage", from: "root", to: "landingPage"),
    AppStateEvent(name: "showSignInPage", from: ["landingPage", "welcomePage"], to: "signInPage")
  ])
  ```
  
  + name: event name
  + from: source state
  + to: destination state
  + E.g: If app is at "root" state (viewController), app could only update to "landingPage" state. If app is at "landingPage" or "welcomePage" state, then app could update to "signInPage" state
  
- Register view controller as `AppStateDelegate` for each state

  ```swift
  appState.registerViewController(signInViewController, forState: "signInPage")
  appState.registerViewController(welcomeViewController, forState: "welcomePage")
  appState.registerViewController(homeViewController, forState: "landingPage")

  extension SignInViewController: AppStateDelegate {

    // will call when entering new state
    func onEnterState(eventName: String, currentState: String, from: String, to: String, context: StateContext?) {
      // got context, present - push - pop - animation new view, assign data from context ...
    }

    // will call when leaving current state
    func onLeaveState(eventName: String, currentState: String, from: String, to: String, context: StateContext?)
  }
  ```
  
  + Call `appState.transitTo(<eventName>, context: context)` to update state and pass data through `context` as `[String: AnyObject]` type
  
- E.g: App is at "landingPage" state (as `HomeViewController`) and call `appState.transitTo("showSignInPage")`, app would be update as "signInPage" state (as `SignInViewController`).

## Requirements

## Installation

AppState is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "AppState"
```

## Author

Viet Phan, vietphxfce@gmail.com

## License

AppState is available under the MIT license. See the LICENSE file for more info.
