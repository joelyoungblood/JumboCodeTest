//
//  ViewModel.swift
//  JumboCodeTest
//
//  Created by Joel Youngblood on 8/10/19.
//  Copyright © 2019 Joel Youngblood. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel {
    
    private let disposeBag = DisposeBag()
    let isLoading = BehaviorRelay<Bool>(value: false)
    let validatedScript = PublishSubject<String>()
    let errorMessage = PublishSubject<JumboError>()
    
    func fetchAndValidateScript() {
        isLoading.accept(true)
        Request.requestChallenge().subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .subscribe(onNext: { [weak self] challenge in
                self?.isLoading.accept(false)
                switch(AppConstants.defaultValidator.validate(challenge: challenge)) {
                case .success(let script):
                    self?.validatedScript.onNext(script)
                case .failure(let error):
                    self?.errorMessage.onNext(error)
                }
            }, onError: { [weak self] error in
                self?.isLoading.accept(false)
                self?.errorMessage.onNext(NetworkError.unknownError)
            }).disposed(by: disposeBag)
    }
}
