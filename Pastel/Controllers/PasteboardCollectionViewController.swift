//
//  PasteboardCollectionViewController.swift
//  Pastel
//
//  Created by Sendy Halim on 2/11/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa
import Swiftz

class PasteboardCollectionViewController: NSViewController {
  let textItemCellId = "TextItemCell"
  let imageItemCellId = "ImageItemCell"

  let disposeBag = DisposeBag()
  let viewModel = PasteboardListViewModel()

  @IBOutlet weak var collectionView: NSCollectionView!

  override func viewDidLoad() {
    viewModel.startPollingItems()

    viewModel
      .items()
      .driveNext(constantCall(collectionView.reloadData))
      .addDisposableTo(disposeBag)
  }
}


extension PasteboardCollectionViewController: NSCollectionViewDataSource {
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
    return cellForItem(item, atIndexPath: indexPath)
  }

  func cellForItem(
    item: PasteboardItem,
    atIndexPath indexPath: NSIndexPath
  ) -> PasteboardCollectionViewItem {
    switch item {
    case .URL(let url):
      let cell = collectionView.makeItemWithIdentifier(
        textItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.textField!.stringValue = url.description
      cell.textField!.toolTip = url.description
      return cell

    case .Text(let text):
      let cell = collectionView.makeItemWithIdentifier(
        textItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.textField!.stringValue = text
      cell.textField!.toolTip = text
      return cell

    case .Image(let image):
      let cell = collectionView.makeItemWithIdentifier(
        imageItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.imageView!.image = image
      return cell

    case .LocalFile(_, let _item):
      return cellForItem(_item, atIndexPath: indexPath)
    }
  }
}

extension PasteboardCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    collectionView: NSCollectionView,
    layout collectionViewLayout: NSCollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath
  ) -> NSSize {
    return sizeForItem(viewModel[indexPath.item])
  }

  func sizeForItem(item: PasteboardItem) -> NSSize {
    let width = collectionView.frame.size.width
    return NSSize(width: width, height: heightForItem(item))
  }

  func adjustedTextHeight(height: CGFloat) -> CGFloat {
    return height > 185 ? 185 : height
  }

  func heightForItem(item: PasteboardItem) -> CGFloat {
    let maxHeight = collectionView.frame.size.height

    switch item {
    case .URL(let url):
      let font = NSFont.systemFontOfSize(13)
      let height = url.description.heightForString(font, width: 364)
      return adjustedTextHeight(height)

    case .Text(let text):
      let font = NSFont.systemFontOfSize(13)
      let height = text.heightForString(font, width: 364)
      return adjustedTextHeight(height)

    case .Image(let image):
      return maxHeight > 185 ? 185 : image.size.height

    case .LocalFile(_, let item):
      return heightForItem(item)
    }
  }

  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    let index = indexPaths.first!.item
    viewModel.addItemToPasteboard(index)
  }
}
