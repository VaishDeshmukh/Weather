//
//  ViewController.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 18/3/21.
//

import UIKit

class WeatherListViewController: UIViewController {


    //MARK: Outlets & Actions
    @IBOutlet weak var tableView: UITableView!
    @IBAction func didPressAddBtn(_ sender: UIButton) {

        let storyboard: UIStoryboard = UIStoryboard(name: "SearchView", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "destinationVC") as! SearchWeatherViewController
        vc.modalPresentationStyle = .automatic
        vc.delegate = self

        present(vc, animated: true, completion: nil)
    }

    //MARK: Properties

    let viewModel = WeatherListViewModel()
    var items = [ WeatherEntity]()

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        viewModel.initialSetup()
        viewModel.delegate = self
        tableView.tableFooterView = UIView()

        // Do any additional setup after loading the view.
    }

    func registerCells() {
        let infoCell = UINib(nibName: "WeatherCell", bundle: Bundle.main)
        tableView.register(infoCell, forCellReuseIdentifier: "cell")
    }
}

extension WeatherListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherCell

        let item = items[indexPath.row]

        cell.cityName.text = item.associatedCity()
        cell.tempLbl.text = item.main?.assocoatedTemp()
        cell.imgView.image = item.weather?.first?.dayOrNightImg()
        cell.timeLbl.text = item.associatedTime()
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
    }
}

extension WeatherListViewController: WeatherInfoListProtocol {
    func getList(input: [WeatherEntity]) {
        self.items = input
        self.tableView.reloadData()
    }
}

extension WeatherListViewController: SearchWeatherViewDelegate {
    func selectedCity(city: WeatherEntity) {
        self.items.append(city)
        self.tableView.reloadData()
    }
}
