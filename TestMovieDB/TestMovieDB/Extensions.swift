import UIKit

extension UIView {

    func drawShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 6
        self.layer.cornerRadius = 5.0
    }
}

extension Int {
    func minutesToHoursMinutes() -> (hours : Int , leftMinutes : Int) {
        return (self / 60, (self % 60))
    }
}

extension String {

    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let convertedDate = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: convertedDate)
    }

}

