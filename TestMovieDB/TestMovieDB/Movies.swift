import Foundation

struct MoviesList: Codable {
    let page : Int?
    let totalResults : Int?
    let totalPages : Int?
    let results : [Movies]?

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
}

struct Movies : Codable {
	let popularity : Double?
	let voteCount : Int?
	let video : Bool?
	let posterPath : String?
	let id : Int?
	let adult : Bool?
	let backdropPath : String?
	let originalLanguage : String?
	let originalTitle : String?
	let genreIds : [Int]?
	let title : String?
	let voteAverage : Double?
	let overview : String?
	let releaseDate : String?

	enum CodingKeys: String, CodingKey {
		case popularity = "popularity"
		case voteCount = "vote_count"
		case video = "video"
		case posterPath = "poster_path"
		case id = "id"
		case adult = "adult"
		case backdropPath = "backdrop_path"
		case originalLanguage = "original_language"
		case originalTitle = "original_title"
		case genreIds = "genre_ids"
		case title = "title"
		case voteAverage = "vote_average"
		case overview = "overview"
		case releaseDate = "release_date"
	}
}
