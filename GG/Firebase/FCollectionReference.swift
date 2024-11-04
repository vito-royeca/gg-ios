//
//  FCollectionReference.swift
//  GG
//
//  Created by Vito Royeca on 11/4/2024.
//

import Foundation
import Firebase

enum FCollectionReference: String {
    case players, games
}

func FirebaseReference(_ reference: FCollectionReference) -> CollectionReference {
    Firestore.firestore().collection(reference.rawValue)
}
