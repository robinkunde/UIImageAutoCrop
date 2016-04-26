//
//  UIImage+Autocrop.swift
//  UIImageAutoCrop
//
//  Created by Kunde, Robin - Robin on 4/26/16.
//  Copyright © 2016 Recoursive. All rights reserved.
//

import UIKit

extension UIImage {
    enum CropPixelPosition {
        case Transparent
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }

    func autocrop(withColorFromPixelAtPosition cropPixelPosition: CropPixelPosition) -> UIImage? {
        guard let imageRef = CGImage else {
            return nil
        }

        let alphaInfo = CGImageGetAlphaInfo(imageRef)
        guard cropPixelPosition != .Transparent || (alphaInfo == .First || alphaInfo == .Last || alphaInfo == .PremultipliedFirst || alphaInfo == .PremultipliedLast) else {
            return nil
        }

        let bytesPerPixel = CGImageGetBitsPerPixel(imageRef) / 8
        let bitsPerComponent = CGImageGetBitsPerComponent(imageRef)
        guard bitsPerComponent == 8 && bytesPerPixel == 4 else {
            return nil
        }

        let width = CGImageGetWidth(imageRef)
        let height = CGImageGetHeight(imageRef)
        let bytesPerRow = CGImageGetBytesPerRow(imageRef)

        guard let data = CGDataProviderCopyData(CGImageGetDataProvider(imageRef)) else {
            return nil
        }
        let imageData = UnsafeMutablePointer<UInt32>(CFDataGetBytePtr(data))

        let pixelsPerRow = bytesPerRow / bytesPerPixel
        let cropColorValue: UInt32
        switch cropPixelPosition {
        case .Transparent:
            cropColorValue = 0
        case .TopLeft:
            cropColorValue = imageData[0]
        case .TopRight:
            cropColorValue = imageData[width - 1]
        case .BottomLeft:
            cropColorValue = imageData[pixelsPerRow * (height - 1)]
        case .BottomRight:
            cropColorValue = imageData[pixelsPerRow * (height - 1) + (width - 1)]
        }

        // positions of the x-most pixels that cannot be cropped
        var top = 0
        var bottom = 0
        var left = 0
        var right = 0
        var isEmpty = true
        outerloop: for y in 0..<height {
            var pixelPointer = imageData.advancedBy(pixelsPerRow * y)
            for x in 0..<width {
                if pixelPointer.memory != cropColorValue {
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
            outerloop: for y in ((top + 1)..<height).reverse() {
                var pixelPointer = imageData.advancedBy(pixelsPerRow * y)
                for x in 0..<width {
                    if pixelPointer.memory != cropColorValue {
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
                var pixelPointer = imageData.advancedBy(pixelsPerRow * (top + 1) + x)
                for _ in (top + 1)..<bottom {
                    if pixelPointer.memory != cropColorValue {
                        left = x
                        break outerloop
                    }
                    pixelPointer += pixelsPerRow
                }
            }
        }

        if left < (width - 1) {
            outerloop: for x in ((left + 1)..<width).reverse() {
                var pixelPointer = imageData.advancedBy(pixelsPerRow * top + x)
                for _ in top...bottom {
                    if pixelPointer.memory != cropColorValue {
                        right = x
                        break outerloop
                    }
                    pixelPointer += pixelsPerRow
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
