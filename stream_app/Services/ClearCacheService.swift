//
//  clearCacheService.swift
//  stream_app
//
//  Created by Cours on 06/02/2026.
//
import Foundation

final class ClearCacheService {

    /// Nettoie le cache et retourne un message lisible
    static func clearCache() -> String {
        let cacheSize = getCacheSize()
        
        URLCache.shared.removeAllCachedResponses()
        
        return "Cache vidé : \(formatBytes(cacheSize))"
    }

    /// Taille totale du cache (disque + mémoire)
    private static func getCacheSize() -> Int {
        let cache = URLCache.shared
        return cache.currentDiskUsage + cache.currentMemoryUsage
    }

    /// Format en Mo
    private static func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
