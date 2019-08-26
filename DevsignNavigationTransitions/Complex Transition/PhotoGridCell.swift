import Photos
import UIKit

public class PhotoGridCell: UICollectionViewCell {
    static let identifier = "PhotoGridCell"

    private let imageView = UIImageView(frame: .zero)
    private let selectedView: UIView

    public override init(frame: CGRect) {
        selectedView = UIView()

        super.init(frame: frame)

        selectedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        selectedView.isHidden = true

        accessibilityIgnoresInvertColors = true

        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIgnoresInvertColors = true
        imageView.clipsToBounds = true

        contentView.addSubview(selectedView)
        contentView.bringSubviewToFront(selectedView)

        isAccessibilityElement = true
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        isHidden = false
        imageView.image = nil
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = contentView.bounds
        selectedView.frame = contentView.bounds
    }

    public var image: UIImage? {
        return imageView.image
    }

    public func setHighlighted(_ highlighted: Bool) {
        selectedView.isHidden = !highlighted
    }

    public var asset: PHAsset? {
        didSet {
            setImage(image: nil, fromAsset: asset)
        }
    }

    public func setImage(image: UIImage?, fromAsset: PHAsset?) {
        // Clear out the imageView if we don't have assets.
        guard
            let asset = self.asset,
            let fromAsset = fromAsset
        else {
            imageView.image = nil
            return
        }

        // If it's just that the IDs mismatch,
        // that's because image loading is asynchronous.
        // Bail out so we don't get glitchy!
        guard asset.localIdentifier == fromAsset.localIdentifier else {
            return
        }

        imageView.image = image
    }
}
