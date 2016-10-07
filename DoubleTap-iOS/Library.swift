//
//  Library.swift
//  Words
//
//  Created by Nikolaos Kechagias on 29/07/16.
//  Copyright © 2016 Nikolaos Kechagias. All rights reserved.
//

import Foundation

func formatNumber(number: Int) -> String {
    let formatter = NumberFormatter()
    formatter.formatterBehavior = .behavior10_4
    formatter.numberStyle = .decimal
    formatter.locale = NSLocale.current
    if let string = formatter.string(for: number) {
        return string
    } else {
        return "0"
    }
    
    
}

func hardProcessingWithString2(completion: () -> Void) {
    // ...
    completion()
}

func hardProcessingWithString(input: String, completion: (_ result: String) -> Void) {
    // ...
        completion("we finished!")
}
/*
hardProcessingWithString("commands") { (result: String) in
    print("got back: \(result)")
}
*/

func loadHealthCareList(completion: (_ indexes: [Int])-> Void) {
    // ...
    let array = [5,6,7]
    completion(array)
}

/*
loadHealthCareList { (indexes) -> () in
    print(indexes)
}
 */
