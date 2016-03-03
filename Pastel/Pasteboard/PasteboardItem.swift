//
//  PasteboardItem.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

enum File {
  case Image(NSURL, NSImage)
}

indirect enum PasteboardItemContent {
  case Text(String)
  case URL(NSURL)
  case Image(NSImage)
  case LocalFile(File)
}

struct PasteboardItem {
  let content: PasteboardItemContent
  let createdAt: NSDate


  init(content: PasteboardItemContent, createdAt: NSDate) {
    self.content = content
    self.createdAt = createdAt
  }

  init(content: PasteboardItemContent) {
    self.init(content: content, createdAt: NSDate())
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

func == (lhs: File, rhs: File) -> Bool {
  switch (lhs, rhs) {
  case (.Image(_, let img1), .Image(_, let img2)):
    return img1 == img2
  }
}

func == (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  return lhs.content == rhs.content
}

func == (lhs: PasteboardItemContent, rhs: PasteboardItemContent) -> Bool {
  switch (lhs, rhs) {
  case (.Text(let str1), .Text(let str2)):
    return str1 == str2

  case (.URL(let url1), .URL(let url2)):
    return url1 == url2

  case (.Image(let image1), .Image(let image2)):
    return image1.isEqualTo(image2)

  case (.LocalFile(let item1), .LocalFile(let item2)):
    return item1 == item2

  default:
    return false
  }
}

func != (lhs: PasteboardItem, rhs: PasteboardItem) -> Bool {
  return !(lhs == rhs)
}
