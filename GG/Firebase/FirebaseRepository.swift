//
//  FirebaseRepository.swift
//  GG
//
//  Created by Vito Royeca on 11/4/2024.
//

import Foundation
import FirebaseFirestore
import Combine

public typealias EncodableIdentifiable = Encodable & Identifiable

enum FirebaseError: Error {
    case badSnapshot, unknownError
}

protocol FirebaseRepositoryProtocol {
//    func getDocuments<T: Codable>(from collection: FCollectionReference, for playerId: String) async throws -> [T]?
    
    func listen<T: Codable>(from collection: FCollectionReference, documentId: String) async throws -> AnyPublisher<T?, Error>
    
    func deleteDocument(with id: String, from collection: FCollectionReference)
    
    func saveDocument<T: EncodableIdentifiable>(data: T, to collection: FCollectionReference) throws
}



final class FirebaseRepository: FirebaseRepositoryProtocol {
    
//    func getDocuments<T: Codable>(from collection: FCollectionReference, for playerId: String) async throws -> [T]? {
//        
//        print("sending real")
//
//        let snapshot = try await FirebaseReference(collection)
//            .whereField(Constants.player2Id, isEqualTo: "")
//            .whereField(Constants.player1Id, isNotEqualTo: playerId).getDocuments()
//        
//        return snapshot.documents.compactMap { queryDocumentSnapshot -> T? in
//            return try? queryDocumentSnapshot.data(as: T.self)
//        }
//    }

//    func getDocument<T: Codable>(from collection: FCollectionReference, id: String) async throws -> T? {
//        let snapshot = try await FirebaseReference(collection)
//            .whereField("id", isEqualTo: id)
//            .getDocuments()
//        
//        return snapshot.documents.compactMap { queryDocumentSnapshot -> T? in
//            return try? queryDocumentSnapshot.data(as: T.self)
//        }.first
//    }

    func getDocuments<T: Codable>(from collection: FCollectionReference,
                                 equalToFilter: [String: Any]? = nil,
                                 notEqualToFilter: [String: Any]? = nil) async throws -> [T]? {
        var reference = FirebaseReference(collection)
        var query: Query?

        for (key,value) in equalToFilter ?? [:] {
            query = reference.whereField(key, isEqualTo: value)
        }
        for (key,value) in notEqualToFilter ?? [:] {
            query = reference.whereField(key, isNotEqualTo: value)
        }
            
        let snapshot = try await (query ?? reference).getDocuments()
        
        return snapshot.documents.compactMap { queryDocumentSnapshot -> T? in
            return try? queryDocumentSnapshot.data(as: T.self)
        }
    }
    
    func listen<T: Codable>(from collection: FCollectionReference, documentId: String) async throws -> AnyPublisher<T?, Error>  {
        
        let subject = PassthroughSubject<T?, Error>()
        
        let handle = FirebaseReference(collection).document(documentId).addSnapshotListener { querySnapshot, error in
            
            if let error = error {
                subject.send(completion: .failure(error))
                return
            }
            
            guard let document = querySnapshot else {
                subject.send(completion: .failure(FirebaseError.badSnapshot))
                return
            }
            
            let data = try? document.data(as: T.self)
            
            subject.send(data)
        }
        
        return subject.handleEvents(receiveCancel: {
            handle.remove()
        }).eraseToAnyPublisher()
    }
    
    func deleteDocument(with id: String, from collection: FCollectionReference) {
        FirebaseReference(collection).document(id).delete()
    }
    
    func saveDocument<T: EncodableIdentifiable>(data: T, to collection: FCollectionReference) throws {
        let id = data.id as? String ?? UUID().uuidString
        
        try FirebaseReference(collection).document(id).setData(from: data.self)
    }
}
