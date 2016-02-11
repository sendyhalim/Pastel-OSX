//
//  PasteboardItem.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

enum PasteboardItem {
  case Text(String)
  case URL(NSURL)
  case Image(NSImage)
}
