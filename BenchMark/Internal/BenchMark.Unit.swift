extension BenchMark {
  @usableFromInline
  struct Unit {
    @usableFromInline
    let storedClosure: () -> Void
    
    @usableFromInline
    var runMode: RunMode
    
    @usableFromInline
    var enabled: Bool
    
    @inlinable @inline(__always)
    init(
      storedClosure: @escaping () -> Void,
      runMode: RunMode,
      enabled: Bool
    ) {
      self.storedClosure = storedClosure
      self.runMode = runMode
      self.enabled = enabled
    }
    
    @inlinable @inline(__always)
    func callAsFunction() {
      storedClosure()
    }
  }
}
