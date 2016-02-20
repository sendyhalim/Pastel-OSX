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

struct ItemCell {
  static let maxHeight: CGFloat = 200
  static let maxWidth: CGFloat = 364
  static let minHeight: CGFloat = 115
  static let height = adjustedHeight • heightForItemType
}

func adjustedHeight(height: CGFloat) -> CGFloat {
  if height < ItemCell.minHeight {
    return ItemCell.minHeight
  }

  if height > ItemCell.maxHeight {
    return ItemCell.maxHeight
  }

  return height
}

func heightForItemType(type: PasteboardItemType) -> CGFloat {
  switch type {
  case .URL(let url):
    let font = NSFont.systemFontOfSize(13)
    return url.description.heightForString(font, width: ItemCell.maxWidth)

  case .Text(let text):
    let font = NSFont.systemFontOfSize(13)
    return text.heightForString(font, width: ItemCell.maxWidth)

  case .Image(let image):
    return image.size.height

  case .LocalFile(_, let _type):
    return heightForItemType(_type)
  }
}

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
    let cell = cellForItemType(item.type, atIndexPath: indexPath)

    // TODO: Create PasteboardItemViewModel to provide the formatted date
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MMM. dd, yyyy 'at' HH:mm"
    cell.createdAtTextField.stringValue = formatter.stringFromDate(item.createdAt)

    return cell
  }

  func cellForItemType(
    type: PasteboardItemType,
    atIndexPath indexPath: NSIndexPath
  ) -> PasteboardCollectionViewItem {
    switch type {
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

    case .LocalFile(_, let _type):
      return cellForItemType(_type, atIndexPath: indexPath)
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
    return NSSize(width: width, height: ItemCell.height(item.type))
  }

  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    let index = indexPaths.first!.item
    viewModel.addItemToPasteboard(index)
  }
}
