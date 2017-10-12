//: Please build the scheme 'RxSwiftPlayground' first
import RxSwift

example(of: "PublishSubject") {
    
    let bag = DisposeBag()
    
    let one = 1;
    let two = 2;
    let three = 3;
    
    let obser = Observable<Int>.of(one,two);
    
    obser.subscribe({ (event) in
        print(event)
    })
    
    print("======")
    obser.subscribe(onNext: { element in
       print(element)
    }, onDisposed:{
        print("dispose====")
    } ).addDisposableTo(bag)
    
}

// empty ===
example(of: "empty") {
    let observable = Observable<Void>.empty()
    observable.subscribe({ (event) in
        print(event)
    })
    
    print("======")
    observable.subscribe(onNext: { element in
        print(element)
    })

}


example(of: "create") {
    
    let bag = DisposeBag()
    let obser =  Observable<String>.create({ (observe) -> Disposable in
        observe.onNext("A");
        observe.onNext("B");
        return Disposables.create()
    })
    
    
    obser.subscribe(onNext: { (a) in
        print(a)
    }, onError: { (eror) in
        print("onError")

    }, onCompleted: { 
        print("onCompleted")

    }, onDisposed: {
        print("onDisposed")
    }).addDisposableTo(bag);
    
    
}


example(of: "dispose") {
   
    
    //===== frist dispose  ===== dispose
    // 1
    let observable = Observable.of("A", "B", "C")
    // 2
    let subscription = observable.subscribe { event in
        // 3
        print(event)
    }
    subscription.dispose();
    
    
    //  ===== second
    let bag = DisposeBag();
    observable.subscribe({ (event) in
        print(event);
    }).addDisposableTo(bag)
    
    

    
    
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
