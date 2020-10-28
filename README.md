XCRollLabel

#### 文本内容歌词进度组件
- 支持单行歌词效果
- 支持富文本歌词播放
- 支持多行歌词效果
- 支持多行富文本歌词播放

#### 单行、多行对应的Label
##### XCSingleRollLabel
##### XCMultiLineRollLabel

```
func playAnimation(_ duration: CGFloat, completion: (()->Void)? = nil) {
        
        self.playCompletion = completion
        self.stopAnimation()
        guard self.bounds.width > 0, duration > 0 else {
            self.playCompletion?()
            return
        }
        
        let timeArray: Array<CGFloat> = [0, duration]
        let locationArray: Array<CGFloat> = [0, 1]
        var keyTimeArray = [CGFloat]()
        var widthArray = [CGFloat]()
        for i in 0..<timeArray.count {
          let tempTime = timeArray[i] / duration
          let tempWidth = locationArray[i] * self.bounds.width
          keyTimeArray.append(tempTime)
          widthArray.append(tempWidth)
        }
        
        let keyaAnimation = CAKeyframeAnimation(keyPath: "bounds.size.width")
        keyaAnimation.values = widthArray
        keyaAnimation.keyTimes = keyTimeArray as [NSNumber]
        keyaAnimation.duration = CFTimeInterval(duration)
        keyaAnimation.calculationMode = CAAnimationCalculationMode.linear
        keyaAnimation.fillMode = CAMediaTimingFillMode.forwards
        keyaAnimation.isRemovedOnCompletion = isRemovedOnCompletion
        keyaAnimation.delegate = self
        self.maskLayer.add(keyaAnimation, forKey: "sks_lyrcis_anim")
    }
```

#### 富文本分割


```
func separatedAttLines(width: CGFloat, height: CGFloat) -> [NSAttributedString] {
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
```

