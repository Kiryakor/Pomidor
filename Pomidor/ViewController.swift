//
//  ViewController.swift
//  Pomidor
//
//  Created by KIRILL on 06.08.2021.
//

import UIKit
import Firebase

struct AppleHelper {
    let discription: String
    let image: String
}

struct Apple {
    let name: String
    let content: [AppleHelper]
}

class ViewController: UIViewController,
                      UIPickerViewDelegate,
                      UIPickerViewDataSource {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var picker: UIPickerView!
    
    var ref: DatabaseReference!
    
    var content: [Apple] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        picker.dataSource = self
        picker.delegate = self
        
        ref = Database.database().reference()
        ref.getData { [weak self] error, snapshot in
            guard let self = self else { return }
            guard error == nil else { return }
            
            let recipes = snapshot.childSnapshot(forPath: "recipes").children
            
            for item in recipes {
                let name = (item as AnyObject).childSnapshot(forPath: "name").value as? String
                let recipe = (item as AnyObject).childSnapshot(forPath: "recipe").children
                guard let name = name else { return }
                var appleHelper: [AppleHelper] = []
                for rec in recipe {
                    let discription = (rec as AnyObject).childSnapshot(forPath: "discription").value as? String
                    let imagePath = (rec as AnyObject).childSnapshot(forPath: "imagePath").value as? String
                    guard
                        let discription = discription,
                        let imagePath = imagePath
                    else { return }
                    appleHelper.append(AppleHelper(discription: discription, image: imagePath))
                }
                self.content.append(Apple(name: name, content: appleHelper))
            }
            self.picker.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return content.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return content[row].name
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "show") {
            if let nextViewController = segue.destination as? SecondViewController {
                nextViewController.model = content[picker.selectedRow(inComponent: 0)]
            }
        }
    }
}
