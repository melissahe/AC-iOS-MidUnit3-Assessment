//
//  BooksViewController.swift
//  AC-iOS-MidUnit3-Assessment
//
//  Created by C4Q on 11/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BooksListViewController: UIViewController {

    @IBOutlet weak var booksTableView: UITableView!
    
    //Table View Data Source Variable
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        booksTableView.delegate = self
        booksTableView.dataSource = self
    }
    
    func getData() {
        let apiManager = APIManager()
        apiManager.getData(forResource: "bookinfo", ofType: "json") { (data: Data?) in
            
            guard let data = data else {
                print("Error: Data was nil")
                return
            }
            
            let books = Book.getBooks(from: data)
            self.books = books
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let cell = sender as? UITableViewCell,
            let indexPath = booksTableView.indexPath(for: cell),
            let destinationVC = segue.destination as? BooksDetailViewController {
            destinationVC.book = books[indexPath.row]
        }
    }
}

//MARK: - Table View Methods
extension BooksListViewController: UITableViewDelegate, UITableViewDataSource {
    
    //Table View Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        performSegue(withIdentifier: "detailedSegue", sender: selectedCell)
    }
    
    //Table View Data Source Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        let currentBook = books[indexPath.row]
        
        cell.textLabel?.text = currentBook.title
        cell.detailTextLabel?.text = "$\(currentBook.price) USD"
        
        return cell
    }
    
}
