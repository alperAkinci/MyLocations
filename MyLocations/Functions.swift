//
//  Functions.swift
//  MyLocations
//
//  Created by Alper on 28/11/16.
//  Copyright © 2016 alper. All rights reserved.
//

import Foundation
import UIKit


//Free Function : 
//not a method inside an object, and as a result it can be used from anywhere in your code.

//The annotation @escaping is necessary for closures that are not performed immediately, so that Swift knows that it should hold on to this closure for a while.
func afterDelay(_ seconds : Double,closure: @escaping()->()){
    
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: closure)
    
}

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
        return paths[0]
    }()


let MyManagedObjectContextSaveDidFailNotification = Notification.Name(
    rawValue: "MyManagedObjectContextSaveDidFailNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(
        name: MyManagedObjectContextSaveDidFailNotification, object: nil)
}




