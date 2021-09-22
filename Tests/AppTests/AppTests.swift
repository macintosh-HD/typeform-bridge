import Foundation
import XCTVapor
import PayloadValidation
@testable import App

final class AppTests: XCTestCase {
    
    static var env: Environment!
    var app: Application!
    var token: String!
    
    override class func setUp() {
        super.setUp()
        
        env = Environment.testing
        try! LoggingSystem.bootstrap(from: &env)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        token = Environment.get("TYPEFORM_SECRET")!
        app = Application(Self.env)
        try configure(app)
        
        try app.autoMigrate().wait()
    }
    
    override func tearDownWithError() throws {
        try app.autoRevert().wait()
        app.shutdown()
        
        token = nil
        app = nil
        
        try super.tearDownWithError()
    }
    
    deinit { app?.shutdown() }
    
    func testWebhookController_withExamplePayload_returnsOK() throws {
        let data = Payload.typeform.data(using: .utf8)!
        let key = PayloadValidation.generateKey(secretToken: token, body: data)

        let headers = generateHeaders(with: key)
        
        try app.test(.POST, "webhook", headers: headers, body: .init(data: data)) { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
    
    // MARK: - helpers
    
    private func generateHeaders(with key: String) -> HTTPHeaders {
        var headers = HTTPHeaders()
        headers.add(name: "Typeform-Signature", value: key)
        headers.add(name: .contentType, value: HTTPMediaType.json.description)
        return headers
    }
}
