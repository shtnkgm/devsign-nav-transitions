import UIKit
import Cartography
import Photos

class PhotoDetailViewController: UIViewController {
    private let asset: PHAsset
    private let imageView = UIImageView()
    private let imageManager = PHCachingImageManager()

    init(asset: PHAsset) {
        self.asset = asset

        super.init(nibName: nil, bundle: nil)

        self.imageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = .white
        self.imageView.accessibilityIgnoresInvertColors = true
        self.view.backgroundColor = .white

        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.isNetworkAccessAllowed = true
        imageRequestOptions.deliveryMode = .opportunistic
        self.imageManager.requestImage(
            for: asset,
            targetSize: self.view.bounds.size.pixelSize,
            contentMode: .aspectFit,
            options: imageRequestOptions
        ) { (image, _) in
            self.imageView.image = image
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Photo Detail"

        self.view.addSubview(self.imageView)
        constrain(self.imageView) {
            $0.edges == $0.superview!.edges
        }

        self.configureDismissGesture()
    }

    private let dismissPanGesture = UIPanGestureRecognizer()
    public var isInteractivelyDismissing: Bool = false
    public weak var transitionController: PhotoDetailInteractiveDismissTransition?

    private func configureDismissGesture() {
        self.view.addGestureRecognizer(self.dismissPanGesture)
        self.dismissPanGesture.addTarget(self, action: #selector(dismissPanGestureDidChange(_:)))
    }

    @objc private func dismissPanGestureDidChange(_ gesture: UIPanGestureRecognizer) {
        // インタラクティブに却下するかどうかを決定し、Navigation Controllerに通知します。
        switch gesture.state {
        case .began:
            self.isInteractivelyDismissing = true
            self.navigationController?.popViewController(animated: true)
        case .cancelled, .failed, .ended:
            self.isInteractivelyDismissing = false
        case .changed, .possible:
            break
        @unknown default:
            break
        }

        // 画面遷移コントローラーも更新したい！
        self.transitionController?.didPanWith(gestureRecognizer: gesture)
    }
}

extension PhotoDetailViewController: PhotoDetailTransitionAnimatorDelegate {
    func transitionWillStart() {
        self.imageView.isHidden = true
    }

    func transitionDidEnd() {
        self.imageView.isHidden = false
    }

    func referenceImage() -> UIImage? {
        return self.imageView.image
    }

    func imageFrame() -> CGRect? {
        let rect = CGRect.makeRect(aspectRatio: imageView.image!.size, insideRect: imageView.bounds)
        return rect
    }
}
