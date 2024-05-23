//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import UIKit
import AVKit

final class CityWeatherTableViewCell: UITableViewCell {
    static let identifier = "tableViewCell-weatherList"
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var celsiusValueLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var videoView: UIView!
    
    var player : AVPlayer!
    var playerLayer : AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    var playerItem: AVPlayerItem?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainView.layer.cornerRadius = 12
    }
    
    func configureBackgroundColor(icon: String) {
        switch icon {
        case "01d":
            mainView.backgroundColor = #colorLiteral(red: 0.1113159284, green: 0.5214003325, blue: 0.9103012681, alpha: 1)
        case "02d", "03d", "04d", "unknown":
            mainView.backgroundColor = #colorLiteral(red: 0.22819677, green: 0.5419401526, blue: 0.7971643806, alpha: 1)
        case "09d","09n", "10d","10n", "13d", "13n":
            mainView.backgroundColor = #colorLiteral(red: 0.1830025315, green: 0.3757502437, blue: 0.5348874927, alpha: 1)
        case "50d":
            mainView.backgroundColor = #colorLiteral(red: 0.2699401379, green: 0.5616410375, blue: 0.7918332219, alpha: 1)
        case "01n", "02n", "03n", "04n":
            mainView.backgroundColor = #colorLiteral(red: 0.03176918998, green: 0.1420978308, blue: 0.28448385, alpha: 1)
        case "11d", "11n":
            mainView.backgroundColor = #colorLiteral(red: 0.149156034, green: 0.3194305599, blue: 0.5500941873, alpha: 1)
        case "50n":
            mainView.backgroundColor = #colorLiteral(red: 0.3737272024, green: 0.5172019601, blue: 0.5837426186, alpha: 1)
        default:
            print("213")
        }
    }
    
    func configureWeatherConditionVideo(icon: String) {
        
        guard let path = Bundle.main.path(forResource: icon, ofType:"mp4") else { return }
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: self.player)
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLooper = AVPlayerLooper(player: self.player as! AVQueuePlayer, templateItem: self.playerItem!)
        
        videoView.layer.addSublayer(self.playerLayer!)
        self.playerLayer?.frame = self.videoView.bounds
        self.player.play()
        UIView.animate(withDuration: 1, delay: 0.3, options: [.allowUserInteraction], animations: { () -> Void in
            self.alpha = 0.75
        })
    }
}
