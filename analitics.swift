import Firebase

class Analytics: NSObject {
  
  static func getCakesEvent() {
    FIRAnalytics.logEvent(withName: "getCakes", parameters: nil)
  }
  
  static func postCakeEvent(withData data: [String:String]) {
    FIRAnalytics.logEvent(withName: "postCake", parameters: data as [String : NSObject])
  }
  
  static func sendMessageEvent() {
    FIRAnalytics.logEvent(withName: "message", parameters: nil)
  }
  static func sendLoginEvent() {
    FIRAnalytics.logEvent(withName: kFIREventLogin, parameters: nil)
  }
}
