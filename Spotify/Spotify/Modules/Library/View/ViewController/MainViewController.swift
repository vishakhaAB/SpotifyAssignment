//
//  ViewController.swift
//  Spotify
//
//  Created by Admin on 08/12/24.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tabBarView: UITabBar!
    @IBOutlet weak var libraryTabBarItem: UITabBarItem!
    
    // MARK: - Variables
    private var childVC: LibraryViewController?
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        tabBarView.delegate = self
        tabBarView.selectedItem = libraryTabBarItem
        tabBar(tabBarView, didSelect: libraryTabBarItem)
        self.view.layoutIfNeeded()
    }
}

// MARK: - UITabBarDelegate
extension MainViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        childVC?.view.removeFromSuperview()
        if item.tag == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            childVC = storyboard.instantiateViewController(withIdentifier: "LibraryViewController") as? LibraryViewController ?? LibraryViewController()
            childVC?.view.frame = self.contentView.bounds
            childVC?.delegate = self
            let cview = childVC?.view
            self.addChild(childVC!)
            self.contentView.addSubview(cview!)
            childVC?.didMove(toParent: self)
        }
    }
}
// MARK: - LibraryDelegate
extension MainViewController: LibraryDelegate {
    func hideTabBar() {
        self.tabBarView.isHidden = true
    }
    func showTabBar() {
        self.tabBarView.isHidden = false
    }
}
