//
//  LibraryViewController.swift
//  Spotify
//
//  Created by Admin on 08/12/24.
//

import UIKit
protocol LibraryDelegate {
    func hideTabBar()
    func showTabBar()
}
class LibraryViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var playlistLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mostRecentView: UIView!
    
    // MARK: - Variable
    var delegate: LibraryDelegate?
    private var isListEnable = true
    private var viewModel: LibraryViewModel?
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        callViewModel()
        setUpUi()
        self.view.layoutIfNeeded()
    }
    
    @IBAction func switchBtnAction(_ sender: Any) {
        isListEnable = !isListEnable
        if isListEnable {
            mostRecentView.isHidden = true
            collectionView.isHidden = true
            tableView.isHidden = false
            switchBtn.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
            tableView.reloadData()
        } else {
            mostRecentView.isHidden = false
            collectionView.isHidden = false
            tableView.isHidden = true
            switchBtn.setImage(UIImage(systemName: "list.bullet"), for: .normal)
            collectionView.reloadData()
        }
    }
    // MARK: - IBActions
    @IBAction func addBtnAction(_ sender: Any) {
        delegate?.hideTabBar()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let childVC = storyboard.instantiateViewController(withIdentifier: "CreatePlaylistViewController") as? CreatePlaylistViewController
        childVC?.view.frame = CGRect(origin: view.frame.origin, size: CGSize(width: view.frame.width, height: view.frame.height + 80))
        childVC?.delegate = delegate
        self.addChild(childVC!)
        self.view.addSubview(childVC?.view ?? UIView())
        childVC?.didMove(toParent: self)
    }
}
// MARK: - User Define Methods
extension LibraryViewController {
    private func callViewModel() {
        viewModel = LibraryViewModel()
    }
    private func setUpUi() {
        self.imgView.layer.cornerRadius = 20
        addBtn.setTitle("", for: .normal)
        playlistLabel.layer.borderWidth = 1
        playlistLabel.layer.cornerRadius = 17
        playlistLabel.layer.borderColor = UIColor.white.cgColor
        
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LibraryTableViewCell", bundle: nil), forCellReuseIdentifier: "LibraryTableViewCell")

        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "LibraryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LibraryCollectionViewCell")

        collectionView.isHidden = true
        mostRecentView.isHidden = true
        switchBtn.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
    }
}
// MARK: - UITableViewDataSource
extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.playlistArray.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LibraryTableViewCell", for: indexPath) as? LibraryTableViewCell else {
            return UITableViewCell()
        }
        if let playlist = viewModel?.playlistArray[indexPath.row] {
            cell.nameLabel.text = playlist.name
            cell.songLabel.text = "\(playlist.resultArray.count) songs"
            cell.dotLabel.layer.cornerRadius = 1
            setGridImageView(cell: cell, playlist: playlist)
        }
        return cell
    }
    private func setGridImageView(cell: LibraryTableViewCell, playlist: Playlist) {
        if playlist.resultArray.count > 0 {
            if let url = URL(string: playlist.resultArray[0].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView1.image = UIImage(data: data)
                    }
                }
            }
        }
        if playlist.resultArray.count > 1 {
            if let url = URL(string: playlist.resultArray[1].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView2.image = UIImage(data: data)
                    }
                }
            }
        }
        if playlist.resultArray.count > 2 {
            if let url = URL(string: playlist.resultArray[2].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView3.image = UIImage(data: data)
                    }
                }
            }
        }
        if playlist.resultArray.count > 3 {
            if let url = URL(string: playlist.resultArray[3].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView4.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
// MARK: - UICollectionViewDataSource UICollectionViewDelegateFlowLayout
extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.playlistArray.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCollectionViewCell", for: indexPath) as? LibraryCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let playlist = viewModel?.playlistArray[indexPath.row] {
            cell.nameLabel.text = playlist.name
            cell.songLabel.text = "\(playlist.resultArray.count) songs"
            cell.dotLabel.layer.cornerRadius = 1
            setGridImageView(cell: cell, playlist: playlist)
        }
        return cell
    }
    
    private func setGridImageView(cell: LibraryCollectionViewCell, playlist: Playlist) {
        if playlist.resultArray.count > 0 {
            if let url = URL(string: playlist.resultArray[0].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView1.image = UIImage(data: data)
                    }
                }
            }
        }
        if playlist.resultArray.count > 1 {
            if let url = URL(string: playlist.resultArray[1].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView2.image = UIImage(data: data)
                    }
                }
            }
        }
        if playlist.resultArray.count > 2 {
            if let url = URL(string: playlist.resultArray[2].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView3.image = UIImage(data: data)
                    }
                }
            }
        }
        if playlist.resultArray.count > 3 {
            if let url = URL(string: playlist.resultArray[3].artworkUrl100 ?? "") {
                url.getData { data, response, error in
                    guard let data = data, error == nil else { return }
                    print(response?.suggestedFilename ?? url.lastPathComponent)
                    print("Download Finished")
                    // always update the UI from the main thread
                    DispatchQueue.main.async() {
                        cell.imgView4.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 8
        return CGSize(width: width, height: width)
    }
}
