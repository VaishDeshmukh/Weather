//
//  SearchWeatherViewController.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 20/3/21.
//

import UIKit

protocol SearchWeatherViewDelegate {
    func selectedCity(city: WeatherEntity)
}

class SearchWeatherViewController: UIViewController {

    @IBOutlet weak var searchView: SearchComponentView!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func didPressCloseBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var listOfCities = [LocationData]()
    var filteredList =  [LocationData]()

    var delegate: SearchWeatherViewDelegate? = nil

    let viewModel = SearchCityViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
        viewModel.delegate = self
        fetchListOfCities()
        registerCells()
    }

    func fetchListOfCities() {
        let data = Manager.shared.staticData.cities
        listOfCities = data.compactMap {LocationData.init($0)}
    }

    func registerCells() {
        let infoCell = UINib(nibName: "WeatherCell", bundle: Bundle.main)
        tableView.register(infoCell, forCellReuseIdentifier: "cell")
    }
}

extension SearchWeatherViewController: SearchComponentViewDelegate {
    func searchTextChanged(to text: String) {}

    func searchTextCleared() {
        filteredList.removeAll()
        tableView.reloadData()
    }

    func searchPressed(with text: String?) {

        //remove the existing entries & start fresh
        filteredList.removeAll()
        
        if let searchText = text,  searchText.count > 3 {
            let result = listOfCities.filter {
                let isCountry = $0.country?.range(of:  searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                let isName = $0.name?.range(of:  searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                return isCountry || isName
            }

            filteredList.append(contentsOf: result)

            self.tableView.reloadData()
        }
    }

    func donePressed(with text: String?) {
        searchPressed(with: text)
    }
}

extension SearchWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherCell
        cell.tempLbl.isHidden = true
        cell.accessoryType = .none
        cell.backgroundColor = .clear

        if filteredList.count > 0 {
            let item = filteredList[indexPath.row]
            if let name = item.name, let country = item.country {
                cell.cityName.text = name + " , " + country
            }
        } else {
            cell.cityName.text = "No results found"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredList.count > 0 {
            let item = filteredList[indexPath.row]
            if let id = item.id {
                viewModel.fetchWeatherResponse(input: String(id))
            }
        }
    }
}

extension SearchWeatherViewController: SearchCityViewDelegate {
    func getCity(city: WeatherEntity) {
        dismiss(animated: true) {
            self.delegate?.selectedCity(city: city)
        }
    }
}
