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

///  A service to write/read from clipboard (pasteboard).
struct PasteboardService {
  let pasteboard = NSPasteboard.generalPasteboard()
  let pasteboardItems = Variable([PasteboardItem]())
  let changeCount = Variable(0)
  let disposeBag = DisposeBag()

  ///  Polls one pasteboard item from the pasteboard
  ///  then add (prepend) it to `pasteboardItems` Observable.
  func pollPasteboardItems() {
    if changeCount.value == pasteboard.changeCount {
      return
    }

    let items = pasteboard.readObjectsForClasses(
      [NSURL.self, NSString.self, NSImage.self],
      options: nil
    )

    items?.first >>- pasteboardItemContent >>- pasteboardItem >>- addPasteboardItem
  }

  ///  Creates a new `PasteboardItem` based on the given `PasteboardItemContent`.
  ///
  ///  - parameter content: `PasteboardItemContent`.
  ///
  ///  - returns: PasteboardItem.
  func pasteboardItem(content: PasteboardItemContent) -> PasteboardItem {
    return PasteboardItem(content: content)
  }

  ///  Creates an `Optional<PasteboardItemContent>`.
  ///  If the given content is an `NSURL` it will try to create an `NSImage`, if it
  ///  succeed then it assume the `NSURL` is a `PasteboardItemContent.LocalFile`,
  ///  otherwise it will guess based on casting.
  ///
  ///  - parameter item: `AnyObject`.
  ///
  ///  - returns: An `Optional<PasteboardItemContent>`.
  func pasteboardItemContent(item: AnyObject) -> PasteboardItemContent? {
    if let url = item as? NSURL {
      if let image = NSImage(contentsOfURL: url) {
        return .LocalFile(.Image(url, image))
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

  ///  Writes the given `PasteboardItem` to system clipboard.
  ///
  ///  - parameter item: `PasteboardItem` to be written.
  func addItemToPasteboard(item: PasteboardItem) {
    pasteboard.clearContents()

    switch item.content {
    case .URL(let url):
      pasteboard.writeObjects([url])

    case .Text(let string):
      pasteboard.writeObjects([string])

    case .Image(let image):
      pasteboard.writeObjects([image])

    case .LocalFile(.Image(let url, _)):
      pasteboard.writeObjects([url])
    }

    pollPasteboardItems()
  }

  ///  Prepends a `PasteboardItem` to `pasteboardItems` Observable.
  ///
  ///  - parameter item: `PasteboardItem` to be prepended.
  private func addPasteboardItem(item: PasteboardItem) {
    pasteboardItems.value = pasteboardItems.value.filter {
      $0 != item
    }.cons(item)

    changeCount.value = pasteboard.changeCount
  }
}
