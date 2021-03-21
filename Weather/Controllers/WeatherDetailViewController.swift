//
//  WeatherDetailViewController.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 22/3/21.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var conditionImgView: UIImageView!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var weatherDesc: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var feelsLikeLbl: UILabel!
    @IBOutlet weak var tempMaxLbl: UILabel!
    @IBOutlet weak var tempMinLbl: UILabel!

    @IBAction func didPressBackBtn(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    var entity = WeatherEntity()

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImg.image = entity.getImageForWeatherDetail()
        if let str = entity.weather?.first?.associatedImageUrl(), let url = URL(string: str) {
                self.conditionImgView.load(url: url)
        }

        cityNameLbl.text = entity.name ?? ""
        weatherDesc.text = entity.weather?.first?.description ?? ""

        if let timezone = entity.timezone?.associatedTimeZone(),
           let sunriseTime = entity.sys?.sunrise,
           let sunsetTime = entity.sys?.sunset {
            sunriseLbl.text = sunTimeCoverter(unixTimeValue: Double(sunriseTime), timezone: timezone)
            sunsetLbl.text = sunTimeCoverter(unixTimeValue: Double(sunsetTime), timezone: timezone)
        }

        humidityLbl.text = entity.main?.getHumidity()
        pressureLbl.text = entity.main?.getPressure()
        windLbl.text = entity.wind?.getWindSpeed()
        feelsLikeLbl.text = entity.main?.feels_like?.associatedTemp()
        tempMaxLbl.text = entity.main?.temp_max?.associatedTemp()
        tempMinLbl.text = entity.main?.temp_min?.associatedTemp()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
