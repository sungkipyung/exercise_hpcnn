//
//  PhotoBrowserViewController.swift
//  ScreenAD
//
//  Created by hothead on 2016. 12. 3..
//  Copyright © 2016년 hothead. All rights reserved.
//

import UIKit

class PhotoBrowserViewController: UIViewController {
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var frontImageView: UIImageView!
    
    fileprivate var nextIsFront = false
    
    private var imageSource: ImageSource?
    
    private var fetchInterval: TimeInterval = 1.0
    
    func setup(fetchInterval: TimeInterval) {
        self.fetchInterval = fetchInterval
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageSource = ImageSource(fetchInterval: self.fetchInterval)
        imageSource.delegate = self
        
        self.imageSource = imageSource
        imageSource.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.imageSource?.stop()
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}

extension PhotoBrowserViewController: ImageSourceDelegate {
    func imageSourceDidStartToFetchImage(_ source: ImageSource) {
        
    }
    
    func imageSourceDidEndFetchImage(_ source: ImageSource) {
    }
    
    func imageSourceDidStop(_ source: ImageSource) {
        
    }
    
    func imageSource(_ source: ImageSource, pushImage: UIImage) {
        if nextIsFront {
            frontImageView.isHidden = false
            frontImageView.alpha = 0.0
            frontImageView.image = pushImage
            self.view.bringSubview(toFront: frontImageView)
        } else {
            backImageView.isHidden = false
            backImageView.image = pushImage
            backImageView.alpha = 0.0
            self.view.bringSubview(toFront: backImageView)
        }
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let sSelf = self else { return }
            
            if sSelf.nextIsFront {
                sSelf.frontImageView.alpha = 1.0
                sSelf.backImageView.alpha = 0.0
            } else {
                sSelf.frontImageView.alpha = 0.0
                sSelf.backImageView.alpha = 1.0
            }
        })
        nextIsFront = !nextIsFront
    }
}
