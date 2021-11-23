
import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterBGImageView: UIImageView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var movieID = 0
    var movieDetail: MovieDetail!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        // Do any additional setup after loading the view.
        getMovieDetails()
    }
}
// MARK: - Helper methods -
extension MovieDetailViewController {
    
    private func getMovieDetails() {
        ProgressView.shared.show()
        NetworkManager.shared.getMovieDetails(movieID) { [weak self] (response, status) in
            if status {
                self?.movieDetail = response as? MovieDetail
                DispatchQueue.main.async {
                    ProgressView.shared.hide()
                    self?.tableView.isHidden = false
                    self?.fetchImages()
                    if let movieDetailObj = self?.movieDetail {
                        self?.titleLabel.text = movieDetailObj.title
                    }
                }
            } else {
                
            }
        }
    }
    
    private func fetchImages() {
        
        if let urlStr = self.movieDetail.posterPath, let posterImageUrl = URL(string: imageBaseUrl + urlStr) {
            posterImageView.sd_setImage(with: posterImageUrl) { (image, error, SDImageCacheTypeMemory, url) in
                self.posterBGImageView.image = image
                self.posterImageView.image = image
            }
        }
        if let urlStr = self.movieDetail.backdropPath, let backDropImageUrl = URL(string: imageBaseUrl + urlStr) {
            bgImageView.sd_setImage(with: backDropImageUrl) { (image, error, SDImageCacheTypeMemory, url) in
                self.bgImageView.image = image
            }
        }
    }
    
}

// MARK: - Table view datasource and delegate methods -
extension MovieDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OverViewTableViewCell") as! OverViewTableViewCell
        cell.setCellDetails(withMovieDetails: self.movieDetail)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
