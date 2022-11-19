import Foundation

public final class BenchMark {
  public typealias Result =
    [String: (averageTime: Double, repeatTimes: Int)]
  var _units: [String: Unit] = [:]
  
  public init() {}
}

extension BenchMark {
  public func addUnit(
    withName name: String,
    runMode: RunMode,
    runBlock: @escaping () -> Void
  ) {
    let unit = Unit(
      _storedClosure: runBlock,
      _runMode: runMode,
      _enabled: true
    )
    _units[name] = unit
  }
  
  public func removeUnit(forName name: String) {
    _units[name] = nil
  }
  
  public func editUnit(forName name: String, enabled: Bool) {
    _units[name]?._enabled = enabled
  }
  
  public func editUnit(forName name: String, runMode: RunMode) {
    _units[name]?._runMode = runMode
  }
  
  @discardableResult
  public func run(printingResult: Bool = true) -> Result {
    var result: Result = [:]
    for (name, unit) in _units {
      guard unit._enabled else {
        continue
      }
      var totalTime = 0.0
      let repeatTimes: Int
      var repeated = 0
      
      switch unit._runMode {
      case .once:
        repeatTimes = 1
      case .repeatedly(let times):
        repeatTimes = times
      case .auto(let total):
        let startTime = Date()
        unit()
        var singleTime = Date().timeIntervalSince(startTime)
        let count = 5
        
        if total > singleTime * Double(count) {
          var time = singleTime
          for _ in 0..<(count - 1) {
            let start = Date()
            unit()
            time += Date().timeIntervalSince(start)
          }
          singleTime = time / Double(count)
          repeated = count
          totalTime += time
        } else {
          repeated = 1
          totalTime += singleTime
        }
        repeatTimes = Int(total / singleTime)
      }
      
      for _ in 0..<(repeatTimes - repeated) {
        let startTime = Date()
        unit()
        totalTime += Date().timeIntervalSince(startTime)
      }
      result[name] =
        (totalTime / Double(repeatTimes), repeatTimes)
    }
    
    if printingResult {
      let names = result.keys.map { $0 }
      let width = (names.map { $0.count }.max() ?? 0) + 1
      for (name, unitResult) in result {
        let s1 = String(repeating: " ", count: width - name.count)
        let s2 = "\(name) | "
        let s3 = "\(unitResult.averageTime * 1000.0)"
          .padding(toLength: 12, withPad: " ", startingAt: 0)
        let s4 = " ms (repeat for \(unitResult.repeatTimes) times)"
        print(s1 + s2 + s3 + s4)
      }
    }
    return result
  }
}
