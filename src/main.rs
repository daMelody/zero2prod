use std::net::TcpListener;
use zero2prod::configuration::get_configuration;
use zero2prod::startup::run;
#[actix_rt::main]
async fn main() -> std::io::Result<()> {
    // Panic if can't read config
    let configuration = get_configuration().expect("Failed to read configuration.");
    // Use port settings from config file
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = TcpListener::bind(address)?;
    run(listener)?.await
}
