//
//  ViewController.swift
//  CatsForever
//
//  Created by Пользователь on 31.03.2021.
//

import UIKit
import Moya
import Kingfisher

class ViewController: UIViewController {
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var catsImage: UIImageView!
    @IBOutlet weak var barProgress: ProgressBar!
    
    
    var countFired: CGFloat = 0
    var timer: Timer!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 6.0
        scroll.delegate = self
        getCat { [weak self] url in
            self?.catsImage.kf.setImage(with: URL(string: url)!)
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            if self.countFired >= 10 {
                self.countFired = 0
                self.getCat { [weak self] url in
                    self?.catsImage.kf.setImage(with: URL(string: url)!, options: [.memoryCacheExpiration(.expired), .diskCacheExpiration(.expired)])
                }
            } else {
                self.countFired += 0.1
            }
            self.barProgress.progress = self.countFired / 10
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return catsImage
    }
}

extension ViewController: UIScrollViewDelegate {
//    func getCat(closure: ((String) -> Void)? = nil) {
//        guard let url = URL(string: "https://aws.random.cat/meow") else { return }
//        AF.request(url).response { response in
//            guard let data = response.data else { return }
//
//            do {
//                let response = try JSONDecoder().decode(ImageResponse.self, from: data)
//                closure?(response.file)
//
//            } catch {
//                print(error)
//            }
//        }
//    }
    func getCat (closure: ((String) -> Void)? = nil) {
        ApiProvider.request(.getImage) { result in
            switch result {
            case .success (let response):
                do {
                    let response = try JSONDecoder().decode(ImageResponseTwo.self, from: response.data)
                    closure?(response.file)
                    }
                 catch {
                    print (error)
                }
            case .failure (let error):
                print (error)
            }
        }
    }
}

struct ImageResponseTwo: Decodable {
    let file: String
}
