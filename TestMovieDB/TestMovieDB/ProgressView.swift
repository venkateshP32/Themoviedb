import UIKit
import NVActivityIndicatorView

class ProgressView {
    static let shared = ProgressView()
    private init() {}
    var activityIndicatorView: NVActivityIndicatorView?
    var transparentView: UIView?
    
    func show() {
        if let window =  UIApplication.shared.windows.first {
            hide()
            transparentView = UIView()
            transparentView?.frame = UIScreen.main.bounds
            transparentView?.backgroundColor = UIColor.init(white: 0, alpha: 0.6)
            
            
            let contentView = UIView()
            contentView.backgroundColor = UIColor.init(red: 72.0/255.0, green: 75.0/255.0, blue: 77.0/255.0, alpha: 0)
            contentView.layer.cornerRadius = 10
            contentView.clipsToBounds = true
            transparentView?.addSubview(contentView)
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let horizontalConstraint = NSLayoutConstraint(item: contentView, attribute: .centerX, relatedBy: .equal, toItem: transparentView, attribute: .centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: contentView, attribute: .centerY, relatedBy: .equal, toItem: transparentView, attribute: .centerY, multiplier: 1, constant: 0)
            let widthConstraint = NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            let heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            
            NSLayoutConstraint.activate([horizontalConstraint,verticalConstraint,widthConstraint,heightConstraint])
            
            
            activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
                                                            type: .ballSpinFadeLoader)
            activityIndicatorView?.padding = 20
            activityIndicatorView?.color = UIColor.white
            contentView.addSubview(activityIndicatorView!)
            activityIndicatorView?.translatesAutoresizingMaskIntoConstraints = false
            let horizontalCenterConstraint = activityIndicatorView?.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            let verticalCenterConstraint = activityIndicatorView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
            contentView.addConstraints([horizontalCenterConstraint!, verticalCenterConstraint!])
            
            activityIndicatorView?.startAnimating()
            window.addSubview(transparentView!)
        }
    }
    
    func hide() {
        activityIndicatorView?.stopAnimating()
        transparentView?.removeFromSuperview()
    }
}
