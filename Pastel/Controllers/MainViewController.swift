//
//  MainViewController.swift
//  Pastel
//
//  Created by Sendy Halim on 2/29/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class MainViewController: NSViewController {
  @IBOutlet weak var contentView: NSView!
  @IBOutlet weak var settingsButton: NSButton!
  @IBOutlet var settingsMenu: NSMenu!

  let pasteboardCollectionViewController = {
    return PasteboardCollectionViewController(
      nibName: "PasteboardCollectionViewController",
      bundle: nil
    )!
  }()

  let disposeBag = DisposeBag()

  override func awakeFromNib() {
    settingsButton.image?.template = true
    contentView.addSubview(pasteboardCollectionViewController.view)

    settingsButton
      .rx_tap
      .subscribeNext { [unowned self] in
        self.settingsMenu.popUpMenuPositioningItem(
          self.settingsMenu.itemAtIndex(0),
          atLocation: NSEvent.mouseLocation() + CGPoint(x: 10, y: -10),
          inView: nil
        )
      }
      .addDisposableTo(disposeBag)
  }
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
