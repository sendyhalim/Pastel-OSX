//
//  MainViewController.swift
//  Pastel
//
//  Created by Sendy Halim on 2/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
  @IBOutlet weak var contentView: NSView!
  @IBOutlet weak var settingsButton: NSButton!

  let pasteboardCollectionViewController = {
    return PasteboardCollectionViewController(
      nibName: "PasteboardCollectionViewController",
      bundle: nil
    )!
  }()

  override func awakeFromNib() {
    contentView.addSubview(pasteboardCollectionViewController.view)
  }
}
