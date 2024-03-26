//
//  HHAssetExtension.swift
//  iosDev
//
//  Created by kingdee on 2024/3/25.
//


import AVFoundation

public extension AVURLAsset {
    @objc var fileSize: Int {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        return (resourceValues?.fileSize ?? resourceValues?.totalFileSize) ?? 0
    }
}
