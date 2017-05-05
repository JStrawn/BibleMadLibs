import Foundation
import SystemConfiguration

enum Reachability {
  case unreachable
  case reachable
  case wifi
  case network
  
  static func status() -> Reachability {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else {
      return .unreachable
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      return .unreachable
    }
    
    // TODO: Add cases for if we're connected to wifi or network exclusively. We may want to react differently in each case
    if flags.contains(.reachable) {
      return .reachable
    } else {
      return .unreachable
    }
  }
}
