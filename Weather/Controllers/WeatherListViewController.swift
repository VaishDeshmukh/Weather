//
//  ViewController.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 18/3/21.
//

import UIKit

class WeatherListViewController: UIViewController {


    //MARK: Outlets & Actions
    @IBOutlet weak var spinner: SpinnerView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func didPressAddBtn(_ sender: UIButton) {

        let storyboard: UIStoryboard = UIStoryboard(name: "SearchView", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "destinationVC") as! SearchWeatherViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self

        present(vc, animated: true, completion: nil)
    }

    //MARK: Properties

    let viewModel = WeatherListViewModel()
    var items = [ WeatherEntity]()
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.color = .red

        registerCells()
        viewModel.initialSetup()

        viewModel.delegate = self
        tableView.tableFooterView = UIView()
        pauseUpdates()
        resumeUpdates()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        pauseUpdates()
    }

    var pollTimer: Timer? = nil
    
    func resumeUpdates() {

        let interval = 5.0
        pollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { [weak self] _ in
            self?.tableView.reloadData()
        })
    }

    func pauseUpdates() {
        pollTimer?.invalidate()
        pollTimer = nil
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
        cell.tempLbl.text = item.main?.temp?.associatedTemp()
        cell.imgView.image = item.getImageForWeatherDetail()
        cell.timeLbl.text = item.timezone?.associatedTimeZone()
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "WeatherDetail", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "weatherDetailViewController") as! WeatherDetailViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.entity = items[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

extension WeatherListViewController: WeatherInfoListProtocol {
    func getList(input: [WeatherEntity]) {
        spinner.startAnimating()
        self.items = input

        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            self.tableView.reloadData()
        }
    }
}

extension WeatherListViewController: SearchWeatherViewDelegate {
    func selectedCity(city: WeatherEntity) {
        self.items.append(city)
        self.tableView.reloadData()
    }
}
