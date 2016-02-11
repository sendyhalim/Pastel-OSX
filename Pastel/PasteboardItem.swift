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

func == (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  switch (lhs, rhs) {
  case (.Text(let str1), .Text(let str2)):
    return str1 == str2

  case (.URL(let url1), .URL(let url2)):
    return url1 == url2

  case (.Image(let image1), .Image(let image2)):
    return image1.isEqual(image2)

  default:
    return false
  }
}

func != (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  return !(lhs == rhs)
}
