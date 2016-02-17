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
    var cell = PasteboardCollectionViewItem()

    switch item {
    case .Text(let text):
      cell = collectionView.makeItemWithIdentifier(
        textItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.textField?.stringValue = text
      cell.textField?.toolTip = text

    case .Image(let image):
      cell = collectionView.makeItemWithIdentifier(
        imageItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.imageView?.image = image
      cell.imageView?.setNeedsDisplay()

    default:
      break
    }

    return cell
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

  func heightForItem(item: PasteboardItem) -> CGFloat {
    let maxHeight = collectionView.frame.size.height

    switch item {
    case .Text(let text):
      let font = NSFont.systemFontOfSize(13)
      return text.heightForString(font, width: 364)

    case .Image(let image):
      return maxHeight > 185 ? 185 : image.size.height

    default:
      return maxHeight
    }
  }
}

extension PasteboardCollectionViewController: NSCollectionViewDelegate {
  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    print("selected")
  }
}
