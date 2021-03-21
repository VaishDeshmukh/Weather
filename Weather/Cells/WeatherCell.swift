//
//  WeatherInfoCellTableViewCell.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 19/3/21.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        imgView.setImage(imgView.image, animated: true)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
extension UIImageView{
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.image = image
        }, completion: nil)
    }
}
