//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import UIKit
import AVKit

class CityListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var currentLocationView: UIView!
    @IBOutlet weak var cityCurrentLocationLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var currentLocationCelsiusLabel: UILabel!
    @IBOutlet weak var currentLocationVideoView: UIView!
    private let viewModel = CityListViewModel()
    var player : AVPlayer!
    var playerLayer : AVPlayerLayer?
    var playerLooper: AVPlayerLooper?
    var playerItem: AVPlayerItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        getWetherByCurrentLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        currentLocationView.layer.cornerRadius = 12
    }
    
    private func getWetherByCurrentLocation() {
        viewModel.getWeatherByCurrentLocation { [weak self] weather, error in
            DispatchQueue.main.async { [weak self] in
                if let error {
                    if let weatherError = error as? WeatherError {
                        self?.handleWeatherError(weatherError)
                    } else {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(alert, animated: true)
                    }
                } else if let weather {
                    self?.updateCurrentLocationInformation(weather)
                }
            }
        }
    }
    
    private func subscribe() {
        viewModel.getUpdateSubscribe { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private func handleWeatherError(_ weatherError: WeatherError) {
        switch weatherError {
        case .badDecode:
            let alert = UIAlertController(title: "Error", message: weatherError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        case .locationDecline:
            cityCurrentLocationLabel.text = "No access to location"
            let alert = UIAlertController(title: "Error", message: weatherError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "Settings", style: .default, handler: { _ in
                guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settings)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(alert, animated: true)
        }
    }
    
    private func updateCurrentLocationInformation(_ weather: WeatherResponse) {
        cityCurrentLocationLabel.text = weather.name
        weatherTypeLabel.text = weather.weather.first?.description
        currentLocationCelsiusLabel.text = String(Int(weather.main.temp ?? 0.0)) + "°C"
        if let icon = weather.weather.first?.icon {
            configureWeatherConditionVideo(icon: icon)
        }
    }
    private func configureWeatherConditionVideo(icon: String) {
        guard let path = Bundle.main.path(forResource: icon, ofType:"mp4") else { return }
        player = AVQueuePlayer()
        playerLayer = AVPlayerLayer(player: self.player)
        playerItem = AVPlayerItem(url: URL(fileURLWithPath: path))
        playerLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLooper = AVPlayerLooper(player: self.player as! AVQueuePlayer, templateItem: self.playerItem!)
        
        currentLocationVideoView.layer.addSublayer(self.playerLayer!)
        self.playerLayer?.frame = self.currentLocationVideoView.bounds
        self.player.play()
        UIView.animate(withDuration: 1, delay: 0.3, options: [.allowUserInteraction], animations: { () -> Void in
            self.currentLocationVideoView.alpha = 0.75
        })
    }
}

extension CityListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherCell = tableView.dequeueReusableCell(withIdentifier: CityWeatherTableViewCell.identifier, for: indexPath) as? CityWeatherTableViewCell else { return UITableViewCell() }
        let cityModel = viewModel.cityList[indexPath.row]
        weatherCell.cityNameLabel.text = cityModel.cityName
        weatherCell.celsiusValueLabel.text = String(Int(cityModel.temp)) + "°C"
        weatherCell.weatherTypeLabel.text = cityModel.weatherType
        if let icon = cityModel.iconString {
            weatherCell.configureBackgroundColor(icon: icon)
            weatherCell.configureWeatherConditionVideo(icon: icon)
        }
        return weatherCell
    }
}
