//
//  CreatePlaylistViewController.swift
//  Spotify
//
//  Created by Admin on 08/12/24.
//

import UIKit

class CreatePlaylistViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var playlistImgView: UIImageView!
    @IBOutlet weak var playListLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var bottomClickView: UIView!
    
    // MARK: - Varibles
    var delegate: LibraryDelegate?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }
    @objc func createPlaylist(_ sender:UITapGestureRecognizer){
        // do other task
        navigateToAddPlaylist()
    }
}
// MARK: - User Define Function
extension CreatePlaylistViewController {
    private func setUpUI() {
        self.view.backgroundColor = .black.withAlphaComponent(0.7)
        self.navigationController?.navigationBar.isHidden = true
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 10
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bottomView.layer.masksToBounds = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.createPlaylist(_:)))
        self.bottomClickView.addGestureRecognizer(gesture)
        self.view.layoutIfNeeded()
    }
    private func navigateToAddPlaylist() {
        print("Clicked")
        self.view.backgroundColor = .black
        delegate?.showTabBar()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let childVC = storyboard.instantiateViewController(withIdentifier: "AddPlaylistViewController") as? AddPlaylistViewController ?? UIViewController()
        let customView = UIView(frame: self.view.bounds)
        customView.backgroundColor = .black.withAlphaComponent(1)
        self.view.addSubview(customView)
        customView.addSubview(childVC.view)

        childVC.view.frame = self.view.bounds
        self.addChild(childVC)
        
        childVC.didMove(toParent: self)
        self.view.layoutIfNeeded()
        childVC.view.layoutIfNeeded()
        childVC.view.layoutSubviews()

    }
    @objc override func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= (keyboardSize.height - 80)
        }
    }
}
