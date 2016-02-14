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

  func startPollingItems() {
    Observable.interval(1, scheduler: MainScheduler.instance)
      .subscribeNext(constantCall(service.pollPasteboardItems, Int.zero))
      .addDisposableTo(disposeBag)
  }
}
