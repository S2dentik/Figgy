import UIKit

final class ImageCollectionViewCell: CollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!

    var image: UIImage? {
        get { imageView.image }
        set {
            contentView.backgroundColor = newValue == nil ? .lightGray : .clear
            imageView.image = newValue
        }
    }

    var onReuse: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        onReuse?()
        onReuse = nil
        image = nil
    }
}
