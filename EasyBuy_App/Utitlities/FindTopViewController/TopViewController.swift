//
//  TopViewController.swift
//  EasyBuy_App
//
//  Created by Влад Лялькін on 16.08.2024.
//

import UIKit

final class TopViewController {
    private init() {}
    
    @MainActor
    static func find(controller: UIViewController? = nil) -> UIViewController? {
        var controller = controller
        
        if controller == nil, let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            controller = windowScene.windows.first?.rootViewController
        }
        
        if let navigationController = controller as? UINavigationController {
            return find(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return find(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return find(controller: presented)
        }
        
        return controller
    }
}
