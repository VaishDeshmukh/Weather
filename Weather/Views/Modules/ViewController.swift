//
//  ViewController.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 18/3/21.
//

import UIKit

class ViewController: UIViewController {


    //MARK: Outlets & Actions
    @IBOutlet weak var tableView: UITableView!
    @IBAction func didPressAddBtn(_ sender: UIButton) {
    }

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
