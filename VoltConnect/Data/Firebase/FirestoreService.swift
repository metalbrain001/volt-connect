//
//  FirestoreService.swift
//  volt
//
//  Created by Babatunde Kalejaiye on 21/10/2025.
//
import Foundation
import FirebaseFirestore

public enum FirestoreService {
    public static func decode<T: Decodable>(_ snap: DocumentSnapshot, as: T.Type) throws -> T? {
        guard snap.exists else { return nil }
        return try snap.data(as: T.self)
    }

    public static func serverTimestamp() -> [String: Any] {
        ["createdAt": FieldValue.serverTimestamp()]
    }
}
