//
//  CryptoNetworkManager.swift
//  CryptoCurrencyiOSApp
//
//  Created by Xiangli on 8/7/21.
//

import Foundation

protocol CryptoListNetworkManagerDelegate {
    func didUpdateList(cryptoList: [CryptoModel])
}

protocol CryptoDetailNetworkManagerDelegate {
    func didUpdateQuote(cryptoQuote: CryptoQuoteModel)
    func didUpdateMeta(cryptoMeta: CryptoMetaModel)
}

class CryptoNetworkManager {
    let mapUrl = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    let quoteUrl = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest"
    let metaUrl = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/info"
    let apiKey = "you app key"
    var listDelegate:CryptoListNetworkManagerDelegate?
    var detailDelegate:CryptoDetailNetworkManagerDelegate?
    var selectedId :String = ""
    
    func performMapRequst(){
        if let url = URL(string: mapUrl+apiKey){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, _, error in
                self.processResponse(data: data, error: error, processor: self.parseMapJSON)
            }
            task.resume()
        }
    }
        
    private func parseMapJSON(data: Data){
        let decoder = JSONDecoder()
        do{
           let decodedData = try decoder.decode(CryptoListDTO.self, from: data)
            let listDTO = decodedData.data
            var listModel : [CryptoModel] = []
            for crytoDTO in listDTO {
                listModel.append(CryptoModel(id: crytoDTO.id, name: crytoDTO.name, symbol: crytoDTO.symbol))
            }
            listDelegate?.didUpdateList(cryptoList: listModel)
        } catch{
            print(error)
        }
    }
    
     private func processResponse(data: Data?, error: Error?, processor:(_ safeData: Data) -> Void){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            processor(safeData)
        }
    }
    
     func performQuoteRequst(_ cryptoId:Int?){
        if let id = cryptoId {
            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            
            self.selectedId = String(id)
            if let url = URL(string: quoteUrl+apiKey+"&id=" + self.selectedId){
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, response, error in
                    self.processResponse(data: data, error: error, processor: self.parseQuoteJSON)
                    dispatchGroup.leave()
                }
                task.resume()
            }
            
            dispatchGroup.enter()
            
            if let url = URL(string: metaUrl+apiKey+"&id=" + self.selectedId){
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, response, error in
                    self.processResponse(data: data, error: error, processor: self.parseMetaJSON)
                    dispatchGroup.leave()
                }
                task.resume()
            }
            
            dispatchGroup.notify(queue: .main) {
                // whatever you want to do when both are done
            }
        }
    }
    
    private func parseQuoteJSON(data: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CryptoDetailDTO.self, from: data)
            let cryptoData = decodedData.data
            let cryptoQuoteDTO = cryptoData.innerQuote[self.selectedId]
               
            if let cryptoDTO = cryptoQuoteDTO, let quoteDTO = cryptoQuoteDTO?.quote {
                var quoteMap = [String: Quote]()
                for (type, quote) in quoteDTO.quote {
                    quoteMap[type] = Quote(price: quote.price, priceChange1H: quote.percent_change_1h, percentChange24H: quote.percent_change_24h, percentChange7D: quote.percent_change_7d, percentChange30D: quote.percent_change_30d, marketCap: quote.market_cap, lastUpdated: quote.last_updated, volume: quote.volume_24h)
                }
                let cryptoDetail = CryptoQuoteModel(id: cryptoDTO.id, name: cryptoDTO.name, symbol: cryptoDTO.symbol, quote: quoteMap)
                detailDelegate?.didUpdateQuote(cryptoQuote: cryptoDetail)
            }
        } catch {
            print(error)
        }
    }
    
    private func parseMetaJSON(data: Data){
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CryptoDetailMetaDTO.self, from: data)
            let cryptoData = decodedData.data
            let cryptoMetaDTO = cryptoData.innerMeta[self.selectedId]
               
            if let metaDto = cryptoMetaDTO {
                let cryptoMeta = CryptoMetaModel(id: metaDto.id, name: metaDto.name, symbol: metaDto.symbol, slug: metaDto.slug, category: metaDto.category, logo: metaDto.logo, description: metaDto.description)
                detailDelegate?.didUpdateMeta(cryptoMeta: cryptoMeta)
            }
        } catch {
            print(error)
        }
    }
}
