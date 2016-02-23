//
//  PasteboardItem.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

indirect enum PasteboardItemType {
  case Text(String)
  case URL(NSURL)
  case Image(NSImage)
  case LocalFile((NSURL, PasteboardItemType))
}

struct PasteboardItem {
  let type: PasteboardItemType
  let createdAt: NSDate


  init(type: PasteboardItemType, createdAt: NSDate) {
    self.type = type
    self.createdAt = createdAt
  }

  init(type: PasteboardItemType) {
    self.init(type: type, createdAt: NSDate())
  }
}

extension NSImage {
  public override func isEqualTo(object: AnyObject?) -> Bool {
    guard let rhsImage = object as? NSImage else {
      return false
    }

    guard let lhs = self.TIFFRepresentation,
          let rhs = rhsImage.TIFFRepresentation else {
      return false
    }

    return lhs.isEqualToData(rhs)
  }
}

func == (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  return lhs.type == rhs.type
}

func == (lhs: PasteboardItemType, rhs: PasteboardItemType) -> Bool {
  switch (lhs, rhs) {
  case (.Text(let str1), .Text(let str2)):
    return str1 == str2

  case (.URL(let url1), .URL(let url2)):
    return url1 == url2

  case (.Image(let image1), .Image(let image2)):
    return image1.isEqualTo(image2)

  case (.LocalFile(_, let item1), .LocalFile(_, let item2)):
    return item1 == item2

  default:
    return false
  }
}

func != (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  return !(lhs == rhs)
}
