//
//  CryptoModel.swift
//  CryptoCurrencyiOSApp
//
//  Created by Xiangli on 8/7/21.
//

import Foundation

struct CryptoModel {
    let id: Int
    let name: String
    let symbol: String
    
    init(id: Int, name: String, symbol: String) {
        self.id = id
        self.name = name
        self.symbol = symbol
    }
}

struct CryptoQuoteModel {
    let id: Int
    let name: String
    let symbol: String
    let quote:[String: Quote]
    
    init(id: Int, name: String, symbol: String, quote:[String: Quote]) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.quote = quote
    }
}

struct Quote {
    let price:Decimal
    let volume: Decimal
    let priceChange1H: Decimal
    let percentChange24H: Decimal
    let percentChange7D: Decimal
    let percentChange30D: Decimal
    let marketCap: Decimal
    let lastUpdated: String
    init(price:Decimal,
         priceChange1H: Decimal,
         percentChange24H: Decimal,
         percentChange7D: Decimal,
         percentChange30D: Decimal,
         marketCap: Decimal,
         lastUpdated: String,
         volume: Decimal) {
      
        self.price = price
        self.volume = volume
        self.priceChange1H = priceChange1H
        self.percentChange24H = percentChange24H
        self.percentChange7D = percentChange7D
        self.percentChange30D = percentChange30D
        self.marketCap = marketCap
        self.lastUpdated = lastUpdated
    }
}

struct CryptoMetaModel {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let category: String
    let logo: String
    let description: String
    
    init(id: Int, name: String, symbol: String, slug: String, category: String, logo: String, description: String) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.slug = slug
        self.category = category
        self.logo = logo
        self.description = description
    }
}
