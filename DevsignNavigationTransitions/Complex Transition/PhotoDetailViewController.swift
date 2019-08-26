import Cartography
import Photos
import UIKit

class PhotoDetailViewController: UIViewController {
    private let asset: PHAsset
    private let imageView = UIImageView()
    private let imageManager = PHCachingImageManager()

    init(asset: PHAsset) {
        self.asset = asset

        super.init(nibName: nil, bundle: nil)

        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.accessibilityIgnoresInvertColors = true
        view.backgroundColor = .white

        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.deliveryMode = .opportunistic
        imageManager.requestImage(
            for: asset,
            targetSize: view.bounds.size.pixelSize,
            contentMode: .aspectFit,
            options: imageRequestOptions
        ) { image, _ in
            self.imageView.image = image
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Photo Detail"

        view.addSubview(imageView)
        constrain(imageView) {
            $0.edges == $0.superview!.edges
        }

        configureDismissGesture()
    }

    private let dismissPanGesture = UIPanGestureRecognizer()
    public var isInteractivelyDismissing: Bool = false
    public weak var transitionController: PhotoDetailInteractiveDismissTransition?

    private func configureDismissGesture() {
        view.addGestureRecognizer(dismissPanGesture)
        dismissPanGesture.addTarget(self, action: #selector(dismissPanGestureDidChange(_:)))
    }

    @objc private func dismissPanGestureDidChange(_ gesture: UIPanGestureRecognizer) {
        // インタラクティブに却下するかどうかを決定し、Navigation Controllerに通知します。
        switch gesture.state {
        case .began:
            isInteractivelyDismissing = true
            navigationController?.popViewController(animated: true)
        case .cancelled, .failed, .ended:
            isInteractivelyDismissing = false
        case .changed, .possible:
            break
        @unknown default:
            break
        }

        // 画面遷移コントローラーも更新したい！
        transitionController?.didPanWith(gestureRecognizer: gesture)
    }
}

extension PhotoDetailViewController: PhotoDetailTransitionAnimatorDelegate {
    func transitionWillStart() {
        imageView.isHidden = true
    }

    func transitionDidEnd() {
        imageView.isHidden = false
    }

    func referenceImage() -> UIImage? {
        return imageView.image
    }

    func imageFrame() -> CGRect? {
        let rect = CGRect.makeRect(aspectRatio: imageView.image!.size, insideRect: imageView.bounds)
        return rect
    }
}
