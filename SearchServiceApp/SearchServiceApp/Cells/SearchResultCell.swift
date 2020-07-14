import UIKit

class SearchResultCell: UITableViewCell {
    
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectedView = UIView(frame: CGRect.zero)
            selectedView.backgroundColor = UIColor(red: 250/255,
              green: 215/255, blue: 230/255, alpha: 0.5)
            selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
//      print("Reuse!")
    }
    
    // MARK:- Configure Cell Method
    func configure(for result: SearchResultObject) {
      nameLabel.text = result.name

      if let info = result.info {
        artistNameLabel.text = info
      } else {
        artistNameLabel.text = "Unknown"
      }
      artworkImageView.image = UIImage(named: "Placeholder")
        if let urlString = result.imageUrl,
            let smallURL = URL(string: urlString) {
          downloadTask = artworkImageView.loadImage(url: smallURL)
      }
    }

}
