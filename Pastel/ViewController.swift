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
  let viewModel = PasteboardListViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    viewModel.items().driveNext {
      print("Paste board items: \($0)")
    }
    .addDisposableTo(disposeBag)

    viewModel.startPollingItems()
    // Do any additional setup after loading the view.
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}
