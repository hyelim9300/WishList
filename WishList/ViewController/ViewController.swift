//
//  ViewController.swift
//  WishList
//
//  Created by 서혜림 on 4/12/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // MARK: - Properties
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    private var currentProduct: RemoteProduct? = nil {
        didSet {
            guard let currentProduct = self.currentProduct else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = nil
                self.titleLabel.text = currentProduct.title
                self.descriptionLabel.text = currentProduct.description
                self.priceLabel.text = "\(currentProduct.price)$"
            }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: currentProduct.thumbnail), let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.imageView.image = image }
                }
            }
        }
    }
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView! // 스토리보드에서 UIScrollView를 연결해주세요.
    
    // MARK: - Actions
    @IBAction func tappedSaveProductButton(_ sender: UIButton) {
        self.saveWishProduct()
    }
    
    @IBAction func tappedSkipButton(_ sender: UIButton) {
        self.fetchRemoteProduct()
    }
    
    @IBAction func tappedPresentWishList(_ sender: UIButton) {
        guard let nextVC = self.storyboard?
            .instantiateViewController(
                identifier: "WishListViewController"
            ) as? WishListViewController else { return }
        self.present(nextVC, animated: true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchRemoteProduct()
        self.setupRefreshControl()
    }
    
    // MARK: - Methods
//    private func fetchRemoteProduct() {
//        let productID = Int.random(in: 1 ... 100)
//        
//        if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    print("Error: \(error)")
//                } else if let data = data {
//                    do {
//                        let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
//                        self.currentProduct = product
//                    } catch {
//                        print("Decode Error: \(error)")
//                    }
//                }
//            }
//            task.resume()
//        }
//    }
        
        private let refreshControl = UIRefreshControl()

        private func setupRefreshControl() {
            // UIRefreshControl을 초기화하고 scrollView에 추가합니다.
            scrollView.refreshControl = refreshControl
            // 사용자가 새로고침을 시작할 때 호출될 메소드를 지정합니다.
            refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        }
        
        @objc private func refreshData() {
            // 새로운 데이터를 가져옵니다.
            fetchRemoteProduct()
        }

        private func fetchRemoteProduct() {
            let productID = Int.random(in: 1 ... 100)
            
            if let url = URL(string: "https://dummyjson.com/products/\(productID)") {
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    DispatchQueue.main.async {
                        self?.refreshControl.endRefreshing() // 새로고침 종료
                    }
                    
                    if let error = error {
                        print("오류: \(error)")
                        return
                    } else if let data = data {
                        do {
                            let product = try JSONDecoder().decode(RemoteProduct.self, from: data)
                            DispatchQueue.main.async {
                                self?.currentProduct = product
                            }
                        } catch {
                            print("오류: \(error)")
                        }
                    }
                }
                task.resume()
            }
        }
    
    private func saveWishProduct() {
        guard let context = self.persistentContainer?.viewContext else { return }
        
        guard let currentProduct = self.currentProduct else { return }
        
        let wishProduct = Product(context: context)
        
        wishProduct.id = Int64(currentProduct.id)
        wishProduct.title = currentProduct.title
        wishProduct.price = currentProduct.price
        
        try? context.save()
    }
    
}
