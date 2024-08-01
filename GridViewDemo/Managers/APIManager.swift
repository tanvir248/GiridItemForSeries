//
//  APIManager.swift
//  GridViewDemo
//
//  Created by Tanvir Rahman on 1/8/24.
//

import Foundation
import Combine

class APIManager {
    
    static let shared = APIManager()
    
    private var cancellables = Set<AnyCancellable>()

    func fetchArrayData<T: Decodable>(url: String, completion: @escaping (Result<[T], Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [T].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }, receiveValue: { value in
                completion(.success(value))
            })
            .store(in: &self.cancellables)
    }
    

    func fetchData<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let failure):
                    completion(.failure(failure))
                }
            }, receiveValue: { value in
                completion(.success(value))
            })
            .store(in: &self.cancellables)
    }
    
}
