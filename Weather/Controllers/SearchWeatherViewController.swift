//
//  SearchWeatherViewController.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 20/3/21.
//

import UIKit

//TODO: add zip codes

class SearchWeatherViewController: UIViewController {

    @IBOutlet weak var searchView: SearchComponentView!
    @IBOutlet weak var tableView: UITableView!

    var listOfCities = [LocationData]()
    var filteredList =  [LocationData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.delegate = self
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
        let item = filteredList[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherCell

        if let name = item.name, let country = item.country {
            cell.cityName.text = name + " , " + country
        }
        cell.tempLbl.isHidden = true
        cell.accessoryType = .none
        return cell
    }

}

