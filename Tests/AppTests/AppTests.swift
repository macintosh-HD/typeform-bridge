import XCTVapor
import PayloadValidation
@testable import App

final class AppTests: XCTestCase {
    func testWebhookController_withExamplePayload_returnsOK() throws {
        var env = Environment.testing
        try LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }
        try configure(app)
        
        try app.autoRevert().wait()
        try app.autoMigrate().wait()
        
        let token = Environment.get("TYPEFORM_SECRET")!
        let data = Payload.typeform.data(using: .utf8)!
        let key = PayloadValidation.generateKey(secretToken: token, body: data)
        
        var headers = HTTPHeaders()
        headers.add(name: "HTTP_TYPEFORM_SIGNATURE", value: key)
        headers.add(name: .contentType, value: HTTPMediaType.json.description)

        try app.test(.POST, "webhook", headers: headers) { req in
            req.body = ByteBuffer(data: data)
        } afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
