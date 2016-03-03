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
    typealias Content = PasteboardItemContent

    describe("==") {
      context("with PasteboardItemContent.Text") {
        let text = Content.Text("what")

        it("should return true") {
          expect(text == Content.Text("what")) == true
        }

        it("should return false") {
          expect(text == Content.Text("wht")) == false
        }
      }

      context("with PasteboardItemContent.URL") {
        let url = Content.URL(NSURL(string: "http://what")!)

        it("should return true") {
          let result = url == Content.URL(NSURL(string: "http://what")!)
          expect(result) == true
        }

        it("should return false") {
          let result = url == Content.URL(NSURL(string: "http://whut")!)
          expect(result) == false
        }
      }
    }
  }
}
