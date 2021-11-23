

import UIKit

class OverViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var overViewDescriptionLabel: UILabel!
    
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var dateGenresLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setCellDetails(withMovieDetails movieDetails: MovieDetail?) {
        if let movieDetailObj = movieDetails, let overViewText = movieDetailObj.overview {
            overViewDescriptionLabel.text = overViewText
            dateGenresLabel.text = movieDetailObj.releaseDate?.getFormattedDate()
            taglineLabel.text = movieDetailObj.tagline ?? ""
            durationLabel.text = String(describing: movieDetailObj.runtime)
            
            let runTime = (movieDetailObj.runtime?.minutesToHoursMinutes()) ?? (0, 0)
            durationLabel.text = "Duration: \(runTime.0)h \(runTime.1)m"
            
            if let genres = movieDetailObj.genres {
                let names = genres.map{ obj -> String in
                    return (obj.name ?? "")
                }.filter{$0 != ""}.joined(separator: ", ")
                
                dateGenresLabel.text = "\(dateGenresLabel.text ?? "")  \(names)"
            }
        }
    }
}
