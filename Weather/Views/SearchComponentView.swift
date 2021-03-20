//
//  SearchComponentView.swift
//  Weather
//
//  Created by Vaishnavi Deshmukh on 20/3/21.
//

import UIKit

protocol SearchComponentViewDelegate : class {
    func searchTextChanged(to text: String)
    func searchTextCleared()
    func searchPressed(with text: String?)
    func donePressed(with text: String?)
}

class SearchComponentView : UIView {
    @IBOutlet weak var txtSearchField: UITextField!
    @IBOutlet weak var btnSearch: UIButton!

    weak var delegate : SearchComponentViewDelegate? = nil

    @IBAction func searchButtonPressed(_ button: UIButton) {
        delegate?.searchPressed(with: self.txtSearchField.text)
    }

    override func awakeFromNib() {
        txtSearchField.delegate = self
    }
}

extension SearchComponentView : UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.delegate?.searchTextCleared()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard  let text = textField.text else { return false }
        guard let textRange = Range(range, in: text) else { return false }

        let updatedText = text.replacingCharacters(in: textRange, with: string)
        delegate?.searchTextChanged(to: updatedText)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.donePressed(with: textField.text)
    }
}
