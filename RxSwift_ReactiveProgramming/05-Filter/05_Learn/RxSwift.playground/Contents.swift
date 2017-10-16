//: Please build the scheme 'RxSwiftPlayground' first
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import Foundation
import UIKit

example(of: "ignoreElements and elemensAtIndex") {
    
    let strikes = PublishSubject<String>()
    let bag = DisposeBag()
    
    strikes.ignoreElements().subscribe{event in
        print("1)",event)
    }.addDisposableTo(bag)
    
    strikes.elementAt(0).subscribe({ (event) in
        print("2)",event.element ?? event)
    })
    
    strikes.onNext("1")
    strikes.onNext("2")
    strikes.onNext("3")
    strikes.onCompleted()
}


example(of: "filter"){
    
    let strikes = PublishSubject<Int>()
    
    strikes.filter({ (number) -> Bool in
        return number > 2
    }).subscribe({ (event) in
        print(event)
    })
    
    strikes.onNext(1)
    strikes.onNext(2)
    strikes.onNext(3)
    strikes.onCompleted()
    
}

example(of: "skip") {
    
    Observable.of(1,2,3,5,2,3).skip(1).subscribe({ (event) in
        print(event);
    }).dispose()
    
}

example(of: "skipWhile"){
    // skip until something not  skip
    Observable.of(18,2,3,5,7,6).skipWhile({ (a) -> Bool in
        return a < 9
    }).subscribe({ (event) in
        print(event)
    }).dispose()
}


example(of: "take"){
    
    Observable.of(1,2,3,4,5,6).take(3).subscribe({ (event) in
        print(event)
    }).dispose()

}

example(of: "takeWhile"){
    
    // take  until somthing cant satify the condition
    Observable.of(10,5,6,1,5,6).takeWhileWithIndex({ (integer, index) -> Bool in
        integer > 9
    }).subscribe({ (event) in
        print(event)
    })
}



example(of:"mutityObser"){

    var start = 0
    func getStartNumber() -> Int {
        start += 1
        return start
    }
    

    let numbers = Observable<Int>.create { observer in
        let start = getStartNumber()
    
        
        observer.onNext(start)
        observer.onNext(start+1)
        observer.onNext(start+2)
        observer.onCompleted()
//        print("===== do it again")
        return Disposables.create()
    }
    
    
    let share = numbers.share()
    
    
    share
        .subscribe(onNext: { el in
            print("fffffelement [\(el)]")
        }, onCompleted: {
            print("1)complete-------------")
        })
    
    
    share
        .subscribe(onNext: { el in
            print("====element [\(el)]")
        }, onCompleted: {
            print("2)complete-------------")
        })

    
}

/*:
 Copyright (c) 2014-2016 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
