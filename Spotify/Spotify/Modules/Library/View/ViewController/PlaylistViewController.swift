//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Admin on 08/12/24.
//

import UIKit

class PlaylistViewController: UIViewController {
   
    // MARK: - IBOutlet
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var songCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var libraryTabBarItem: UITabBarItem!
    
    // MARK: - Variable
    var playlistName = ""
    private var songArray: [Result] = []
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpUI()
    }

    // MARK: - IBAction
    @IBAction func backBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let childVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController ?? UIViewController()
        self.navigationController?.setViewControllers([childVC], animated: false)
    }
    @IBAction func addBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let childVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController
        childVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)// self.view.bounds
        childVC?.delegate = self
        self.addChild(childVC!)
        self.view.addSubview(childVC?.view ?? UIView())
        childVC?.didMove(toParent: self)
    }
}
// MARK: - User Defines
extension PlaylistViewController {
    private func setUpUI() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        playlistNameLabel.text = playlistName
        songCountLabel.text = "\(songArray.count) songs"
        bgView.backgroundColor = .black
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor().hexStringToUIColor(hex: "#261f64").cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0 , 0.5]
        gradient.startPoint = CGPoint(x : 0.0, y : 0)
        gradient.endPoint = CGPoint(x :0.0, y: 0.5) // you need to play with 0.15 to adjust gradient vertically
        gradient.frame = bgView.bounds
        bgView.layer.insertSublayer(gradient, at: 0)
        
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        tabbar.delegate = self
        tabbar.barTintColor = .black
        tabbar.backgroundColor = .black
        tabbar.selectedItem = libraryTabBarItem
    }
}
// MARK: - UITableViewDataSource
extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        cell.titleLabel.text = songArray[indexPath.row].collectionName
        cell.subTitleLabel.text = songArray[indexPath.row].trackName
        if let url = URL(string: songArray[indexPath.row].artworkUrl100 ?? "") {
            url.getData { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                // always update the UI from the main thread
                DispatchQueue.main.async() {
                    cell.imgView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
// MARK: - SearchDelegate
extension PlaylistViewController: SearchDelegate {
    func loadSearchPlaylistResult(data: [Result]) {
        self.songArray.append(contentsOf: data)
        songCountLabel.text = "\(songArray.count) songs"
        tableView.reloadData()
        AppHelper.sharedInstance.addDataForPlaylist(result: data, name: playlistName)
    }
}
// MARK: - UITabBarDelegate
extension PlaylistViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let childVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController ?? UIViewController()
            self.navigationController?.setViewControllers([childVC], animated: false)
        }
    }
}
