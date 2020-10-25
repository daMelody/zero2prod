use std::net::TcpListener;
use zero2prod::run;
#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    run(TcpListener::bind("127.0.0.1:0").expect("Failed to bind random port"))?.await
}
