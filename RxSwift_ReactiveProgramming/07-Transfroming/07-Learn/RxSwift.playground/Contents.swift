//: Please build the scheme 'RxSwiftPlayground' first
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift
import Foundation
import UIKit

example(of: "toArray") {
    let bag =  DisposeBag()
    Observable.of(1,2,3)
        .toArray()
        .subscribe({ (event) in
            print(event)
        }).addDisposableTo(bag)
}

example(of: "map"){
    let bag = DisposeBag()
    Observable.of(1,10,100).map({ $0 * 10
    }).subscribe({ print("1)",$0)
    }).addDisposableTo(bag)
    
    Observable.of(1,10,100,1000)
        .mapWithIndex { integer, index in
            index > 1 ? integer * 2 : integer
        }.subscribe({print("2)",$0)})
}

example(of: "flattenMap"){

    struct Student {
        var score:Variable<Int>
    }
    
    let bag = DisposeBag()
    
    let ryan = Student(score: Variable(80))
    let charlotte = Student(score: Variable(90))
    
    let student = PublishSubject<Student>()
    
    student.asObserver()
        .flatMap({ (student) in
            return student.score.asObservable()
        })
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(bag)
    
    
    student.onNext(ryan)
    student.onNext(charlotte)

    ryan.score.value = 801

}

example(of: "flatMapLatest"){
    
    struct Student {
        var score:Variable<Int>
    }

    let disposeBag = DisposeBag()
    let ryan = Student(score: Variable(80))
    let charlotte = Student(score: Variable(90))
    let student = PublishSubject<Student>()
    student.asObservable()
        .flatMapLatest {
            $0.score.asObservable()
        }
        .subscribe(onNext: {
            print($0) })
        .addDisposableTo(disposeBag)
    student.onNext(ryan)
    ryan.score.value = 801
    student.onNext(charlotte)
    // 1
    ryan.score.value = 802
     ryan.score.value = 802
    
    charlotte.score.value = 902

}





