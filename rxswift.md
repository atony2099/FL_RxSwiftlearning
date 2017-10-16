###  rxswift 

### Subscribing to observables



> Remember that an observable doesn’t do anything until it receives a subscription.It’s the subscription that triggers an observable to begin emitting events, up until it emits an .error or .completed event and is terminated. You can manually cause an observable to terminate by canceling a subscription to it.



### DisposeBag 

disposebag 被释放的时候，会对他里面的disposeable执行dispose

1. 立即释放

In case contained disposables need to be disposed, just put a different dispose bag or create a new one in its place.

2. 执行complete 或者error 的时候会自动dispose

```swift
func on(event: Event<E>) {
    switch event {
    case .Next:
        if _isStopped == 1 {
            return
        }
        forwardOn(event)
    case .Error, .Completed:
        if AtomicCompareAndSwap(0, 1, &_isStopped) {
            forwardOn(event)
            dispose()
        }
    }
}
```

> observae  send complete or error  all the resources used to manage subscription are disposed of automatically. 



### ignoring  operation

**ignore** : it discards all elements
of the source sequence and lets through only .completed or .error.

![](http://ohbzayk4i.bkt.clouddn.com/17-10-12/63382394.jpg)





**elementAt**

![](http://ohbzayk4i.bkt.clouddn.com/17-10-12/29335649.jpg)

### filter

![](http://ohbzayk4i.bkt.clouddn.com/17-10-12/53416087.jpg)

### ignore

> filter all elements within the specifiied time interval

![](http://ohbzayk4i.bkt.clouddn.com/17-10-16/90260219.jpg)



### take operation

#### take: will take the number of element you specified

![](http://ohbzayk4i.bkt.clouddn.com/17-10-16/61603235.jpg)

#### takeLast: take from the end of source of sequence







#### takewill: take until the  sequences cant satisfy the conditon 