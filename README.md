TPDelegateMatrioska 
====

>	It's base on [LBDelegateMatrioska](https://github.com/lukabernardi/LBDelegateMatrioska).

This class is a subclass of `NSProxy` subclass that allows you to have multiple delegate helper objects (instead of the usual 1 to 1 relationship between the delegator and delegate).

`TPDelegateMatrioska` is **thread safe** based  `NSRecursiveLock`.

## Usage

`pod 'TPDelegateMatrioska', '~> 0.0.3'`

You can init an `TPDelegateMatrioska` object with as many delegate objects you want

```
TPDelegateMatrioska *matrioska = [[TPDelegateMatrioska alloc] initWithDelegates:@[mapClusterDelegate, self]];
```
or

```
TPDelegateMatrioska *matrioska = [[TPDelegateMatrioska alloc] init];
[matrioska addDelegate:aDelegate];
...
```

and the add this object as delegate

```
obj.delegate = matrioska;
```

In this way every time the `obj` calls a delegate this call is forwarded to all the delegates **respecting the array sorting**.

The proxy object keep a **weak** reference to all the delegate objects, therefore is your responsibility to keep the objects alive with a strong reference. Anyway, by using an `NSPointerArray` I'm sure that if a delegate gets deallocated the reference inside the array is nil-ed and therefor doesn't crash the app.

There are just 2 basic rule and one limitation you have to keep in mind:

- The proxy will respond `YES` to the `respondToSelector:` message if and only if at least one of the provided delegate objects respond `YES` to the same method.
- The previous rule apply the same for `conformsToProtocol:`
- If the delegate method is non-`void` returning method only the first delegate (that is able to respond to that method) is called and its return value is returned.

## 中文说明

因为 [LBDelegateMatrioska](https://github.com/lukabernardi/LBDelegateMatrioska) 不是线程安全的，所以才有了这个库。

为什么没有提交 PR 而是新建一个仓库，因为我发现这个仓库已经太久没有更新过（虽然也可能是没有更新的必要QAQ）。

具体使用见 DEMO。

## License

TPDelegateMatrioska is available under the MIT license. See the LICENSE file for more info.
