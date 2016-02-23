//
//  PasteboardServiceSpec.swift
//  Pastel
//
//  Created by Sendy Halim on 2/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Nimble
import Quick

@testable import Pastel

class PasteboardServiceSpec: QuickSpec {
  override func spec() {
    let service = PasteboardService()

    describe(".pasteboardItemType()") {
      context("when passed with an NSURL") {
        it("should return PasteBoardItemType.URL") {
          let url = NSURL(string: "https://what.dude")!
          let result = service.pasteboardItemType(url)
          expect(result) == PasteboardItemType.URL(NSURL(string: "https://what.dude")!)
        }
      }

      context("when passed with a string") {
        context("that doesn't match a url") {
          it("should return PasteBoardItemType.Text") {
            let result = service.pasteboardItemType("yo")
            expect(result) == PasteboardItemType.Text("yo")
          }
        }

        context("that matches a url") {
          it("should return PasteBoardItemType.Text") {
            let result = service.pasteboardItemType("https://boom.shakalaka")
            expect(result) == PasteboardItemType.Text("https://boom.shakalaka")
          }
        }
      }
    }
  }
}
