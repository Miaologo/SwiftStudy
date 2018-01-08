//
//  ReactiveX.swift
//  FeatureStar
//
//  Created by Tim on 2018/1/4.
//  Copyright © 2018年 LM. All rights reserved.
//

import Foundation
import UIKit

enum Result<Value> {
    case success(Value)
    case error(Error)
}

final class KeyValueObserver<T>: NSObject {
    private let object: NSObject
    private let keyPath: String
    private let callback: (T) -> Void
    
    init(object: NSObject, keyPath: String, callback: @escaping (T) -> Void) {
        self.object = object
        self.keyPath = keyPath
        self.callback = callback
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, keyPath == self.keyPath, let value = change?[.newKey] as? T else {
            return
        }
        callback(value)
    }
    deinit {
        object.removeObserver(self, forKeyPath: keyPath)
    }
}

final class Signal<Value> {
    fileprivate typealias Subscriber = (Result<Value>) -> Void
    fileprivate typealias Token = UUID
    fileprivate var subscribers: [Token : Subscriber] = [:]

    fileprivate var objects: [KeyValueObserver<Value>] = []
    
    func send(_ result: Result<Value>) {
        for (_, subscriber) in subscribers {
            subscriber(result)
        }
    }
    func subscribe(_ subscribe: @escaping (Result<Value>) -> Void) -> Disposable {
        let token = UUID()
        subscribers[token] = subscribe
        return Disposable.create({
            self.subscribers[token] = nil
        })
    }
    static func empty() -> ((Result<Value>) -> Void, Signal<Value>) {
        let signal = Signal<Value>()
        return ({[weak signal] value in signal?.send(value)}, signal)
    }
}

final class Disposable {
    private let dispose: () -> Void
    static func create(_ dispose: @escaping () -> Void) -> Disposable {
        return Disposable(dispose)
    }
    init(_ dispose: @escaping () -> Void) {
        self.dispose = dispose
    }
    deinit {
        dispose()
    }
}




extension UITextField {
    var signal: Signal<String> {
        let (sink, signal) = Signal<String>.empty()
        let observer = KeyValueObserver<String>(object: self, keyPath: #keyPath(text)) { str in
            sink(.success(str))
        }
        signal.objects.append(observer)
        return signal
    }
}
