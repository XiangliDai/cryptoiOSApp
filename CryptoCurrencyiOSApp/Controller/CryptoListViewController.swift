//
//  ViewController.swift
//  CryptoCurrencyiOSApp
//
//  Created by Xiangli on 8/7/21.
//

import UIKit

class CryptoListViewController: UITableViewController, CryptoListNetworkManagerDelegate {
   
    var cryptoNetworkManager: CryptoNetworkManager = CryptoNetworkManager()
    var result:[CryptoModel] = []
    var originResult:[CryptoModel] = []
    var selectedCrypo: CryptoModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      
        cryptoNetworkManager.listDelegate = self
        cryptoNetworkManager.performMapRequst()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cryptoCell", for: indexPath)
        cell.textLabel?.text = result[indexPath.row].symbol
        cell.detailTextLabel?.text = result[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCrypo = result[indexPath.row]
        self.performSegue(withIdentifier: "gotoDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoDetail" {
            let destinationVC = segue.destination as! CryptoDetailViewController
            destinationVC.selectedCryptoid = selectedCrypo?.id
            destinationVC.selectedCryptoSymbol = selectedCrypo?.symbol
        }
    }
    
    func didUpdateList(cryptoList: [CryptoModel]) {
       DispatchQueue.main.async {
            self.originResult = cryptoList
            self.updateList(with: cryptoList)
        }
    }
    
    private func updateList(with items: [CryptoModel]){
        result = items
        tableView.reloadData()
        
    }
}

extension CryptoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // triggerd when search button is clicked
        /*if let searchText = searchBar.text {
            result = originResult.filter({ model in
                model.name.localizedCaseInsensitiveContains(searchText) || model.symbol.localizedCaseInsensitiveContains(searchText)
            })
        }
        tableView.reloadData()*/
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //triggered when contenct inside search bar changes
        if searchBar.text?.count == 0 {
            updateList(with: originResult)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            if let searchText = searchBar.text {
                let filteredList = originResult.filter({ model in
                    model.name.localizedCaseInsensitiveContains(searchText) || model.symbol.localizedCaseInsensitiveContains(searchText)
                })
                updateList(with: filteredList)
            }
            tableView.reloadData()
        }
    }
}


