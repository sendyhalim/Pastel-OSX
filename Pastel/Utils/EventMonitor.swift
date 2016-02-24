//
//  EventMonitor.swift
//  Pastel
//
//  Created by Sendy Halim on 2/24/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

typealias EventMonitorHandler = NSEvent? -> ()

final class EventMonitor {
  private var monitor: AnyObject?
  private let mask: NSEventMask
  private let handler: EventMonitorHandler

  init(mask: NSEventMask, handler: EventMonitorHandler) {
    self.mask = mask
    self.handler = handler
  }

  deinit {
    stop()
  }

  func start() {
    monitor = NSEvent.addGlobalMonitorForEventsMatchingMask(mask, handler: handler)
  }

  func stop() {
    guard let _monitor = monitor else {
      return
    }

    NSEvent.removeMonitor(_monitor)
    monitor = nil
  }
}
