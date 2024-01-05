//
//  ConfigWindowUI.swift
//  iosDev
//
//  Created by kingdee on 2024/1/5.
//

import UIKit

@objcMembers class ConfigWindowUI: NSObject {
    
    class func configRootWindow(_ window: UIWindow) {
        
        let tabbar = UITabBarController()
        configTabbarAppearance(tabbar)
        configTabbarChildVC(tabbar)
//        let rootNav = BaseNavigationController(rootViewController: tabbar)
//        tabbar.navigationController?.setNavigationBarHidden(true, animated: false)
//        configNavAppearance(rootNav)
        window.rootViewController = tabbar
    }
    
    fileprivate class func configNavAppearance(_ nav: UINavigationController) {
        let bar = nav.navigationBar
        let color = UIColor(hex: "#4598F0")
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18.0)]
        let navBarAppear = bar.standardAppearance
        navBarAppear.backgroundColor = color
        navBarAppear.titleTextAttributes = textAttributes
        bar.standardAppearance = navBarAppear
        bar.scrollEdgeAppearance = navBarAppear
        bar.tintColor = UIColor.white
    }
    
    fileprivate class func configTabbarAppearance(_ tabbar: UITabBarController) {
        let bar = tabbar.tabBar
        let appearance = UITabBarAppearance()
//        appearance.shadowImage = nil
//        appearance.shadowColor = nil
        let mainColor = UIColor(hex: "#4598F0")
        let normalColor = UIColor(hex: "#D1D1D1")
        appearance.backgroundColor = UIColor(hex: "#FFFFFF")
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: normalColor,
                                                                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 8.0)
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor,
                                                                           NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17.0)]
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 8.0)
        appearance.stackedLayoutAppearance.selected.iconColor = mainColor
        if #available(iOS 15.0, *) {
            bar.scrollEdgeAppearance = appearance
        }
        bar.standardAppearance = appearance
        bar.isTranslucent = false
    }
    
    fileprivate class func configTabbarChildVC(_ tabbar: UITabBarController) {
        let items: [(vc: UIViewController, title: String, normalImg: String, selectImg: String)] = [
            (MainVC(), "首页", "tray", "tray.fill"),
            (SecondVC(), "页二", "folder", "folder.fill"),
            (ThirdVC(), "页三", "paperplane", "paperplane.fill")]
        var vcList: [UIViewController] = []
        items.forEach { item in
            let barItem = UITabBarItem(title: item.title, image:UIImage(systemName: item.normalImg), selectedImage: UIImage(systemName: item.selectImg))
            item.vc.tabBarItem = barItem
            let nav = BaseNavigationController(rootViewController: item.vc)
            configNavAppearance(nav)
            item.vc.navigationItem.title = item.title
            vcList.append(nav)
        }
        tabbar.setViewControllers(vcList, animated: false)
    }
}
