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

class PasteboardCollectionViewController: NSViewController {
  let textItemCellId = "TextItemCell"

  let disposeBag = DisposeBag()
  let viewModel = PasteboardListViewModel()

  @IBOutlet weak var collectionView: NSCollectionView!

  override func awakeFromNib() {
    super.viewDidLoad()
    let textItemNib = NSNib(nibNamed: textItemCellId, bundle: nil)
    collectionView.registerNib(textItemNib, forItemWithIdentifier: textItemCellId)

    viewModel.items().driveNext {
      [weak self] in
      print("Paste board items: \($0)")
      self?.collectionView.reloadData()

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


extension PasteboardCollectionViewController:
  NSCollectionViewDataSource,
  NSCollectionViewDelegate,
  NSCollectionViewDelegateFlowLayout {

  func collectionView(
    collectionView: NSCollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return viewModel.totalItems()
  }

  func collectionView(
    collectionView: NSCollectionView,
    itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath
  ) -> NSCollectionViewItem {
    let item = viewModel[indexPath.item]
    var cell = PasteboardCollectionViewItem()

    switch item {
    case .Text(let text):
      cell = collectionView.makeItemWithIdentifier(
        textItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.textField?.stringValue = text
    default:
      break
    }

    return cell
  }
}
