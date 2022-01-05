//
//  CustomNotification.swift
//  GithubFollowers
//
//  Created by Shelly Gupta on 12/10/21.
//

import Foundation

struct WeakModelWrapper: Hashable {

    private(set) weak var object: NSObject?
    
    init(object: NSObject) {
        self.object = object
    }

//    static func == (lhs: WeakModelWrapper, rhs: WeakModelWrapper) -> Bool {
//        return
//            lhs.object === rhs.object
//    }
}


class CustomNotificationCenter {
    static let shared = CustomNotificationCenter()
    private var storedObserver: [String: [WeakModelWrapper: NotificationCompletion]] = [:]
    typealias NotificationCompletion = (Any?) -> Void
    
    private init () {
    }
   
    
    func postNotification(name: String, notificationInfo: Any?) {
        storedObserver[name]?.values.forEach {
            $0(notificationInfo)
        }
    }
    
    func addObserver(_ observer: NSObject, completion: @escaping NotificationCompletion, name: String) {
        storedObserver[name, default: [WeakModelWrapper: NotificationCompletion]()] [WeakModelWrapper(object: observer)] =  completion
    }
    
    func removeObserverForName(_ name: String, _ observer: NSObject) {
        storedObserver[name]?.removeValue(forKey: WeakModelWrapper(object: observer) )
    }
}
