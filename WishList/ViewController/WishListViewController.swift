//
//  WishListViewController.swift
//  WishList
//
//  Created by 서혜림 on 4/15/24.
//

import UIKit
import CoreData

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    private var productList: [Product] = []
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setProductList()
    }
    
    // MARK: - Methods
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.nib(), forCellReuseIdentifier: TableViewCell.identifier)
    }
    
    private func setProductList() {
        guard let context = persistentContainer?.viewContext else { return }
        let request = Product.fetchRequest()
        if let productList = try? context.fetch(request) {
            self.productList = productList
        }
        print(productList)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        let product = productList[indexPath.row]
        cell.idLabel.text = String(product.price)
        cell.titleLabel.text = product.title ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteProduct(at: indexPath)
        }
    }
    
    private func deleteProduct(at indexPath: IndexPath) {
        if let context = persistentContainer?.viewContext {
            let productToDelete = productList[indexPath.row]
            context.delete(productToDelete)
            do {
                try context.save()
                productList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("오류: \(error)")
            }
        }
    }
}
