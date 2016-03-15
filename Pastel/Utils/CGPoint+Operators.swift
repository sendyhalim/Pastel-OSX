//
//  CGPoint+Operators.swift
//  Pastel
//
//  Created by Sendy Halim on 3/16/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Foundation

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
