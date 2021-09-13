//
//  CryptoDetailViewController.swift
//  CryptoCurrencyiOSApp
//
//  Created by Xiangli on 8/8/21.
//

import UIKit

class CryptoDetailViewController: UIViewController, CryptoDetailNetworkManagerDelegate{
   
    @IBOutlet weak var cryptoName: UILabel!
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var priceChange1H: UILabel!
    @IBOutlet weak var lastUpated: UILabel!
    @IBOutlet weak var cryptoDesc: UILabel!
    @IBOutlet weak var cryptoLogo: UIImageView!
    var selectedCryptoid: Int?
    var selectedCryptoSymbol: String?
    var quote: CryptoQuoteModel?
    var meta: CryptoMetaModel?
    
    var cryptoNetworkManager: CryptoNetworkManager = CryptoNetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cryptoNetworkManager.detailDelegate = self
        cryptoNetworkManager.performQuoteRequst(selectedCryptoid)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCryptoSymbol
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller doesn't exist")
        }
        
        navBar.tintColor = UIColor.white
    }
    
    func didUpdateQuote(cryptoQuote: CryptoQuoteModel) {
        DispatchQueue.main.async {
            self.quote = cryptoQuote
            self.cryptoName?.text = self.quote?.name
            if let quotePrice = self.quote?.quote {
                for(type, value) in quotePrice{
                    let price = value.price.formattedAmount != nil ? value.price.formattedAmount : "--"
                    self.lastPrice?.text = "\(price!) \(type)"
                    self.volume?.text = value.volume.formattedAmount
                    self.priceChange1H?.text = value.priceChange1H.formattedAmount
                    self.lastUpated?.text = "last updated at \(value.lastUpdated.formattedTime) UTC"
                }
            }
        }
    }

    func didUpdateMeta(cryptoMeta: CryptoMetaModel) {
        DispatchQueue.main.async {
            self.meta = cryptoMeta
            self.cryptoName?.text = self.quote?.name
                 
            self.cryptoDesc?.text = self.meta?.description
            if let imageUrl = self.meta?.logo {
                let url = URL(string: imageUrl)
                self.cryptoLogo?.load(url: url!)
             }
        }
    }
}

extension Decimal {
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber)
    }
}

extension String{
    var formattedTime: String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let date: Date? = dateFormatterGet.date(from: self)
        return dateFormatterPrint.string(from: date!)
        
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
