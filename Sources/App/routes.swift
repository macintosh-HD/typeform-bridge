import Vapor

func routes(_ app: Application) throws {
    let headerName = Environment.get("TYPEFORM_HEADER_NAME") ?? "Typeform-Signature"
    try app.register(collection: WebhookController(app: app, signatureHeaderName: headerName))
}
