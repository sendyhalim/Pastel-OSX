//
//  AppDelegate.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
  let popover = NSPopover()
  var eventMonitor: EventMonitor?

  func applicationDidFinishLaunching(aNotification: NSNotification) {
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
}
