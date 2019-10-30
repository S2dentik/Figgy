import UIKit
import AVKit

protocol RandomGifViewInput: class {
    func play(_ gif: Gif)
    func pop()
}

final class RandomGifViewController: UIViewController, StoryboardInstantiable {
    static let storyboardName = "RandomGif"

    var gif: Gif?
    var output: RandomGifViewOutput?

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()

        view.addSubview(indicator)
        [
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ].forEach { c in
                c.constant = 0
                c.isActive = true
        }

        return indicator
    }()

    lazy var playerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
    private let player = AVPlayer()
    private var playerPlayingObservation: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.addSublayer(playerLayer)
        loop()
        setupActivityIndicator()
        gif.map(play)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        playerLayer.frame = view.bounds
    }

    @objc private func viewTapped() {
        output?.viewTapped()
    }

    private func loop() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem, queue: .main) { [weak self] _ in
                                                self?.player.seek(to: .zero)
                                                self?.player.play()
        }
    }

    private func setupActivityIndicator() {
        activityIndicator.isHidden = false
        playerPlayingObservation = player.observe(\.rate, options: .new) { [weak self] _, rate in
            guard let rate = rate.newValue else { return }
            UI { self?.activityIndicator.isHidden = rate > 0 }
        }
    }
}

extension RandomGifViewController: RandomGifViewInput {
    func play(_ gif: Gif) {
        player.replaceCurrentItem(with: AVPlayerItem(url: gif.videoURL))
        player.play()
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
}
