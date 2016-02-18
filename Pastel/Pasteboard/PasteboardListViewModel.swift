//
//  PasteboardListViewModel.swift
//  Pastel
//
//  Created by Sendy Halim on 2/14/16.
//  Copyright © 2016 Sendy Halim. All rights reserved.
//

import RxSwift
import RxCocoa

struct PasteboardListViewModel {
  let service = PasteboardService()
  let disposeBag = DisposeBag()
  var pollIsRunning = false

  func items() -> Driver<[PasteboardItem]> {
    return service.pasteboardItems.asDriver()
  }

  func totalItems() -> Int {
    return service.pasteboardItems.value.count
  }

  func startPollingItems() {
    Observable<Int>.interval(1, scheduler: MainScheduler.instance)
      .subscribeNext(constantCall(service.pollPasteboardItems))
      .addDisposableTo(disposeBag)
  }

  func addItemToPasteboard(index: Int) {
    service.addItemToPasteboard(self[index])
  }

  subscript(index: Int) -> PasteboardItem {
    return service.pasteboardItems.value[index]
  }
}
