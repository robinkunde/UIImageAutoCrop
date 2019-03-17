//
//  UIImage+Autocrop.swift
//  UIImageAutoCrop
//
//  Created by Kunde, Robin - Robin on 4/26/16.
//  Copyright © 2016 Recoursive. All rights reserved.
//

import UIKit

extension UIImage {
    enum CroppingStrategy {
        case transparent
        case topLeftPixel
        case topRightPixel
        case bottomLeftPixel
        case bottomRightPixel
    }

    func autocrop(strategy: CroppingStrategy) -> UIImage? {
        guard let imageRef = cgImage else { return nil }

        let alphaInfo = imageRef.alphaInfo

        let bytesPerPixel = imageRef.bitsPerPixel / 8
        let bitsPerComponent = imageRef.bitsPerComponent
        guard bitsPerComponent == 8 && bytesPerPixel == 4 else {
            return nil
        }

        let width = imageRef.width
        let height = imageRef.height
        let bytesPerRow = imageRef.bytesPerRow
        guard bytesPerRow % bytesPerPixel == 0 else { return nil }

        guard
            let data = imageRef.dataProvider?.data,
            let byteData = CFDataGetBytePtr(data)
        else {
            return nil
        }

        let imageData = UnsafeRawPointer(byteData).bindMemory(to: UInt32.self, capacity: width * height)
        let cropColorValue: UInt32
        switch strategy {
        case .transparent:
            guard alphaInfo == .first || alphaInfo == .last || alphaInfo == .premultipliedFirst || alphaInfo == .premultipliedLast else { return nil }
            cropColorValue = 0
        case .topLeftPixel:
            cropColorValue = imageData[0]
        case .topRightPixel:
            cropColorValue = imageData[width - 1]
        case .bottomLeftPixel:
            cropColorValue = imageData[width * (height - 1)]
        case .bottomRightPixel:
            cropColorValue = imageData[width * (height - 1) + (width - 1)]
        }

        // positions of the x-most pixels that cannot be cropped
        var top = 0
        var bottom = 0
        var left = 0
        var right = 0
        var isEmpty = true
        outerloop: for y in 0..<height {
            var pixelPointer = imageData.advanced(by: width * y)
            for x in 0..<width {
                if pixelPointer.pointee != cropColorValue {
                    left = x
                    top = y
                    isEmpty = false
                    break outerloop
                }
                pixelPointer += 1
            }
        }

        guard !isEmpty else {
            return nil
        }

        if top < (height - 1) {
            outerloop: for y in ((top + 1)..<height).reversed() {
                var pixelPointer = imageData.advanced(by: width * y)
                for x in 0..<width {
                    if pixelPointer.pointee != cropColorValue {
                        left = min(left, x)
                        bottom = y
                        break outerloop
                    }
                    pixelPointer += 1
                }
            }
        }
        bottom = max(bottom, top)

        if left > 0 && (bottom - top) > 1 {
            outerloop: for x in 0..<left {
                var pixelPointer = imageData.advanced(by: width * (top + 1) + x)
                for _ in (top + 1)..<bottom {
                    if pixelPointer.pointee != cropColorValue {
                        left = x
                        break outerloop
                    }
                    pixelPointer += width
                }
            }
        }

        if left < (width - 1) {
            outerloop: for x in ((left + 1)..<width).reversed() {
                var pixelPointer = imageData.advanced(by: width * top + x)
                for _ in top...bottom {
                    if pixelPointer.pointee != cropColorValue {
                        right = x
                        break outerloop
                    }
                    pixelPointer += width
                }
            }
        }
        right = max(right, left)

        let cropRect = CGRect(x: left, y: top, width: right - left + 1, height: bottom - top + 1)

        if let croppedImageRef = CGImageCreateWithImageInRect(imageRef, cropRect) {
            return UIImage(CGImage: croppedImageRef)
        }

        return nil
    }
}
