//
//  String.swift
//  Pastel
//
//  Created by Sendy Halim on 2/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

extension String {
  ///  Calculate height based on the current state of Self (`String`)
  ///  with the given font and width
  ///
  ///  - parameter font:  `UIFont` to be used
  ///  - parameter width: Width limit
  ///
  ///  - returns: Height for the current state of `String`
  func heightForString(font: NSFont, width: CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.max)
    let rect = self.boundingRectWithSize(
      size,
      options: NSStringDrawingOptions.UsesLineFragmentOrigin,
      attributes: [NSFontAttributeName: font],
      context: nil
    )

    return ceil(rect.height)
  }
}
