extension BenchMark {
  public static func makeIntegerDemoArray(
    order: DemoArrayElementsOrder,
    in range: Range<Int>,
    length: Int,
    withRandomPercentage percentage: Double = 0.0
  ) -> [Int] {
    precondition(range.lowerBound < range.upperBound)
    precondition(length > 0)
    precondition(percentage >= 0.0 && percentage <= 1.0)
    
    var result: [Int] = []
    result.reserveCapacity(length)
    let randomCount = Int(Double(length) * percentage)
    let count = length - randomCount
    let lowerBound = Double(range.lowerBound)
    let upperBound = Double(range.upperBound)
    let delta = (upperBound - lowerBound) / Double(count)
    
    switch order {
    case .ascending:
      var value = lowerBound
      for _ in 0..<count {
        result.append(Int(value))
        value += delta
      }
    case .descending:
      var value = upperBound
      for _ in 0..<count {
        value -= delta
        result.append(Int(value))
      }
    }
    
    for _ in 0..<randomCount {
      result.insert(
        Int.random(in: range),
        at: Int.random(in: 0...result.count)
      )
    }
    return result
  }
}

