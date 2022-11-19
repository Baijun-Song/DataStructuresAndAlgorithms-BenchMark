extension BenchMark {
  public enum RunMode {
    case once
    case repeatedly(repeatTimes: Int)
    case auto(totalTime: Double)
  }
}
