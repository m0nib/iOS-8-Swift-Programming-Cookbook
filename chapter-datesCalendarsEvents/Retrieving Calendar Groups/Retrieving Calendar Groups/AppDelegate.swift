//
//  AppDelegate.swift
//  Retrieving Calendar Groups
//
//  Created by Vandad Nahavandipoor on 6/24/14.
//  Copyright (c) 2014 Pixolity Ltd. All rights reserved.
//
//  These example codes are written for O'Reilly's iOS 8 Swift Programming Cookbook
//  If you use these solutions in your apps, you can give attribution to
//  Vandad Nahavandipoor for his work. Feel free to visit my blog
//  at http://vandadnp.wordpress.com for daily tips and tricks in Swift
//  and Objective-C and various other programming languages.
//  
//  You can purchase "iOS 8 Swift Programming Cookbook" from
//  the following URL:
//  http://shop.oreilly.com/product/0636920034254.do
//
//  If you have any questions, you can contact me directly
//  at vandad.np@gmail.com
//  Similarly, if you find an error in these sample codes, simply
//  report them to O'Reilly at the following URL:
//  http://www.oreilly.com/catalog/errata.csp?isbn=0636920034254

import UIKit
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  //  func findIcloudEventSource(){
  //    var icloudEventSource: EKSource?
  //
  //    let eventStore = EKEventStore()
  //    for source in eventStore.sources() as! [EKSource]{
  //      if source.sourceType.value == EKSourceTypeCalDAV.value &&
  //        source.title.lowercaseString == "icloud"{
  //          icloudEventSource = source
  //      }
  //    }
  //
  //    if let source = icloudEventSource{
  //      println("The iCloud event source was found = \(source)")
  //    } else {
  //      println("Could not find the iCloud event source")
  //    }
  //
  //  }
  
  func findIcloudEventSource(){
    var icloudEventSource: EKSource?
    
    let eventStore = EKEventStore()
    for source in eventStore.sources() as! [EKSource]{
      if source.sourceType.value == EKSourceTypeCalDAV.value &&
        source.title.lowercaseString == "icloud"{
          icloudEventSource = source
      }
    }
    
    if let source = icloudEventSource{
      println("The iCloud event source was found = \(source)")
      
      let calendars = source.calendarsForEntityType(EKEntityTypeEvent)
      
      for calendar in calendars as! Set<EKCalendar>{
        println(calendar)
      }
      
    } else {
      println("Could not find the iCloud event source")
    }
    
  }
  
  
  func displayAccessDenied(){
    println("Access to the event store is denied.")
  }
  
  func displayAccessRestricted(){
    println("Access to the event store is restricted.")
  }
  
  func example1(){
    
    let eventStore = EKEventStore()
    
    switch EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent){
      
    case .Authorized:
      findIcloudEventSource()
    case .Denied:
      displayAccessDenied()
    case .NotDetermined:
      eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion:
        {[weak self] (granted: Bool, error: NSError!) -> Void in
          if granted{
            self!.findIcloudEventSource()
          } else {
            self!.displayAccessDenied()
          }
        })
    case .Restricted:
      displayAccessRestricted()
    }
    
    
  }
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
    
    example1()
    
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
    // Override point for customization after application launch.
    self.window!.backgroundColor = UIColor.whiteColor()
    self.window!.makeKeyAndVisible()
    return true
  }
  
}

