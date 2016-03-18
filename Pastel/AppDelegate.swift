//
//  AppDelegate.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import ServiceManagement
import Swiftz

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
  let popover = NSPopover()
  var eventMonitor: EventMonitor?

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // TODO: remove below code, it's just for testing
    startAtLogin()

    guard let button = statusItem.button else {
      return
    }

    button.image = NSImage(named: "ClipboardImage")
    button.image?.template = true
    button.action = Selector("togglePopover:")

    popover.contentViewController = MainViewController(
      nibName: "MainViewController",
      bundle: nil
    )

    eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) {
      [unowned self] event in
      if self.popover.shown {
        self.closePopover(event)
      }
    }

    eventMonitor?.start()
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }

  func togglePopover(sender: AnyObject?) {
    if popover.shown {
      closePopover(sender)
    } else {
      openPopover(sender)
    }
  }

  func openPopover(sender: AnyObject?) {
    popover.showRelativeToRect(
      statusItem.button!.bounds,
      ofView: statusItem.button!,
      preferredEdge: NSRectEdge.MinY
    )

    eventMonitor?.start()
  }

  func closePopover(sender: AnyObject?) {
    popover.performClose(sender)
    eventMonitor?.stop()
  }

  private func startAtLogin() {
    let launcherAppIdentifier = "com.sendyhalim.PastelLauncher"

    SMLoginItemSetEnabled(launcherAppIdentifier, true)

    let runningApplications = List(fromArray: NSWorkspace.sharedWorkspace().runningApplications)
    let startedAtLogin = runningApplications.any {
      $0.bundleIdentifier == launcherAppIdentifier
    }

    if startedAtLogin {
      NSDistributedNotificationCenter.defaultCenter().postNotificationName(
        "killme",
        object: NSBundle.mainBundle().bundleIdentifier!
      )
    }
  }
}
