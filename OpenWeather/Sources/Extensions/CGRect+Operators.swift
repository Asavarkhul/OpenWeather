import Foundation
import UIKit

//MARK: - Maths
//MARK: ├ CGFloat

public func floor(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return floor(x * scale)/scale
}

public func floor(_ x: CGFloat, useScreenScale: Bool) -> CGFloat {
    return useScreenScale ? floor(x, scale: UIScreen.main.scale) : floor(x)
}

public func ceil(_ x: CGFloat, scale: CGFloat) -> CGFloat {
    return ceil(x * scale)/scale
}

public func ceil(_ x: CGFloat, useScreenScale: Bool) -> CGFloat {
    return useScreenScale ? ceil(x, scale: UIScreen.main.scale) : ceil(x)
}

//MARK: ├ CGPoint

public func floor(_ point: CGPoint, scale: CGFloat = 1.0) -> CGPoint {
    return CGPoint(x: floor(point.x, scale: scale), y: floor(point.y, scale: scale))
}

public func floor(_ x: CGPoint, useScreenScale: Bool) -> CGPoint {
    return useScreenScale ? floor(x, scale: UIScreen.main.scale) : floor(x)
}

public func ceil(_ origin: CGPoint, scale: CGFloat = 1.0) -> CGPoint {
    return CGPoint(x: ceil(origin.x, scale: scale), y: ceil(origin.y, scale: scale))
}

public func ceil(_ x: CGPoint, useScreenScale: Bool) -> CGPoint {
    return useScreenScale ? ceil(x, scale: UIScreen.main.scale) : ceil(x)
}

//MARK: ├ CGSize

public func floor(_ size: CGSize, scale: CGFloat = 1.0) -> CGSize {
    return CGSize(width: floor(size.width, scale: scale), height: floor(size.height, scale: scale))
}

public func floor(_ x: CGSize, useScreenScale: Bool) -> CGSize {
    return useScreenScale ? floor(x, scale: UIScreen.main.scale) : floor(x)
}

public func ceil(_ size: CGSize, scale: CGFloat = 1.0) -> CGSize {
    return CGSize(width: ceil(size.width, scale: scale), height: ceil(size.height, scale: scale))
}

public func ceil(_ x: CGSize, useScreenScale: Bool) -> CGSize {
    return useScreenScale ? ceil(x, scale: UIScreen.main.scale) : ceil(x)
}


//MARK: - Useful Extensions
public extension CGSize {
    /// The center of the size value. E.g.: {50, 40} center is {25, 20}
    public var center: CGPoint {
        return CGPoint(x: self.width / 2, y: self.height / 2)
    }
    
    
    public func integralSize(_ scale: CGFloat = 1.0) -> CGSize {
        return CGSize(width: ceil(self.width, scale: scale), height: ceil(self.height, scale: scale))
    }
    
    public func integralSize(forMainScreenScale: Bool) -> CGSize {
        return self.integralSize(forMainScreenScale ? UIScreen.main.scale : 1.0)
    }
    
    /**
     The even value of the receiver by flooring the value (or ceiling if 'false').
     
     For example, for a receiver of {23, 22}, returned result will be {22, 22} if floor == true, or {24, 22} else.
     */
    public func evenValue(byFlooring: Bool = true) -> CGSize {
        var evenValue: CGSize = byFlooring ? floor(self) : ceil(self)
        if Int(self.width.truncatingRemainder(dividingBy: 2)) == 1 {
            evenValue.width += byFlooring ? -1 : 1
        }
        if Int(self.height.truncatingRemainder(dividingBy: 2)) == 1 {
            evenValue.height += byFlooring ? -1 : 1
        }
        return evenValue
    }
    
    /**
     The odd value of the receiver by flooring the value (or ceiling if 'false').
     
     For example, for a receiver of {23, 22}, returned result will be {23, 21} if floor == true, or {23, 23} else.
     */
    public func oddValue(byFlooring: Bool = true) -> CGSize {
        var oddValue: CGSize = byFlooring ? floor(self) : ceil(self)
        if Int(self.width.truncatingRemainder(dividingBy: 2)) == 0 {
            oddValue.width += byFlooring ? -1 : 1
        }
        if Int(self.height.truncatingRemainder(dividingBy: 2)) == 0 {
            oddValue.height += byFlooring ? -1 : 1
        }
        return oddValue
    }
}

public extension CGRect {
    
    public init(center: CGPoint, size: CGSize) {
        self.size = size
        self.origin = CGPoint(x: center.x - (size.width / 2), y: center.y - (size.height / 2))
    }
    
    /// The center of the rect value. E.g.: {10, 20, 50, 40} center is {35, 40}. Changing the center affects the origin of the rect.
    public var center: CGPoint {
        get {
            return CGPoint(x: self.midX, y: self.midY)
        }
        
        set {
            self.origin = CGPoint(x: newValue.x - (self.width / 2.0), y: newValue.y - (self.height / 2.0))
        }
        
    }
    
    public func integralRect(_ scale: CGFloat = 1.0) -> CGRect {
        return CGRect(origin: floor(self.origin, scale: scale), size: ceil(self.size, scale: scale))
    }
    
    public func integralRect(forMainScreenScale: Bool) -> CGRect {
        return self.integralRect(forMainScreenScale ? UIScreen.main.scale : 1.0)
    }
}

//MARK: - Comparable CGSize & CGRect
extension CGSize: Comparable {}
extension CGRect: Comparable {}
public func < (lhs: CGSize, rhs: CGSize) -> Bool {
    return (lhs.width * lhs.height) < (rhs.width * rhs.height)
}
public func < (lhs: CGRect, rhs: CGRect) -> Bool {
    return lhs.size < rhs.size
}


//MARK: - Operators

//MARK: CGRect & CGSize
public func + (rect: CGRect, size: CGSize) -> CGRect {
    return CGRect(origin: rect.origin, size: rect.size + size)
}
public func - (rect: CGRect, size: CGSize) -> CGRect {
    return CGRect(origin: rect.origin, size: rect.size - size)
}
public func * (rect: CGRect, size: CGSize) -> CGRect {
    return CGRect(origin: rect.origin, size: rect.size * size)
}
public func / (rect: CGRect, size: CGSize) -> CGRect {
    return CGRect(origin: rect.origin, size: rect.size / size)
}

public func += (rect: inout CGRect, size: CGSize) {
    rect.size += size
}
public func -= (rect: inout CGRect, size: CGSize) {
    rect.size -= size
}
public func *= (rect: inout CGRect, size: CGSize) {
    rect.size *= size
}
public func /= (rect: inout CGRect, size: CGSize) {
    rect.size /= size
}

//MARK: CGRect & CGPoint
public func + (rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(origin: rect.origin + point, size: rect.size)
}
public func - (rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(origin: rect.origin - point, size: rect.size)
}
public func * (rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(origin: rect.origin * point, size: rect.size)
}
public func / (rect: CGRect, point: CGPoint) -> CGRect {
    return CGRect(origin: rect.origin / point, size: rect.size)
}

public func += (rect: inout CGRect, origin: CGPoint) {
    rect.origin += origin
}
public func -= (rect: inout CGRect, origin: CGPoint) {
    rect.origin -= origin
}
public func *= (rect: inout CGRect, origin: CGPoint) {
    rect.origin *= origin
}
public func /= (rect: inout CGRect, origin: CGPoint) {
    rect.origin /= origin
}

//MARK: CGRect & UIEdgesInsets
public func + (rect: CGRect, insets: UIEdgeInsets) -> CGRect {
    return CGRect(origin: rect.origin - CGPoint(x: insets.left, y: insets.top), size: rect.size + insets)
}
public func - (rect: CGRect, insets: UIEdgeInsets) -> CGRect {
    return CGRect(origin: rect.origin + CGPoint(x: insets.left, y: insets.top), size: rect.size - insets)
}

public func += (rect: inout CGRect, insets: UIEdgeInsets) {
    rect.origin -= CGPoint(x: insets.left, y: insets.top)
    rect.size += insets
}
public func -= (rect: inout CGRect, insets: UIEdgeInsets) {
    rect.origin += CGPoint(x: insets.left, y: insets.top)
    rect.size -= insets
}

//MARK: CGRect & UIOffset

public func + (rect: CGRect, offset: UIOffset) -> CGRect {
    return CGRect(origin: rect.origin + CGPoint(x: offset.horizontal, y: offset.vertical), size: rect.size)
}
public func - (rect: CGRect, offset: UIOffset) -> CGRect {
    return CGRect(origin: rect.origin - CGPoint(x: offset.horizontal, y: offset.vertical), size: rect.size)
}
public func * (rect: CGRect, offset: UIOffset) -> CGRect {
    return CGRect(origin: rect.origin * CGPoint(x: offset.horizontal, y: offset.vertical), size: rect.size)
}
public func / (rect: CGRect, offset: UIOffset) -> CGRect {
    return CGRect(origin: rect.origin / CGPoint(x: offset.horizontal, y: offset.vertical), size: rect.size)
}

public func += (rect: inout CGRect, offset: UIOffset) {
    rect.origin += CGPoint(x: offset.horizontal, y: offset.vertical)
}
public func -= (rect: inout CGRect, offset: UIOffset) {
    rect.origin -= CGPoint(x: offset.horizontal, y: offset.vertical)
}
public func *= (rect: inout CGRect, offset: UIOffset) {
    rect.origin *= CGPoint(x: offset.horizontal, y: offset.vertical)
}
public func /= (rect: inout CGRect, offset: UIOffset) {
    rect.origin /= CGPoint(x: offset.horizontal, y: offset.vertical)
}

//MARK: CGSize & CGFloat
public func + (size: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: size.width + right, height: size.height + right)
}
public func - (size: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: size.width - right, height: size.height - right)
}
public func * (size: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: size.width * right, height: size.height * right)
}
public func / (size: CGSize, right: CGFloat) -> CGSize {
    return CGSize(width: size.width / right, height: size.height / right)
}

public func += (size: inout CGSize, right: CGFloat) {
    size.width += right
    size.height += right
}
public func -= (size: inout CGSize, right: CGFloat) {
    size.width -= right
    size.height -= right
}
public func *= (size: inout CGSize, right: CGFloat) {
    size.width *= right
    size.height *= right
}
public func /= (size: inout CGSize, right: CGFloat) {
    size.width /= right
    size.height /= right
}

//MARK: CGSize & Int
public func + (size: CGSize, right: Int) -> CGSize {
    return size + CGFloat(right)
}
public func - (size: CGSize, right: Int) -> CGSize {
    return size - CGFloat(right)
}
public func * (size: CGSize, right: Int) -> CGSize {
    return size * CGFloat(right)
}
public func / (size: CGSize, right: Int) -> CGSize {
    return size / CGFloat(right)
}

public func += (size: inout CGSize, right: Int) {
    size += CGFloat(right)
}
public func -= (size: inout CGSize, right: Int) {
    size -= CGFloat(right)
}
public func *= (size: inout CGSize, right: Int) {
    size *= CGFloat(right)
}
public func /= (size: inout CGSize, right: Int) {
    size /= CGFloat(right)
}

//MARK: CGSize & Double
public func + (size: CGSize, right: Double) -> CGSize {
    return size + CGFloat(right)
}
public func - (size: CGSize, right: Double) -> CGSize {
    return size - CGFloat(right)
}
public func * (size: CGSize, right: Double) -> CGSize {
    return size * CGFloat(right)
}
public func / (size: CGSize, right: Double) -> CGSize {
    return size / CGFloat(right)
}

public func += (size: inout CGSize, right: Double) {
    size += CGFloat(right)
}
public func -= (size: inout CGSize, right: Double) {
    size -= CGFloat(right)
}
public func *= (size: inout CGSize, right: Double) {
    size *= CGFloat(right)
}
public func /= (size: inout CGSize, right: Double) {
    size /= CGFloat(right)
}

//MARK: CGSize & Float
public func + (size: CGSize, right: Float) -> CGSize {
    return size + CGFloat(right)
}
public func - (size: CGSize, right: Float) -> CGSize {
    return size - CGFloat(right)
}
public func * (size: CGSize, right: Float) -> CGSize {
    return size * CGFloat(right)
}
public func / (size: CGSize, right: Float) -> CGSize {
    return size / CGFloat(right)
}

public func += (size: inout CGSize, right: Float) {
    size += CGFloat(right)
}
public func -= (size: inout CGSize, right: Float) {
    size -= CGFloat(right)
}
public func *= (size: inout CGSize, right: Float) {
    size *= CGFloat(right)
}
public func /= (size: inout CGSize, right: Float) {
    size /= CGFloat(right)
}

//MARK: CGSize & CGSize
public func + (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width + right.width, height: left.height + right.height)
}
public func - (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width - right.width, height: left.height - right.height)
}
public func * (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width * right.width, height: left.height * right.height)
}
public func / (left: CGSize, right: CGSize) -> CGSize {
    return CGSize(width: left.width / right.width, height: left.height / right.height)
}

public func += (left: inout CGSize, right: CGSize) {
    left.width += right.width
    left.height += right.height
}
public func -= (left: inout CGSize, right: CGSize) {
    left.width -= right.width
    left.height -= right.height
}
public func *= (left: inout CGSize, right: CGSize) {
    left.width *= right.width
    left.height *= right.height
}
public func /= (left: inout CGSize, right: CGSize) {
    left.width /= right.width
    left.height /= right.height
}

//MARK: CGSize & UIEdgeInsets
public func + (size: CGSize, insets: UIEdgeInsets) -> CGSize {
    return size + CGSize(width: insets.left + insets.right, height: insets.top + insets.bottom)
}
public func - (size: CGSize, insets: UIEdgeInsets) -> CGSize {
    return size - CGSize(width: insets.left + insets.right, height: insets.top + insets.bottom)
}

public func += (size: inout CGSize, insets: UIEdgeInsets) {
    size += CGSize(width: insets.left + insets.right, height: insets.top + insets.bottom)
}
public func -= (size: inout CGSize, insets: UIEdgeInsets) {
    size -= CGSize(width: insets.left + insets.right, height: insets.top + insets.bottom)
}

//MARK: CGSize & (CGFloat, CGFloat)

public func + (left: CGSize, right: (CGFloat, CGFloat)) -> CGSize {
    return left + CGSize(width: right.0, height: right.1)
}
public func - (left: CGSize, right: (CGFloat, CGFloat)) -> CGSize {
    return left - CGSize(width: right.0, height: right.1)
}
public func * (left: CGSize, right: (CGFloat, CGFloat)) -> CGSize {
    return left * CGSize(width: right.0, height: right.1)
}
public func / (left: CGSize, right: (CGFloat, CGFloat)) -> CGSize {
    return left / CGSize(width: right.0, height: right.1)
}

public func +=(left: inout CGSize, right: (CGFloat, CGFloat)) {
    left += CGSize(width: right.0, height: right.1)
}
public func -=(left: inout CGSize, right: (CGFloat, CGFloat)) {
    left -= CGSize(width: right.0, height: right.1)
}
public func *=(left: inout CGSize, right: (CGFloat, CGFloat)) {
    left *= CGSize(width: right.0, height: right.1)
}
public func /=(left: inout CGSize, right: (CGFloat, CGFloat)) {
    left /= CGSize(width: right.0, height: right.1)
}

//MARK: CGSize & (Int, Int)

public func + (left: CGSize, right: (Int, Int)) -> CGSize {
    return left + CGSize(width: right.0, height: right.1)
}
public func - (left: CGSize, right: (Int, Int)) -> CGSize {
    return left - CGSize(width: right.0, height: right.1)
}
public func * (left: CGSize, right: (Int, Int)) -> CGSize {
    return left * CGSize(width: right.0, height: right.1)
}
public func / (left: CGSize, right: (Int, Int)) -> CGSize {
    return left / CGSize(width: right.0, height: right.1)
}

public func +=(left: inout CGSize, right: (Int, Int)) {
    left += CGSize(width: right.0, height: right.1)
}
public func -=(left: inout CGSize, right: (Int, Int)) {
    left -= CGSize(width: right.0, height: right.1)
}
public func *=(left: inout CGSize, right: (Int, Int)) {
    left *= CGSize(width: right.0, height: right.1)
}
public func /=(left: inout CGSize, right: (Int, Int)) {
    left /= CGSize(width: right.0, height: right.1)
}

//MARK: CGSize & (Double, Double)

public func + (left: CGSize, right: (Double, Double)) -> CGSize {
    return left + CGSize(width: right.0, height: right.1)
}
public func - (left: CGSize, right: (Double, Double)) -> CGSize {
    return left - CGSize(width: right.0, height: right.1)
}
public func * (left: CGSize, right: (Double, Double)) -> CGSize {
    return left * CGSize(width: right.0, height: right.1)
}
public func / (left: CGSize, right: (Double, Double)) -> CGSize {
    return left / CGSize(width: right.0, height: right.1)
}

public func +=(left: inout CGSize, right: (Double, Double)) {
    left += CGSize(width: right.0, height: right.1)
}
public func -=(left: inout CGSize, right: (Double, Double)) {
    left -= CGSize(width: right.0, height: right.1)
}
public func *=(left: inout CGSize, right: (Double, Double)) {
    left *= CGSize(width: right.0, height: right.1)
}
public func /=(left: inout CGSize, right: (Double, Double)) {
    left /= CGSize(width: right.0, height: right.1)
}

//MARK: CGSize & (Float, Float)

public func + (left: CGSize, right: (Float, Float)) -> CGSize {
    return left + (CGFloat(right.0), CGFloat(right.1))
}
public func - (left: CGSize, right: (Float, Float)) -> CGSize {
    return left - (CGFloat(right.0), CGFloat(right.1))
}
public func * (left: CGSize, right: (Float, Float)) -> CGSize {
    return left * (CGFloat(right.0), CGFloat(right.1))
}
public func / (left: CGSize, right: (Float, Float)) -> CGSize {
    return left / (CGFloat(right.0), CGFloat(right.1))
}

public func +=(left: inout CGSize, right: (Float, Float)) {
    left += (CGFloat(right.0), CGFloat(right.1))
}
public func -=(left: inout CGSize, right: (Float, Float)) {
    left -= (CGFloat(right.0), CGFloat(right.1))
}
public func *=(left: inout CGSize, right: (Float, Float)) {
    left *= (CGFloat(right.0), CGFloat(right.1))
}
public func /=(left: inout CGSize, right: (Float, Float)) {
    left /= (CGFloat(right.0), CGFloat(right.1))
}


//MARK: CGPoint & CGFloat
public func + (point: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: point.x + right, y: point.y + right)
}
public func - (point: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: point.x - right, y: point.y - right)
}
public func * (point: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * right, y: point.y * right)
}
public func / (point: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / right, y: point.y / right)
}

public func += (point: inout CGPoint, right: CGFloat) {
    point.x += right
    point.y += right
}
public func -= (point: inout CGPoint, right: CGFloat) {
    point.x -= right
    point.y -= right
}
public func *= (point: inout CGPoint, right: CGFloat) {
    point.x *= right
    point.y *= right
}
public func /= (point: inout CGPoint, right: CGFloat) {
    point.x /= right
    point.y /= right
}

//MARK: CGPoint & Int
public func + (point: CGPoint, right: Int) -> CGPoint {
    return point + CGFloat(right)
}
public func - (point: CGPoint, right: Int) -> CGPoint {
    return point - CGFloat(right)
}
public func * (point: CGPoint, right: Int) -> CGPoint {
    return point * CGFloat(right)
}
public func / (point: CGPoint, right: Int) -> CGPoint {
    return point / CGFloat(right)
}

public func += (point: inout CGPoint, right: Int) {
    point += CGFloat(right)
}
public func -= (point: inout CGPoint, right: Int) {
    point -= CGFloat(right)
}
public func *= (point: inout CGPoint, right: Int) {
    point *= CGFloat(right)
}
public func /= (point: inout CGPoint, right: Int) {
    point /= CGFloat(right)
}

//MARK: CGPoint & Double
public func + (point: CGPoint, right: Double) -> CGPoint {
    return point + CGFloat(right)
}
public func - (point: CGPoint, right: Double) -> CGPoint {
    return point - CGFloat(right)
}
public func * (point: CGPoint, right: Double) -> CGPoint {
    return point * CGFloat(right)
}
public func / (point: CGPoint, right: Double) -> CGPoint {
    return point / CGFloat(right)
}


public func += (point: inout CGPoint, right: Double) {
    point += CGFloat(right)
}
public func -= (point: inout CGPoint, right: Double) {
    point -= CGFloat(right)
}
public func *= (point: inout CGPoint, right: Double) {
    point *= CGFloat(right)
}
public func /= (point: inout CGPoint, right: Double) {
    point /= CGFloat(right)
}

//MARK: CGPoint & Float
public func + (point: CGPoint, right: Float) -> CGPoint {
    return point + CGFloat(right)
}
public func - (point: CGPoint, right: Float) -> CGPoint {
    return point - CGFloat(right)
}
public func * (point: CGPoint, right: Float) -> CGPoint {
    return point * CGFloat(right)
}
public func / (point: CGPoint, right: Float) -> CGPoint {
    return point / CGFloat(right)
}

public func += (point: inout CGPoint, right: Float) {
    point += CGFloat(right)
}
public func -= (point: inout CGPoint, right: Float) {
    point -= CGFloat(right)
}
public func *= (point: inout CGPoint, right: Float) {
    point *= CGFloat(right)
}
public func /= (point: inout CGPoint, right: Float) {
    point /= CGFloat(right)
}

//MARK: CGPoint & CGPoint
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}

public func += (left: inout CGPoint, right: CGPoint) {
    left.x += right.x
    left.y += right.y
}
public func -= (left: inout CGPoint, right: CGPoint) {
    left.x -= right.x
    left.y -= right.y
}
public func *= (left: inout CGPoint, right: CGPoint) {
    left.x *= right.x
    left.y *= right.y
}
public func /= (left: inout CGPoint, right: CGPoint) {
    left.x /= right.x
    left.y /= right.y
}

//MARK: CGPoint & UIOffset
public func + (point: CGPoint, right: UIOffset) -> CGPoint {
    return point + (right.horizontal, right.vertical)
}
public func - (point: CGPoint, right: UIOffset) -> CGPoint {
    return point - (right.horizontal, right.vertical)
}

public func += (left: inout CGPoint, offset: UIOffset) {
    left.x += offset.horizontal
    left.y += offset.vertical
}
public func -= (left: inout CGPoint, offset: UIOffset) {
    left.x -= offset.horizontal
    left.y -= offset.vertical
}

//MARK: CGPoint & CGSize

public func + (point: CGPoint, right: CGSize) -> CGPoint {
    return point + (right.width, right.height)
}
public func - (point: CGPoint, right: CGSize) -> CGPoint {
    return point - (right.width, right.height)
}
public func +=(left: inout CGPoint, right: CGSize) {
    left += (right.width, right.height)
}
public func -=(left: inout CGPoint, right: CGSize) {
    left -= (right.width, right.height)
}

//MARK: CGPoint & (CGFloat, CGFloat)

public func + (left: CGPoint, right: (CGFloat, CGFloat)) -> CGPoint {
    return left + CGPoint(x: right.0, y: right.1)
}
public func - (left: CGPoint, right: (CGFloat, CGFloat)) -> CGPoint {
    return left - CGPoint(x: right.0, y: right.1)
}
public func * (left: CGPoint, right: (CGFloat, CGFloat)) -> CGPoint {
    return left * CGPoint(x: right.0, y: right.1)
}
public func / (left: CGPoint, right: (CGFloat, CGFloat)) -> CGPoint {
    return left / CGPoint(x: right.0, y: right.1)
}

public func +=(left: inout CGPoint, right: (CGFloat, CGFloat)) {
    left += CGPoint(x: right.0, y: right.1)
}
public func -=(left: inout CGPoint, right: (CGFloat, CGFloat)) {
    left -= CGPoint(x: right.0, y: right.1)
}
public func *=(left: inout CGPoint, right: (CGFloat, CGFloat)) {
    left *= CGPoint(x: right.0, y: right.1)
}
public func /=(left: inout CGPoint, right: (CGFloat, CGFloat)) {
    left /= CGPoint(x: right.0, y: right.1)
}

//MARK: CGPoint & (Int, Int)

public func + (left: CGPoint, right: (Int, Int)) -> CGPoint {
    return left + CGPoint(x: right.0, y: right.1)
}
public func - (left: CGPoint, right: (Int, Int)) -> CGPoint {
    return left - CGPoint(x: right.0, y: right.1)
}
public func * (left: CGPoint, right: (Int, Int)) -> CGPoint {
    return left * CGPoint(x: right.0, y: right.1)
}
public func / (left: CGPoint, right: (Int, Int)) -> CGPoint {
    return left / CGPoint(x: right.0, y: right.1)
}

public func +=(left: inout CGPoint, right: (Int, Int)) {
    left += CGPoint(x: right.0, y: right.1)
}
public func -=(left: inout CGPoint, right: (Int, Int)) {
    left -= CGPoint(x: right.0, y: right.1)
}
public func *=(left: inout CGPoint, right: (Int, Int)) {
    left *= CGPoint(x: right.0, y: right.1)
}
public func /=(left: inout CGPoint, right: (Int, Int)) {
    left /= CGPoint(x: right.0, y: right.1)
}

//MARK: CGPoint & (Double, Double)

public func + (left: CGPoint, right: (Double, Double)) -> CGPoint {
    return left + CGPoint(x: right.0, y: right.1)
}
public func - (left: CGPoint, right: (Double, Double)) -> CGPoint {
    return left - CGPoint(x: right.0, y: right.1)
}
public func * (left: CGPoint, right: (Double, Double)) -> CGPoint {
    return left * CGPoint(x: right.0, y: right.1)
}
public func / (left: CGPoint, right: (Double, Double)) -> CGPoint {
    return left / CGPoint(x: right.0, y: right.1)
}

public func +=(left: inout CGPoint, right: (Double, Double)) {
    left += CGPoint(x: right.0, y: right.1)
}
public func -=(left: inout CGPoint, right: (Double, Double)) {
    left -= CGPoint(x: right.0, y: right.1)
}
public func *=(left: inout CGPoint, right: (Double, Double)) {
    left *= CGPoint(x: right.0, y: right.1)
}
public func /=(left: inout CGPoint, right: (Double, Double)) {
    left /= CGPoint(x: right.0, y: right.1)
}

//MARK: CGPoint & (Float, Float)

public func + (left: CGPoint, right: (Float, Float)) -> CGPoint {
    return left + (CGFloat(right.0), CGFloat(right.1))
}
public func - (left: CGPoint, right: (Float, Float)) -> CGPoint {
    return left - (CGFloat(right.0), CGFloat(right.1))
}
public func * (left: CGPoint, right: (Float, Float)) -> CGPoint {
    return left * (CGFloat(right.0), CGFloat(right.1))
}
public func / (left: CGPoint, right: (Float, Float)) -> CGPoint {
    return left / (CGFloat(right.0), CGFloat(right.1))
}

public func +=(left: inout CGPoint, right: (Float, Float)) {
    left += (CGFloat(right.0), CGFloat(right.1))
}
public func -=(left: inout CGPoint, right: (Float, Float)) {
    left -= (CGFloat(right.0), CGFloat(right.1))
}
public func *=(left: inout CGPoint, right: (Float, Float)) {
    left *= (CGFloat(right.0), CGFloat(right.1))
}
public func /=(left: inout CGPoint, right: (Float, Float)) {
    left /= (CGFloat(right.0), CGFloat(right.1))
}
