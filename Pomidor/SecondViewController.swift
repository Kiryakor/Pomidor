//
//  SecondViewController.swift
//  Pomidor
//
//  Created by KIRILL on 06.08.2021.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var discriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var model: Apple?
    var activeIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let model = model else { return }
        backButton.isHidden = true
        nextButton.isHidden = model.content.isEmpty
        self.view.backgroundColor = .white
        self.discriptionLabel.text = model.content[activeIndex].discription
        self.imageView.downloadedFrom(link: model.content[activeIndex].image)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        activeIndex += 1
        guard let model = model else { return }
        if activeIndex < model.content.count {
            self.discriptionLabel.text = model.content[activeIndex].discription
            self.imageView.downloadedFrom(link: model.content[activeIndex].image)
            backButton.isHidden = false
            nextButton.isHidden = model.content.count > activeIndex
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        activeIndex -= 1
        guard let model = model else { return }
        if activeIndex >= 0 {
            self.discriptionLabel.text = model.content[activeIndex].discription
            self.imageView.downloadedFrom(link: model.content[activeIndex].image)
            backButton.isHidden = activeIndex == 0
            nextButton.isHidden = false
        }
    }
}

extension UIImageView {
   
   func downloadedFrom(link:String) {
    guard let url = URL(string: link) else { return }
    URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
      guard let data = data , error == nil, let image = UIImage(data: data) else { return }
      DispatchQueue.main.async { () -> Void in
        self.image = image
      }
    }).resume()
  }
  
}
