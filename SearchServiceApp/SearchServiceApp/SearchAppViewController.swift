import UIKit

class SearchAppViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let searchResultFlipCell = "SearchResultFlipCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
      
    var itunesSearchResults = [ItunesSearchResult]()
    var gitHubSearchResults = [GitHubSearchResult]()
    
    var dataToDisplay: [SearchResultObject] {
        get {
            if segmentedControl.selectedSegmentIndex == 0 {
                return itunesSearchResults
            } else {
                return gitHubSearchResults
            }
        }
    }
    
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()

        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultFlipCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultFlipCell)
        cellNib = UINib(nibName:
            TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
            TableView.CellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier:
            TableView.CellIdentifiers.loadingCell)
        
        let segmentColor = UIColor(red: 215/255, green: 177/255, blue: 197/255, alpha: 1)
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: segmentColor]
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = segmentColor
        } else {
            // Fallback on earlier versions
        }
        segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedControl.setTitleTextAttributes(selectedTextAttributes, for: .highlighted)
        
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
// MARK:- Helper Methods
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Sorry...", message: "Error accessing to the website." +
            " Please try again.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Search Bar Delegare Methods

extension SearchAppViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func performSearch() {
        guard let text = searchBar.text else { return }
        
        if !text.isEmpty {
            searchBar.resignFirstResponder()
            isLoading = true
            tableView.reloadData()
                        
            if segmentedControl.selectedSegmentIndex == 0 {
                DataManager.shared.getITunesResults(text) { [weak self] (error, data) in
                    self?.isLoading = false
                    
                    if error != nil {
                        self?.showNetworkError()
                    } else {
                        self?.itunesSearchResults = data
                        self?.tableView.reloadData()
                    }
                }
            } else {
                DataManager.shared.getGithubResults(text) { [weak self] (error, data) in
                    self?.isLoading = false
                    
                    if error != nil {
                        self?.showNetworkError()
                    } else {
                        self?.gitHubSearchResults = data
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: Table View Delegate and Data Source Methods

extension SearchAppViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else {
            if dataToDisplay.count == 0 {
                return 1
            } else {
                return dataToDisplay.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if isLoading {
          let cell = tableView.dequeueReusableCell(withIdentifier:
              TableView.CellIdentifiers.loadingCell, for: indexPath)

          let spinner = cell.viewWithTag(100) as!
                        UIActivityIndicatorView
          spinner.startAnimating()
          return cell
        } else if dataToDisplay.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier:
            TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        } else {
            let identifier = indexPath.row % 2 == 0 ? TableView.CellIdentifiers.searchResultCell : TableView.CellIdentifiers.searchResultFlipCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! SearchResultCell
            let searchResult = dataToDisplay[indexPath.row]
            cell.nameLabel.text = searchResult.name
            cell.configure(for: searchResult)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
         didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView,
         willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if itunesSearchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}
