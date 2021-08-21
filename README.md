# typeform-bridge (WIP)
A basic Vapor application that interacts with the Typeform API.

So far the package implements the models needed to decode a webhook payload. It also listens on a http path for incoming webhook posts.
The webhook can be secured using HMAC message authentication by providing a secret with the `TYPEFORM_SECRET` environment variable.
The url of the webhook can be also defined by an environment variable: `WEBHOOK_PATH` can contain a url path. The default path is `/webhook`.
Every payload that is received on the webhook route will be decoded an saved to a Postgres database. All database information must be provided by environment variables.
 - `POSTGRES_HOST`: The database host, default: `localhost`
 - `POSTGRES_PORT`: The port where the database will be reachable, default: Postgres default
 - `POSTGRES_USER`: The user for the database, default: current user's username
 - `POSTGRES_PASS`: The password for the database user, default: empty
 - `POSTGRES_DB`: The database name, default: `typeform-test`
 - `POSTGRES_SCHEMA`: The name of the database schema where the tables should be created (optional)
 
The model for the webhook payload can also be used separately by importing this package usign SPM:  
`.package(url: "https://github.com/macintosh-HD/typeform-bridge.git", from: "0.0.1")`  
`.product(name: "TypeformModel", package: "typeform-bridge")`  
