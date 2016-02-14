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
  let vm = PasteboardListViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    vm.items().driveNext {
      print("Paste board items: \($0)")
    }
    .addDisposableTo(disposeBag)

    vm.startPollingItems()
    // Do any additional setup after loading the view.
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}
