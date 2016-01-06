//
//  AppState.swift
//  AppState
//
//  Created by Phan Hong Viet on 11/30/15.
//  Copyright (c) 2015 Viet Phan. All rights reserved.
//

import Foundation
import UIKit

public struct AppStateEvent {
  let name: String
  let from: [String]
  let to: String
  
  public init(name: String, from: [String], to: String) {
    self.name = name
    self.from = from
    self.to = to
  }
  
  public init(name: String, from: String, to: String) {
    self.init(name: name, from: [from], to: to)
  }
}

public typealias AppEvents = [AppStateEvent]
public typealias StateContext = [String: AnyObject]

@objc public protocol AppStateDelegate {
  optional func onLeaveState(eventName: String, currentState: String, from: String, to: String, context: StateContext?)
  optional func onEnterState(eventName: String, currentState: String, from: String, to: String, context: StateContext?)
}

public class AppState {

  //---------------------------------------------------------------------------
  
  public enum Result {
  
    // the event transitioned successfully from one state to another
    case Succeeded
    
    // the event was successfull but no state transition was necessary
    case NoTransition
  }
  
  //---------------------------------------------------------------------------
  
  let initialState: String
  let events: AppEvents

  
  private var _delegateDict = [String: AppStateDelegate]()
  private var _currentState: String
  private var eventNotFound = ""
  
  // { event: { from: to } }
  var map = [String: [String: String]]()
  
  // { state: [ event ] }
  var transition = [String: [String]]()
  
  public init(initialState: String, events: AppEvents) {
    self.initialState = initialState
    self.events = events
    
    _currentState = initialState
    
    // Init Events
    self.addEvents(events)
  }
  
  // MARK: - Instance
  
  // Add a delegate
  public func addDelegate(delegate: AppStateDelegate, forState state: String) {
    _delegateDict[state] = delegate
  }
  
  // Remove all delegates
  public func removeAllDelegates() {
    _delegateDict.removeAll(keepCapacity: false)
  }
  
  // Remove a delegate
  public func removeDelegateForState(state: String) {
    _delegateDict.removeValueForKey(state)
  }
  
  // Get current state
  public func getCurrentState() -> String {
    return _currentState
  }

  public func getDelegate() -> [String: AppStateDelegate] {
    return _delegateDict
  }
  
  // Return true if state is the current state
  public func isCurrentState(stateName: String) -> Bool {
    return stateName == getCurrentState()
  }
  
  // Return list of events that are allowed from the current state
  public func getTransitions() -> [String] {
    var transitions = [String]()
    if let eventNames = transition[getCurrentState()] {
      transitions = eventNames
    }
    
    return transitions
  }
  
  // Transit to other state from current state by event name
  public func transitTo(eventName: String, context: StateContext? = nil) -> Result {
    if canTransitTo(eventName) {
      return _transitTo(eventName, context: context)
    }
    
    return Result.NoTransition
  }
  
  // Return true if event can be fired in the current state
  public func canTransitTo(eventName: String) -> Bool {
    if let eventNames = transition[getCurrentState()] {
      return eventNames.contains(eventName)
    }
    
    return false
  }
  
  // Adding Events to State Machine
  public func addEvents(events: AppEvents) {
    for event in events {
      addEvent(event)
    }
  }
  
  // Adding an Event to State Machine
  public func addEvent(event: AppStateEvent) {
    if map[event.name] == nil {
      map[event.name] = [:]
    }
  
    for from in event.from {
      if transition[from] == nil {
        transition[from] = []
      }
      
      if transition[from] != nil {
        transition[from]!.append(event.name)
      }
      
      if map[event.name] != nil {
        map[event.name]![from] = event.to
      }
    }
  }
  
  // Update destination step if have
  public func updateState(state: String, context: StateContext? = nil) -> Result {
    let eventName = eventNameForState(state)
    if eventName != eventNotFound {
      return _transitTo(eventName, context: context)
    }
    
    return Result.NoTransition
  }
  
  // Register View Controller for state
  public func registerViewController(viewController: UIViewController, forState state: String) {
    if let viewControllerDelegate = viewController as? AppStateDelegate {
      self.addDelegate(viewControllerDelegate, forState: state)
    }
  }
  
  // MARK: - private
  // Return true if it's state delegate
  private func _isStateHasDelegate(state: String) -> Bool {
    if let _ = _delegateDict[state] {
      return true
    }
    return false
  }
  
  // Return true if the current state could change to next state
  private func eventNameForState(state: String) -> String {
    let currentState = getCurrentState()
    
    for (eventName, states) in map {
      for (from, to) in states {
        if from == currentState && to == state {
          return eventName
        }
      }
    }
    
    return eventNotFound
  }
  
  // Transit to other state from current state by event name
  private func _transitTo(eventName: String, context: StateContext? = nil) -> Result {
    if let state = map[eventName], to = state[getCurrentState()] {
      let from = getCurrentState()
      let isStateHasDelegate = _isStateHasDelegate(to)
      
      // Call delegate on leave state
      if isStateHasDelegate {
        _delegateDict[to]?.onLeaveState?(eventName, currentState: getCurrentState(), from: from, to: to, context: context)
      }
      
      _currentState = to
      
      // Call delegate on enter state
      if isStateHasDelegate {
        _delegateDict[to]?.onEnterState?(eventName, currentState: getCurrentState(), from: from, to: to, context: context)
      }
      
      return Result.Succeeded
    }
    
    return Result.NoTransition
  }
  
}