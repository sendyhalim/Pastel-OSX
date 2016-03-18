//
//  AppDelegate.swift
//  PastelLauncher
//
//  Created by Sendy Halim on 3/18/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var window: NSWindow!

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let pastelIdentifier = "com.sendyhalim.Pastel"
    let runningApplications = NSWorkspace.sharedWorkspace().runningApplications
    let alreadyRunning = runningApplications.reduce(false) {
      $0 ? $0 : $1.bundleIdentifier == pastelIdentifier
    }

    if alreadyRunning {
      terminate()
    } else {
      NSDistributedNotificationCenter.defaultCenter().addObserver(
        self,
        selector: "terminate",
        name: "com.sendyhalim.Pastel.killme",
        object: pastelIdentifier
      )

      let path = NSBundle.mainBundle().bundlePath as NSString
      var components = path.pathComponents
      components.removeLast()
      components.removeLast()
      components.removeLast()
      components.append("MacOS")
      components.append("Pastel")

      let newPath = NSString.pathWithComponents(components)
      NSWorkspace.sharedWorkspace().launchApplication(newPath)
    }
  }

  func terminate() {
    NSApp.terminate(nil)
  }
}
