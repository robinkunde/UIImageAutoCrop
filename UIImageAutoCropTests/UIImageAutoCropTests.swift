//
//  UIImageAutoCropTests.swift
//  UIImageAutoCropTests
//
//  Created by Kunde, Robin - Robin on 4/26/16.
//  Copyright © 2016 Recoursive. All rights reserved.
//

import XCTest
@testable import UIImageAutoCrop

class UIImageAutoCropTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSinglePixelTopLeft() {
        let width = 7
        let height = 9

        for x in 0..<width {
            for y in 0..<height {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                UIColor.whiteColor().setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                UIColor.greenColor().setFill()
                UIRectFill(CGRect(x: x, y: y, width: 1, height: 1))

                let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .TopLeft)!
                if x == 0 && y == 0 {
                    assert(testImage.size.width == CGFloat(width))
                    assert(testImage.size.height == CGFloat(height))
                    assert(pixelAtPositionIsGreen(testImage, x: x, y: y))
                } else {
                    assert(testImage.size.width == 1)
                    assert(testImage.size.height == 1)
                    assert(pixelAtPositionIsGreen(testImage, x: 0, y: 0))
                }
                UIGraphicsEndImageContext()
            }
        }
    }

    func testSinglePixelTopRight() {
        let width = 7
        let height = 9

        for x in 0..<width {
            for y in 0..<height {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                UIColor.whiteColor().setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                UIColor.greenColor().setFill()
                UIRectFill(CGRect(x: x, y: y, width: 1, height: 1))

                let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .TopRight)!
                if x == (width - 1) && y == 0 {
                    assert(testImage.size.width == CGFloat(width))
                    assert(testImage.size.height == CGFloat(height))
                    assert(pixelAtPositionIsGreen(testImage, x: x, y: y))
                } else {
                    assert(testImage.size.width == 1)
                    assert(testImage.size.height == 1)
                    assert(pixelAtPositionIsGreen(testImage, x: 0, y: 0))
                }
                UIGraphicsEndImageContext()
            }
        }
    }

    func testSinglePixelBottomLeft() {
        let width = 7
        let height = 9

        for x in 0..<width {
            for y in 0..<height {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                UIColor.whiteColor().setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                UIColor.greenColor().setFill()
                UIRectFill(CGRect(x: x, y: y, width: 1, height: 1))

                let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .BottomLeft)!
                if x == 0 && y == (height - 1) {
                    assert(testImage.size.width == CGFloat(width))
                    assert(testImage.size.height == CGFloat(height))
                    assert(pixelAtPositionIsGreen(testImage, x: x, y: y))
                } else {
                    assert(testImage.size.width == 1)
                    assert(testImage.size.height == 1)
                    assert(pixelAtPositionIsGreen(testImage, x: 0, y: 0))
                }
                UIGraphicsEndImageContext()
            }
        }
    }

    func testSinglePixelBottomRight() {
        let width = 7
        let height = 9

        for x in 0..<width {
            for y in 0..<height {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                UIColor.whiteColor().setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                UIColor.greenColor().setFill()
                UIRectFill(CGRect(x: x, y: y, width: 1, height: 1))

                let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .BottomRight)!
                if x == (width - 1) && y == (height - 1) {
                    assert(testImage.size.width == CGFloat(width))
                    assert(testImage.size.height == CGFloat(height))
                    assert(pixelAtPositionIsGreen(testImage, x: x, y: y))
                } else {
                    assert(testImage.size.width == 1)
                    assert(testImage.size.height == 1)
                    assert(pixelAtPositionIsGreen(testImage, x: 0, y: 0))
                }
                UIGraphicsEndImageContext()
            }
        }
    }

    func testShape() {
        let width = 10
        let height = 10

        for x in 0...(width - 5) {
            for y in 0...(height - 5) {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                UIColor.whiteColor().setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                UIColor.greenColor().setFill()
                UIRectFill(CGRect(x: x + 2, y: y + 0, width: 1, height: 1))
                UIRectFill(CGRect(x: x + 1, y: y + 1, width: 1, height: 1))
                UIRectFill(CGRect(x: x + 3, y: y + 1, width: 1, height: 1))
                UIRectFill(CGRect(x: x + 0, y: y + 2, width: 1, height: 1))
                UIRectFill(CGRect(x: x + 4, y: y + 2, width: 1, height: 1))
                UIRectFill(CGRect(x: x + 1, y: y + 3, width: 1, height: 1))
                UIRectFill(CGRect(x: x + 3, y: y + 3, width: 1, height: 1))
                UIRectFill(CGRect(x: x + 2, y: y + 4, width: 1, height: 1))

                let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .TopLeft)!
                assert(testImage.size.width == 5)
                assert(testImage.size.height == 5)
                assert(pixelAtPositionIsGreen(testImage, x: 2, y: 0))
                assert(pixelAtPositionIsGreen(testImage, x: 1, y: 1))
                assert(pixelAtPositionIsGreen(testImage, x: 3, y: 1))
                assert(pixelAtPositionIsGreen(testImage, x: 0, y: 2))
                assert(pixelAtPositionIsGreen(testImage, x: 4, y: 2))
                assert(pixelAtPositionIsGreen(testImage, x: 1, y: 3))
                assert(pixelAtPositionIsGreen(testImage, x: 3, y: 3))
                assert(pixelAtPositionIsGreen(testImage, x: 2, y: 4))
                UIGraphicsEndImageContext()
            }
        }
    }

    func testHorizontalLine() {
        let width = 10
        let height = 10

        for y in 0..<height {
            for lineWidth in 2...width {
                for x in 0...(width - lineWidth) {
                    UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                    UIColor.whiteColor().setFill()
                    UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                    UIColor.greenColor().setFill()
                    UIRectFill(CGRect(x: x, y: y, width: lineWidth, height: 1))

                    let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .TopLeft)!
                    if x == 0 && y == 0 {
                        if lineWidth == width {
                            assert(testImage.size.width == CGFloat(width))
                            assert(testImage.size.height == CGFloat(height - 1))
                        } else {
                            assert(testImage.size.width == CGFloat(width))
                            assert(testImage.size.height == CGFloat(height))
                        }
                    } else {
                        assert(testImage.size.width == CGFloat(lineWidth))
                        assert(testImage.size.height == 1)
                    }
                    UIGraphicsEndImageContext()
                }
            }
        }
    }

    func testVerticalLine() {
        let width = 10
        let height = 10

        for x in 0..<width {
            for lineHeight in 2...height {
                for y in 0...(height - lineHeight) {
                    UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                    UIColor.whiteColor().setFill()
                    UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                    UIColor.greenColor().setFill()
                    UIRectFill(CGRect(x: x, y: y, width: 1, height: lineHeight))

                    let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .TopLeft)!
                    if x == 0 && y == 0 {
                        if lineHeight == height {
                            assert(testImage.size.width == CGFloat(width - 1))
                            assert(testImage.size.height == CGFloat(height))
                        } else {
                            assert(testImage.size.width == CGFloat(width))
                            assert(testImage.size.height == CGFloat(height))
                        }
                    } else {
                        assert(testImage.size.width == 1)
                        assert(testImage.size.height == CGFloat(lineHeight))
                    }
                    UIGraphicsEndImageContext()
                }
            }
        }
    }

    func testSquare() {
        let width = 7
        let height = 9

        for x in 0..<(width - 1) {
            for y in 0..<(height - 1) {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                UIColor.whiteColor().setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                UIColor.greenColor().setFill()
                UIRectFill(CGRect(x: x, y: y, width: 2, height: 2))

                let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .TopLeft)!
                if x == 0 && y == 0 {
                    assert(testImage.size.width == CGFloat(width))
                    assert(testImage.size.height == CGFloat(height))
                } else {
                    assert(testImage.size.width == 2)
                    assert(testImage.size.height == 2)
                }
                UIGraphicsEndImageContext()
            }
        }
    }

    func testSlope() {
        let width = 7
        let height = 9

        for x in 0..<(width - 4) {
            for y in 0..<(height - 2) {
                UIGraphicsBeginImageContext(CGSize(width: width, height: height))
                UIColor.whiteColor().setFill()
                UIRectFill(CGRect(x: 0, y: 0, width: width, height: height))
                UIColor.greenColor().setFill()
                UIRectFill(CGRect(x: x, y: y, width: 2, height: 2))
                UIRectFill(CGRect(x: x + 2, y: y + 1, width: 2, height: 1))

                let testImage = UIGraphicsGetImageFromCurrentImageContext().autocrop(withColorFromPixelAtPosition: .TopLeft)!
                if x == 0 && y == 0 {
                    assert(testImage.size.width == CGFloat(width))
                    assert(testImage.size.height == CGFloat(height))
                } else {
                    assert(testImage.size.width == 4)
                    assert(testImage.size.height == 2)
                }
                UIGraphicsEndImageContext()
            }
        }
    }

    private func pixelAtPositionIsGreen(image: UIImage, x: Int, y: Int) -> Bool {
        guard let imageRef = image.CGImage else {
            return false
        }

        let data = CGDataProviderCopyData(CGImageGetDataProvider(imageRef))
        let dataPointer = CFDataGetBytePtr(data)

        let bytesPerPixel = CGImageGetBitsPerPixel(imageRef) / 8
        let bytesPerRow = CGImageGetBytesPerRow(imageRef)

        let pixelData = dataPointer.advancedBy(bytesPerRow * y + bytesPerPixel * x)

        let red = pixelData[0]
        let green = pixelData[1]
        let blue = pixelData[2]
        let alpha = pixelData[3]

        return (red == 0 && green == 255 && blue == 0 && alpha == 255)
    }
}
