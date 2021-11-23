import UIKit
import SDWebImage

class MovieListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBottonConstraint: NSLayoutConstraint!
    var list: [Movies] = []
    var filteredList: [Movies] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    var genres: [Genres] = []
    var pageCount = 1
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeSearchBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        getGenres()
        getMoviesList()
    }
    
    func customizeSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search movie name"
    }
    
    func getMoviesList() {
        NetworkManager.shared.getMovieList(page: pageCount) { [weak self] (response, status) in
            if status {
                if let movieList = response as? MoviesList {
                    self?.totalCount = movieList.totalPages ?? 0
                    self?.list.append(contentsOf: movieList.results ?? [])
                    self?.filteredList = self?.list ?? []
                }
            } else {
                
            }
        }
    }
    
    func getGenres() {
        ProgressView.shared.show()
        NetworkManager.shared.getGenres { [weak self] (response, status) in
            if status {
                self?.genres = (response as! GenresList).genres ?? []
            } else {
                
            }
            DispatchQueue.main.async {
                ProgressView.shared.hide()
            }
        }
    }

    func getGenreForMovie(_ genreIds: [Int]) -> String {
        var genreNames: [String] = []
        for id in genreIds {
            if let str = genres.filter({ $0.id == id }).first?.name {
                genreNames.append(str)
            }
        }
        return genreNames.joined(separator: ", ")
    }
}

// MARK: - Collection view datasource and delegate methods -
extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as! ListCollectionViewCell
        let movie = filteredList[indexPath.row]
        if let urlStr = movie.posterPath, let url = URL(string: imageBaseUrl + urlStr) {
            cell.thumbnailImageView.sd_setImage(with: url) { (image, error, SDImageCacheTypeMemory, url) in
                cell.thumbnailImageView.image = image
            }
        }
        
        cell.titleLabel.text = movie.title
        cell.genreLabel.text = getGenreForMovie(movie.genreIds ?? [])
        cell.popularityLabel.text = "\(movie.popularity!)"
        cell.releaseYearLabel.text = (movie.releaseDate ?? "").getFormattedDate()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = filteredList[indexPath.row]
        let detailVC = self.storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as! MovieDetailViewController
        detailVC.movieID = movie.id ?? 0
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == filteredList.count - 1 && filteredList.count < totalCount {
            if !searchBar.isFirstResponder {
                pageCount += 1
                getMoviesList()
            }
        }
    }
}

// MARK: - Keyboard handling methods -
extension MovieListViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        collectionViewBottonConstraint.constant = -keyboardHeight
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        collectionViewBottonConstraint.constant = 0
        self.view.layoutIfNeeded()
    }
}

// MARK: - Searchbar Delegate methods -
extension MovieListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        self.filteredList = self.list
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.isEmpty ?? false {
            self.filteredList = self.list
        } else {
            let results = list.filter({ ($0.title?.contains(searchText))! })
            self.filteredList = results
        }
    }
}
