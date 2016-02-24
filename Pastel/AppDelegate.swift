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

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    guard let button = statusItem.button else {
      return
    }

    button.image = NSImage(named: "StatusBarButtonImage")
    button.action = Selector("togglePopover:")

    popover.contentViewController = PasteboardCollectionViewController(
      nibName: "PasteboardCollectionViewController",
      bundle: nil
    )
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
  }

  func closePopover(sender: AnyObject?) {
    popover.performClose(sender)
  }
}
