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
  static let minHeight: CGFloat = 130
  static let height = adjustedHeight • heightForItemContent
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

func heightForItemContent(content: PasteboardItemContent) -> CGFloat {
  switch content {
  case .URL(let url):
    let font = NSFont.systemFontOfSize(13)
    return url.description.heightForString(font, width: ItemCell.maxWidth)

  case .Text(let text):
    let font = NSFont.systemFontOfSize(13)
    return text.heightForString(font, width: ItemCell.maxWidth)

  case .Image(let image):
    return image.size.height

  case .LocalFile(.Image(_, let _content)):
    return heightForItemContent(PasteboardItemContent.Image(_content))
  }
}

class PasteboardCollectionViewController: NSViewController {
  let textItemCellId = "TextItemCell"
  let imageItemCellId = "ImageItemCell"

  let disposeBag = DisposeBag()
  let viewModel = PasteboardListViewModel()

  @IBOutlet weak var collectionView: NSCollectionView!

  override func awakeFromNib() {
    super.awakeFromNib()
    viewModel.startPollingItems()

    viewModel
      .items()
      .driveNext(constantCall(collectionView.reloadData))
      .addDisposableTo(disposeBag)
  }

  @IBAction func quit(sender: AnyObject) {
    NSApplication.sharedApplication().terminate(sender)
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
    let vm = viewModel[indexPath.item]
    let cell = cellForItemContent(vm.item.content, atIndexPath: indexPath)
    cell.createdAtTextField.stringValue = vm.createdAt

    return cell
  }

  func cellForItemContent(
    content: PasteboardItemContent,
    atIndexPath indexPath: NSIndexPath
  ) -> PasteboardCollectionViewItem {
    switch content {
    case .URL(let url):
      let cell = collectionView.makeItemWithIdentifier(
        textItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.textField!.stringValue = url.description
      cell.view.toolTip = url.description
      return cell

    case .Text(let text):
      let cell = collectionView.makeItemWithIdentifier(
        textItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.textField!.stringValue = text
      cell.view.toolTip = text
      return cell

    case .Image(let image):
      let cell = collectionView.makeItemWithIdentifier(
        imageItemCellId,
        forIndexPath: indexPath
      ) as! PasteboardCollectionViewItem
      cell.imageView!.image = image
      return cell

    case .LocalFile(.Image(let url, let _content)):
      let cell = cellForItemContent(
        PasteboardItemContent.Image(_content),
        atIndexPath: indexPath
      )
      cell.view.toolTip = url.path
      return cell
    }
  }
}

extension PasteboardCollectionViewController: NSCollectionViewDelegateFlowLayout {
  func collectionView(
    collectionView: NSCollectionView,
    layout collectionViewLayout: NSCollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath
  ) -> NSSize {
    return sizeForItem(viewModel[indexPath.item].item)
  }

  func sizeForItem(item: PasteboardItem) -> NSSize {
    let width = collectionView.frame.size.width
    return NSSize(width: width, height: ItemCell.height(item.content))
  }

  func collectionView(
    collectionView: NSCollectionView,
    didSelectItemsAtIndexPaths indexPaths: Set<NSIndexPath>
  ) {
    let index = indexPaths.first!.item
    viewModel.addItemToPasteboard(index)
  }
}
