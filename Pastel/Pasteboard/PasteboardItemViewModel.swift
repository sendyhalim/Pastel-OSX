//
//  PasteboardItemViewModel.swift
//  Pastel
//
//  Created by Sendy Halim on 2/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

///  A view model that represents a `PasteboardItem`.
struct PasteboardItemViewModel {
  let item: PasteboardItem
  let formatter: NSDateFormatter = NSDateFormatter()

  /// A date string when the `PasteboardItem` was created.
  var createdAt: String {
    return formatter.stringFromDate(item.createdAt)
  }

  init(_ _item: PasteboardItem) {
    item = _item
    formatter.dateFormat = "MMM. dd, yyyy 'at' HH:mm"
  }
}
