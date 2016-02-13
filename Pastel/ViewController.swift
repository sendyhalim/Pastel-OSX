//
//  ViewController.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class ViewController: NSViewController {
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    let pasteboardService = PasteboardService()

    pasteboardService.pasteboardItems.asDriver().driveNext {
      print("Paste board items: \($0)")
    }
    .addDisposableTo(disposeBag)

    Observable.interval(1, scheduler: MainScheduler.instance)
      .subscribeNext {
        (second: Int) in
        print("Polling at second \(second)")
        pasteboardService.pollPasteboardItems()
      }
      .addDisposableTo(disposeBag)

    // Do any additional setup after loading the view.
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}
