use axum::{extract::State, routing::get, Router};
use diesel::r2d2::{ConnectionManager, Pool};
use diesel::PgConnection;
use std::net::SocketAddr;

#[derive(Clone)]
#[allow(dead_code)]
struct AppState {
    db: Pool<ConnectionManager<PgConnection>>,
}

#[tokio::main]
async fn main() {
    dotenvy::dotenv().ok();
    let database_url =
        std::env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let manager = ConnectionManager::<PgConnection>::new(&database_url);
    let pool = Pool::builder()
        .build(manager)
        .expect("Failed to create pool");
    let state = AppState { db: pool };

    let app = Router::new()
        .route("/health", get(health))
        .with_state(state);

    let addr = SocketAddr::from(([0, 0, 0, 0], 3000));
    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn health(State(_state): State<AppState>) -> &'static str {
    "ok"
}
