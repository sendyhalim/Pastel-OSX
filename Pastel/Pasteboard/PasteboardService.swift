//
//  PasteboardService.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxSwift
import Swiftz

struct PasteboardService {
  let pasteboard = NSPasteboard.generalPasteboard()
  let pasteboardItems = Variable([PasteboardItem]())
  let changeCount = Variable(0)
  let disposeBag = DisposeBag()

  init() {
    pollPasteboardItems()
  }

  func pollPasteboardItems() {
    if changeCount.value == pasteboard.changeCount {
      return
    }

    guard let items = pasteboard.readObjectsForClasses(
        [NSURL.self, NSString.self, NSImage.self],
        options: [
          NSPasteboardTypeString: NSNumber(bool: true),
          NSPasteboardURLReadingFileURLsOnlyKey: NSNumber(bool: true),
          NSPasteboardURLReadingContentsConformToTypesKey: NSImage.imageTypes()
        ]
      )
      where items.count > 0 else {
      return
    }

    items.first >>- pasteboardItem >>- addPasteboardItem
  }

  func pasteboardItem(item: AnyObject) -> PasteboardItem? {
    if let url = item as? NSURL {
      if let image = NSImage(contentsOfURL: url) {
        return .Image(image)
      }

      return .URL(url)
    }

    if let string = item as? String {
      return .Text(string)
    }

    if let image = item as? NSImage {
      return .Image(image)
    }

    return Optional.None
  }

  func addItemToPasteboard(item: PasteboardItem) {
    pasteboard.clearContents()

    switch item {
    case .URL(let url):
      pasteboard.writeObjects([url as NSPasteboardWriting])

    case .Text(let string):
      pasteboard.writeObjects([string as NSPasteboardWriting])

    case .Image(let img):
      pasteboard.writeObjects([img as NSPasteboardWriting])
    }

    pollPasteboardItems()
  }

  private func addPasteboardItem(item: PasteboardItem) {
    pasteboardItems.value = pasteboardItems.value.filter {
      $0 != item
    }.cons(item)

    changeCount.value = pasteboard.changeCount
  }
}
