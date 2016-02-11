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

extension NSImage {
  public override func isEqual(img: AnyObject?) -> Bool {
    guard let img = img as? NSImage else {
      return false
    }

    guard let lhs = self.TIFFRepresentation,
          let rhs = img.TIFFRepresentation else {
      return false
    }

    return lhs.isEqualToData(rhs)
  }
}

func == (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  switch (lhs, rhs) {
  case (.Text(let str1), .Text(let str2)):
    return str1 == str2

  case (.URL(let url1), .URL(let url2)):
    return url1 == url2

  case (.Image(let image1), .Image(let image2)):
    return image1.isEqualTo(image2)

  default:
    return false
  }
}

func != (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  return !(lhs == rhs)
}
