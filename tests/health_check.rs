//use actix_web::test;
use std::net::TcpListener;

#[actix_rt::test]
async fn health_check_succeeds() {
    // Spin up the app
    let address = spawn_app();
    // Send our request
    let client = reqwest::Client::new();
    let response = client
        .get(&format!("{}/health_check", &address))
        .send()
        .await
        .expect("Failed to execute request.");
    // test response
    assert!(response.status().is_success());
    assert_eq!(Some(0), response.content_length());
}

/*
#[actix_rt::test]
async fn test_health_check() {
    let request = test::TestRequest::with_header("content-type", "text/plain").to_request();
    let response = test::call_service( ,request).await;

    assert!(response.status().is_success());
    assert_eq!(Some(0), response.content_length());
}*/

fn spawn_app() -> String {
    let listener = TcpListener::bind("127.0.0.1:0").expect("Failed to bind random port.");
    let port = listener.local_addr().unwrap().port();
    let server = zero2prod::run(listener).expect("Failed to bind address");
    let _ = tokio::spawn(server);
    format!("http://127.0.0.1:{}", port)
}
