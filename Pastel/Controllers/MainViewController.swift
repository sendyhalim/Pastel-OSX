//
//  MainViewController.swift
//  Pastel
//
//  Created by Sendy Halim on 2/15/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
  @IBOutlet var mainView: NSView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do view setup here.

    let pasteboardViewController = PasteboardCollectionViewController(
      nibName: "PasteboardCollectionViewController",
      bundle: nil
    )!

    mainView.addSubview(pasteboardViewController.view)
  }
}
