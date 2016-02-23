//
//  PasteboardItemViewModelSpec.swift
//  Pastel
//
//  Created by Sendy Halim on 2/23/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Nimble
import Quick
@testable import Pastel

class PasteboardItemViewModelSpec: QuickSpec {
  override func spec() {

    describe(".createdAt") {
      let formatter = NSDateFormatter()
      formatter.dateFormat = "dd MM yyyy"

      let item = PasteboardItem(
        type: .Text("over the rainbow"),
        createdAt: formatter.dateFromString("20 01 2016")!
      )
      let vm = PasteboardItemViewModel(item)

      it("should return correct created at date string") {
        expect(vm.createdAt) == "Jan. 20, 2016 at 00:00"
      }
    }
  }
}
