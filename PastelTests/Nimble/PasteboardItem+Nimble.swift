//
//  PasteboardItem+Nimble.swift
//  Pastel
//
//  Created by Sendy Halim on 2/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Nimble
@testable import Pastel

func equal(expectedValue: PasteboardItemType) -> MatcherFunc<PasteboardItemType> {
  return MatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "equal <\(expectedValue)>"
    return try actualExpression.evaluate()! == expectedValue
  }
}

func == (
  expectation: Expectation<PasteboardItemType>,
  expectedValue: PasteboardItemType
) {
  return expectation.to(equal(expectedValue))
}
