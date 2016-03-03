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
    let pasteboard = NSPasteboard.generalPasteboard()

    describe(".pasteboardItemContent()") {
      let service = PasteboardService()

      context("when passed with an NSURL") {
        it("should return PasteBoardItemContent.URL") {
          let url = NSURL(string: "https://what.dude")!
          let result = service.pasteboardItemContent(url)
          expect(result) == .URL(NSURL(string: "https://what.dude")!)
        }
      }

      context("when passed with a string") {
        context("that doesn't match a url") {
          it("should return PasteBoardItemContent.Text") {
            let result = service.pasteboardItemContent("yo")
            expect(result) == .Text("yo")
          }
        }

        context("that matches a url") {
          it("should return PasteBoardItemContent.Text") {
            let result = service.pasteboardItemContent("https://boom.shakalaka")
            expect(result) == .Text("https://boom.shakalaka")
          }
        }
      }
    }

    describe(".pollPasteboardItem()") {
      context("when polling 1 time") {
        let service = PasteboardService()

        beforeEach {
          pasteboard.clearContents()
          pasteboard.writeObjects(["hi there!"])
          service.pollPasteboardItems()
        }

        afterEach {
          pasteboard.clearContents()
        }

        it("should have 1 PasteboardItem") {
          expect(service.pasteboardItems.value.count) == 1
        }

        it("should have .Text as the PasteboardItemContent") {
          expect(service.pasteboardItems.value[0].content) == .Text("hi there!")
        }
      }

      context("when polling 2 times") {
        let service = PasteboardService()

        beforeEach {
          pasteboard.clearContents()
          pasteboard.writeObjects(["wolverine"])
          service.pollPasteboardItems()

          pasteboard.clearContents()
          pasteboard.writeObjects(["ironman"])
          service.pollPasteboardItems()
        }

        afterEach {
          pasteboard.clearContents()
        }

        it("should have 1 PasteboardItem") {
          expect(service.pasteboardItems.value.count) == 2
        }

        it("should have .Text for both of the PasteboardItemContent") {
          expect(service.pasteboardItems.value[0].content) == .Text("ironman")
          expect(service.pasteboardItems.value[1].content) == .Text("wolverine")
        }
      }
    }

    describe(".addItemToPasteboard()") {
      context("given a PasteboardItem with content .Text") {
        let service = PasteboardService()

        beforeEach {
          let item = PasteboardItem(content: .Text("test-item"))
          service.addItemToPasteboard(item)
        }

        afterEach {
          pasteboard.clearContents()
        }

        it("should have 1 PasteboardItem") {
          expect(service.pasteboardItems.value.count) == 1
        }

        it("should have 1 PasteboardItem with content .Text") {
          expect(service.pasteboardItems.value[0].content) == .Text("test-item")
        }
      }

      context("given a PasteboardItem with content .URL") {
        let service = PasteboardService()

        beforeEach {
          let url = NSURL(string: "https://cermati.com")!
          let item = PasteboardItem(content: .URL(url))
          service.addItemToPasteboard(item)
        }

        afterEach {
          pasteboard.clearContents()
        }

        it("should have 1 PasteboardItem") {
          expect(service.pasteboardItems.value.count) == 1
        }

        it("should have 1 PasteboardItem with content .URL") {
          let expectedUrl = NSURL(string: "https://cermati.com")!
          expect(service.pasteboardItems.value[0].content) == .URL(expectedUrl)
        }
      }
    }
  }
}
