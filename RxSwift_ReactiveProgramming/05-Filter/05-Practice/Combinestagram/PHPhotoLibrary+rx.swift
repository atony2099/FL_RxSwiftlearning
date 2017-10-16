//
//  PHPhotoLibrary+rx.swift
//  Combinestagram
//
//  Created by admin on 16/10/2017.
//  Copyright © 2017 Underplot ltd. All rights reserved.
//


import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
    static var autorized:Observable<Bool> {
     
        
        return Observable.create({ (observe) -> Disposable in
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observe.onNext(true)
                    observe.onCompleted()
                    
                } else {
                    observe.onNext(false)
                    requestAuthorization({ (newStats) in
                        observe.onNext(newStats == .authorized)
                        observe.onCompleted()
                    })
                    
                }
            }
            
            
            return Disposables.create()
        })
        
        
    }
}


