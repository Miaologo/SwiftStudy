//
//  ViewController.swift
//  FeatureStar
//
//  Created by Tim on 2018/1/4.
//  Copyright © 2018年 LM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let textField = UITextField()
    var signal : Signal<String>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signal1 = Signal<Int>()
        signal1.subscribe { result in
            print(result)
        }
        signal1.send(.success(100))
        
        let (sink, signal2) = Signal<Int>.empty()
        signal2.subscribe { result in
            print(result)
        }
        sink(.success(200))
        
        signal = textField.signal
        signal?.subscribe({ (result) in
            print(result)
        })
        textField.text = "123456"
        
        let cat = 🐱()
        let proto: Animal = cat
        
        cat.extensionMethod()
        proto.extensionMethod()
        
        let lombardis1: Pizzeria = Lombardis()
        let lombardis2: Lombardis = Lombardis()
        lombardis1.makeMargherita()
        lombardis2.makeMargherita()
    }
    
    deinit {
        print("Removing VC")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

protocol Animal {
    
}
extension Animal {
    func extensionMethod() {
        print("In Protocol extension method")
    }
}

struct 🐱: Animal {
}
extension 🐱 {
    func extensionMethod() {
        print("喵喵")
    }
}

protocol Pizzeria {
    func makePizza(_ ingredients: [String])
    func makeMargherita()
}

//extension Pizzeria {
//    func makeMargherita() {
//        return makePizza(["tomato", "mozzarella"])
//    }
//}

struct Lombardis: Pizzeria {
    func makePizza(_ ingredients: [String]) {
        print(ingredients)
    }
    func makeMargherita() {
        return makePizza(["tomato", "basil", "mozzarella"])
    }
}





