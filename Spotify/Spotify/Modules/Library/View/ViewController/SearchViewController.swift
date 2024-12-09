//
//  SearchViewController.swift
//  Spotify
//
//  Created by Admin on 08/12/24.
//

import UIKit

protocol SearchDelegate {
    func loadSearchPlaylistResult(data: [Result])
}

class SearchViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentSearchLabel: UILabel!
    @IBOutlet weak var tableViewTopContraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var delegate: SearchDelegate?
    private var viewModel: LibraryViewModel?
    
    // MARK: - ViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        callViewModel()
        setUpUI()
        self.view.layoutIfNeeded()
    }
}
// MARK: - User Define Methods
extension SearchViewController {
    private func callViewModel() {
        viewModel = LibraryViewModel()
    }
    private func setUpUI() {
        searchBar.tintColor = .white
        searchBar.delegate = self
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            
            textfield.backgroundColor = UIColor().hexStringToUIColor(hex: "#282828")
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
            
            textfield.textColor = UIColor.white
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .white
            }
        }
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        recentSearchLabel.isHidden = true
        searchBar.becomeFirstResponder()
    }
    func loadRecentSearch() {
        if (searchBar.text ?? "").isEmpty {
            recentSearchLabel.isHidden = false
            let recentSerchKey = UserDefaults.standard.string(forKey: RECENT_SEARCH_KEY) ?? ""
            viewModel?.callSearchAPI(searchKey: recentSerchKey) { resultArray, error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    func hideRecentSearch() {
        recentSearchLabel.isHidden = true
        tableViewTopContraint.constant = 20
    }
    func callSearchAPIMethod(searchText: String) {
        hideRecentSearch()
        viewModel?.callSearchAPI(searchKey: searchText) { resultArray, error in
            if error == nil {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        loadRecentSearch()
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        callSearchAPIMethod(searchText: searchBar.text ?? "")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UserDefaults.standard.set(searchBar.text, forKey: RECENT_SEARCH_KEY)
        callSearchAPIMethod(searchText: searchBar.text ?? "")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UserDefaults.standard.set(searchBar.text, forKey: RECENT_SEARCH_KEY)
        callSearchAPIMethod(searchText: searchBar.text ?? "")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.removeFromSuperview()
        if !(searchBar.text ?? "").isEmpty {
            delegate?.loadSearchPlaylistResult(data: viewModel?.searchResultArray ?? [])
        }
    }
}
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchResultArray.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        if viewModel?.searchResultArray.count ?? 0 > indexPath.row, let data = viewModel?.searchResultArray[indexPath.row] {
            cell.titleLabel.text = data.collectionName
            cell.subTitleLabel.text = data.trackName
            cell.leftBtn.isHidden = true
            if let url = URL(string: data.artworkUrl100 ?? "") {
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
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.removeFromSuperview()
        let searchValue = viewModel?.searchResultArray ?? []
        if indexPath.row < searchValue.count {
            let data = searchValue[indexPath.row]
            delegate?.loadSearchPlaylistResult(data: [data])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
