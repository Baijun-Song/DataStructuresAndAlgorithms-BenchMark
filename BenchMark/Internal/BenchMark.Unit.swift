extension BenchMark {
  struct Unit {
    let _storedClosure: () -> Void
    var _runMode: RunMode
    var _enabled: Bool
    
    func callAsFunction() {
      _storedClosure()
    }
  }
}
