//
//  Covid19DataLoader.swift
//  Covid19Tracker
//
//  Created by Maharjan Binish on 2020/07/10.
//

import Foundation

struct Covid19DataLoader {
    static func fetch(completion: @escaping (Result<Covid19CountryStatus, Error>) -> Void) {
        let url = URL(string: "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search?search=jap")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let countryData = try JSONDecoder().decode(Covid19CountryStatus.self, from: data!)
                completion(.success(countryData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    static func fetch(by country: String, completion: @escaping (Result<Covid19CountryStatus, Error>) -> Void) {
        let url = URL(string: "https://corona-virus-stats.herokuapp.com/api/v1/cases/countries-search?search=\(country)")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let countryData = try JSONDecoder().decode(Covid19CountryStatus.self, from: data!)
                completion(.success(countryData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    static func fetchGeneralStats(completion: @escaping (Result<Covid19GeneralStats, Error>) -> Void) {
        let url = URL(string: "https://corona-virus-stats.herokuapp.com/api/v1/cases/general-stats")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            do {
                let countryData = try JSONDecoder().decode(Covid19GeneralStats.self, from: data!)
                completion(.success(countryData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
