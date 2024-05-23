//
//  OpenWeatherTestApp
//
// Created by Vlad Shchuka on 2024, All rights reserved.
//

import UIKit

final class AddCityViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private let viewModel = AddCityViewModel()
    private var searchTask: DispatchWorkItem? // throttler
}

extension AddCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTask?.cancel()
        let task = DispatchWorkItem { [weak self] in
            let city = searchText; if (city == " " || city == "") { return }
            self?.viewModel.updateList(city: city, didEndLoading: { [weak self] in
                self?.tableView.reloadData()
            })
        }
        self.searchTask = task
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)
    }
}

extension AddCityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "city-cell", for: indexPath)
        cell.textLabel?.text = viewModel.cities[indexPath.row].name ?? "Haven't found anything yet, keep typing"
        return cell
    }
}

extension AddCityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.isUserInteractionEnabled = false // like loader
        viewModel.saveLocation(addCitySearchModel: viewModel.cities[indexPath.row]) {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
}
