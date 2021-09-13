//
//  Crypto.swift
//  CryptoCurrencyiOSApp
//
//  Created by Xiangli on 8/7/21.
//

import Foundation

struct CryptoListDTO : Codable{
    let data : [CryptoDTO]
}

struct CryptoDTO: Codable {
    let id: Int
    let cmc_rank: Int
    let name: String
    let symbol: String
    let slug: String
}

struct CryptoDetailDTO : Codable{
    let data : CryptoQuoteDataDTO
}

struct CryptoQuoteDataDTO: Codable {
    public var innerQuote: [String: CryptoQuoteDTO]

    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
           return nil
        }
    }
       
   public init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CustomCodingKeys.self)
       
       self.innerQuote = [String: CryptoQuoteDTO]()
       for key in container.allKeys {
        let value = try container.decode(CryptoQuoteDTO.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
        self.innerQuote[key.stringValue] = value
       }
   }
}

struct CryptoQuoteDTO: Codable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let total_supply: Decimal
    let num_market_pairs: Int
    let cmc_rank: Int
    let last_updated: String
    let quote: CryptoQuoteUSDDTO
    
}

struct CryptoQuoteUSDDTO: Codable {
    var quote: [String: QuoteDTO]

    private struct DynamicCodingKeys: CodingKey {

            // Use for string-keyed dictionary
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }

            // Use for integer-keyed dictionary
            var intValue: Int?
            init?(intValue: Int) {
                // We are not using this, thus just return nil
                return nil
            }
    }
    
    init(from decoder: Decoder) throws {

        // Create a decoding container using DynamicCodingKeys
        // The container will contain all the JSON first level key
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        self.quote = [String: QuoteDTO]()
        // Loop through each key in container
        for key in container.allKeys {

            // Decode Quote using key
            let value = try container.decode(QuoteDTO.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            self.quote[key.stringValue] = value
        }
    }
}

struct QuoteDTO: Codable {
    let price: Decimal
    let volume_24h: Decimal
    let percent_change_1h: Decimal
    let percent_change_24h: Decimal
    let percent_change_7d: Decimal
    let percent_change_30d: Decimal
    let market_cap: Decimal
    let last_updated: String
}

struct CryptoDetailMetaDTO : Codable{
    let data : CryptoMetaDataDTO
}

struct CryptoMetaDataDTO: Codable {
    public var innerMeta: [String: MetaDTO]

    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
           return nil
        }
    }
       
   public init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CustomCodingKeys.self)
       
       self.innerMeta = [String: MetaDTO]()
       for key in container.allKeys {
        let value = try container.decode(MetaDTO.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
        self.innerMeta[key.stringValue] = value
       }
   }
}

struct MetaDTO: Codable {
    let id: Int
    let name: String
    let symbol: String
    let description: String
    let slug: String
    let category: String
    let logo: String
}
