
import UIKit

class SearchResultFlipCell: UITableViewCell {
    
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

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
        func configure(for result: ItunesSearchResult) {
          nameLabel.text = result.name

          if result.info.isEmpty {
            artistNameLabel.text = "Unknown"
          } else {
            artistNameLabel.text = String(format: "%@ (%@)",
                                   result.info, result.type)
          }
          artworkImageView.image = UIImage(named: "Placeholder")
          if let smallURL = URL(string: result.imageSmall) {
              downloadTask = artworkImageView.loadImage(url: smallURL)
          }
        }

}
