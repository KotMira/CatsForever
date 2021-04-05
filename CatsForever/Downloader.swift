//
//  Downloader.swift
//  CatsForever
//
//  Created by Пользователь on 31.03.2021.
//

import Moya
import Alamofire
import Kingfisher


class DownloaderCatsWidget {
    func loadImage (completion: ((UIImage) -> Void)? = nil) {
        ApiProvider.request(.getImage) { result in
            switch result {
            case .success (let response):
                do {
                    let response = try JSONDecoder().decode(ImageResponseThree.self, from: response.data)
                    KingfisherManager.shared.retrieveImage(with: URL(string: response.file)!) { result in
                        switch result {
                        case .success(let data):
                            completion?(data.image)
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
                 catch {
                    print (error)
                }
            case .failure (let error):
                print (error)
            }
        }
    }
    
    func loader (completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: "https://aws.random.cat/meow") else { return }
        AF.request(url).response { response in
            guard let data = response.data else { return }
            do {
                let response = try JSONDecoder().decode(ImageResponseThree.self, from: data)
                KingfisherManager.shared.retrieveImage(with: URL(string: response.file)!) { result in
                    switch result {
                    case .success(let data):
                        completion(data.image)
                    case .failure(let error):
                        print(error)
                    }
                }
            } catch {
                print(error)
            }
        }

    }
}
struct ImageResponseThree: Decodable {
    let file: String
}

