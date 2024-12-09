//
//  AddPlaylistViewController.swift
//  Spotify
//
//  Created by Admin on 08/12/24.
//

import UIKit

class AddPlaylistViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true

        bgView.clipsToBounds = true
        bgView.layer.cornerRadius = 10
        bgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        bgView.layer.masksToBounds = true

        textField.becomeFirstResponder()
        
        confirmBtn.layer.cornerRadius = confirmBtn.frame.height / 2
        confirmBtn.layer.masksToBounds = true
        
        hideKeyboard()
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - IBAction
    @IBAction func confirmBtnAction(_ sender: Any) {
        textField.endEditing(true)
        if !(textField.text ?? "").isEmpty {
            storePlaylistName()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let childVC = storyboard.instantiateViewController(withIdentifier: "PlaylistViewController") as? PlaylistViewController
            childVC?.playlistName = textField.text ?? ""
            //        self.navigationController?.pushViewController(childVC!, animated: true)
            childVC?.view.frame = CGRect(x: 0, y: -65, width: self.view.bounds.width, height: self.view.bounds.height)// self.view.bounds
            self.addChild(childVC!)
            self.view.addSubview(childVC?.view ?? UIView())
            childVC?.didMove(toParent: self)
            self.view.layoutIfNeeded()
            childVC?.view.layoutIfNeeded()
            childVC?.view.layoutSubviews()
        } else {
            AppHelper.sharedInstance.showSimpleOKAlert(title: "Error", msg: "Please Enter Playlist Name.", viewController: self)
        }
    }
}
// MARK: - User Define Methods
extension AddPlaylistViewController {
    func storePlaylistName() {
        let data: Playlist = Playlist(name: textField.text ?? "")
        AppHelper.sharedInstance.storePlaylistData(data: [data])
    }
}
