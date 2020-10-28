//
//  XCRollLabelExtension.swift
//  XCRollLabel
//
//  Created by yuan on 2019/10/27.
//  Copyright © 2019 xccn. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    /// 对富文本进行平均分割区域
    public func separatedAttLines(width: CGFloat, height: CGFloat) -> [NSAttributedString] {
        let textFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let rectPath: CGPath = CGPath(rect: textFrame, transform: nil)

        var textPos = 0
        let cfAttStr: CFAttributedString = self as CFAttributedString

        let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(cfAttStr)
        var pagingResult = [NSAttributedString]()

        while textPos < self.length {
            let frame: CTFrame = CTFramesetterCreateFrame(framesetter, CFRange(location: textPos, length: 0), rectPath, nil)
            let frameRange = CTFrameGetVisibleStringRange(frame)
            if frameRange.length == 0 {
              pagingResult.append(self)
              break
            }

            let range = NSRange(location: frameRange.location, length: frameRange.length)
            let subStr = self.attributedSubstring(from: range)
            pagingResult.append(subStr)
            textPos += frameRange.length
        }

        return pagingResult
    }
        
    /// 获取富文本内尺寸最大的Font
    public func maxAttbuteFont() -> UIFont? {
        var maxFont: UIFont?
        for index in 0..<self.length {
            let subChar = self.attributes(at: index, effectiveRange: nil)
            if let vFont = subChar[NSAttributedString.Key.font] as? UIFont {
                if vFont.pointSize > maxFont?.pointSize ?? 0 {
                    maxFont = vFont
                }
            }
        }

        return maxFont
    }
    
    /// 获取富文本内尺寸最小的Font
    public func minAttbuteFont() -> UIFont? {
        var minFont: UIFont?
        for index in 0..<self.length {
            let subChar = self.attributes(at: index, effectiveRange: nil)
            if let vFont = subChar[NSAttributedString.Key.font] as? UIFont {
                if minFont?.pointSize ?? 0 == 0 {
                    minFont = vFont
                }
                if minFont?.pointSize ?? 0 > vFont.pointSize {
                    minFont = vFont
                }
            }
        }

        return minFont
    }
    
    /// 最大字体和最小字体相差的倍数
    public func maxminDifferenceMultiple() -> CGFloat {
        let maxFont = self.maxAttbuteFont()
        let minFont = self.minAttbuteFont()

        guard let vMaxHeight = maxFont?.lineHeight, let vMinHeight = minFont?.lineHeight else {
            return 0
        }

        let space = vMaxHeight / vMinHeight
        return space
    }
    
}

extension String {
    
    // 文字宽度
    public func width(_ font: UIFont) -> CGFloat {
        return NSString(string: self).size(withAttributes: [NSAttributedString.Key.font: font]).width
    }
    
    // 文字高度
    public func height(_ font: UIFont, width: CGFloat) -> CGFloat {
        return self.size(font, maxSize: CGSize(width: width, height: CGFloat(MAXFLOAT))).height
    }
    
    // 文字尺寸
    public func size(_ font: UIFont, maxSize: CGSize) -> CGSize {
        let attrs = [NSAttributedString.Key.font: font]
        return NSString(string: self).boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attrs, context: nil).size
    }
    
    // 去除空格
    public func removeSpace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
