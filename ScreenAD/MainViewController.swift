//
//  MainViewController.swift
//  ScreenAD
//
//  Created by hothead on 2016. 12. 3..
//  Copyright © 2016년 hothead. All rights reserved.
//

import Foundation

class MainViewController: UIViewController {
    
    @IBOutlet weak var timeIntervalSlider: UISlider!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeIntervalSlider.setValue(0.0, animated: false)
        timeIntervalLabel.text = timeIntervalSlider.displayTimeIntervalString()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    @IBAction func touchUpStartButton(_ sender: UIButton) {
        performSegue(withIdentifier: "PhotoBrowserViewController", sender: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        timeIntervalLabel.text = timeIntervalSlider.displayTimeIntervalString()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PhotoBrowserViewController {
            destVC.setup(fetchInterval: timeIntervalSlider.displayTimeInterval())
        }
    }
}

extension UISlider {
    func displayTimeInterval() -> TimeInterval {
        return Double(self.value * 9.0 + 1)
    }
    
    func displayTimeIntervalString() -> String {
        return "\(Int(self.value * 9.0 + 1))"
    }
}
