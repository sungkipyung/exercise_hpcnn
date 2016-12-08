//
//  ImageSource.swift
//  ScreenAD
//
//  Created by hothead on 2016. 12. 3..
//  Copyright © 2016년 hothead. All rights reserved.
//

import Foundation

protocol ImageSourceDelegate: class {
    func imageSourceDidStartToFetchImage(_ source: ImageSource)
    func imageSourceDidEndFetchImage(_ source: ImageSource)
    func imageSourceDidStop(_ source: ImageSource)
    func imageSource(_ source: ImageSource, pushImage: UIImage)
}

class ImageSource {
    weak var delegate: ImageSourceDelegate?
    
    static fileprivate let maxCheckerCount = 1000
    fileprivate var checker = Set<String>()
    
    private var yellowCow = YellowCow()
    private var generateImage = false
    private(set) var imageQueue =  [UIImage]()
    
    private var maxTempImageCount = 10
    private var temporaryImages = [UIImage]()
    private var tmpImageIndex = 0
    
    private let sufficientImageQueueCount = 100
    private let fetchInterval: TimeInterval
    
    init(fetchInterval: TimeInterval) {
        self.fetchInterval = fetchInterval
        
        yellowCow.delegate = self
    }
    
    deinit {
        checker.removeAll()
        imageQueue.removeAll()
    }
    
    func start() {
        if generateImage == false {
            generateImage = true
            watchImageQueueCount()
            startPushImage()
        }
    }
    
    func stop() {
        if generateImage == true {
            generateImage = false
        }
    }
    
    
    fileprivate func startPushImage() {
        if generateImage == false {
            return
        }
        
        if let image = nextImage() {
            self.delegate?.imageSource(self, pushImage: image)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + fetchInterval, execute: { [weak self] in
            guard let sSelf = self else { return }
            sSelf.startPushImage()
        })
    }
    
    private func nextImage() -> UIImage? {
        if self.imageQueue.count == 0 { return nil }
        return self.imageQueue.removeFirst()
    }
    
    fileprivate func watchImageQueueCount() {
        if generateImage == false {
            delegate?.imageSourceDidStop(self)
            return
        }
        
        if imageQueue.count < sufficientImageQueueCount {
            self.delegate?.imageSourceDidStartToFetchImage(self)
            yellowCow.work()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
            guard let sSelf = self else { return }
            sSelf.watchImageQueueCount()
        })
    }
    
    
    
    fileprivate func appendImages(_ images: [UIImage]) {
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }       
            sSelf.imageQueue.append(contentsOf: images)
        }
    }
}

extension ImageSource: YellowCowDelegate {
    func yellowCow(_ cow: YellowCow, gotImages imageURLs: [String]) {
        let needToHurry = self.imageQueue.count == 0
        
        DispatchQueue.global().async { [weak self] in
            guard let sSelf = self else { return }
            
            let urls = imageURLs.flatMap { imageURL -> URL? in
                if sSelf.checker.contains(imageURL) {
                    return nil
                }
                
                if sSelf.checker.count > ImageSource.maxCheckerCount {
                    sSelf.checker.removeAll()
                }
                
                sSelf.checker.insert(imageURL)
                
                return URL(string: imageURL)
            }
            
            
            if needToHurry {
                urls.forEach({ (url) in
                    guard let data = try? Data(contentsOf: url) else { return }
                    guard let image = UIImage(data: data) else { return }
                    
                    sSelf.appendImages([image])
                })
            } else {
                let images = urls.flatMap { (url) -> UIImage? in
                    guard let data = try? Data(contentsOf: url) else {
                        return nil
                    }
                    return UIImage(data: data)
                }
                
                sSelf.appendImages(images)
            }
            
            DispatchQueue.main.async {
                sSelf.delegate?.imageSourceDidEndFetchImage(sSelf)
                sSelf.watchImageQueueCount()
            }
            
        }
    }
    
    func yellowCow(_ row: YellowCow, gotError error: Error) {
        // TODO : Reachability Checking & retry
        DispatchQueue.main.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.watchImageQueueCount()
        }
    }
}
