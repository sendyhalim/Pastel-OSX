//
//  PasteboardItemSpec.swift
//  Pastel
//
//  Created by Sendy Halim on 2/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Nimble
import Quick

@testable import Pastel


class PasteboardItemSpec: QuickSpec {
  override func spec() {
    typealias Type = PasteboardItemType

    describe("==") {
      context("with PasteboardItemType.Text type") {
        let text = Type.Text("what")

        it("should return true") {
          expect(text == Type.Text("what")) == true
        }

        it("should return false") {
          expect(text == Type.Text("wht")) == false
        }
      }

      context("with PasteboardItemType.URL type") {
        let url = Type.URL(NSURL(string: "http://what")!)

        it("should return true") {
          let result = url == Type.URL(NSURL(string: "http://what")!)
          expect(result) == true
        }

        it("should return false") {
          let result = url == Type.URL(NSURL(string: "http://whut")!)
          expect(result) == false
        }
      }
    }
  }
}
