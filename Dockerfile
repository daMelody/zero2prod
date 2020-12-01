#* Planner Stage
FROM rust:1.47 AS planner
WORKDIR app
# Install `cargo-chef`
RUN cargo install cargo-chef
COPY . .
# Compute a lock-file with cargo-chef
RUN cargo chef prepare --recipe-path.json recipe.json


#* Cacher Stage
FROM rust:1.47 AS cacher
WORKDIR app
RUN cargo install cargo-chef
COPY --from=planner /app/recipe/recipe.json recipe.json
# Build project dependencies with cargo chef, NOT the application
RUN cargo chef cook --release --recipe-path recipe.json


#* Builder Stage
FROM rust:1.47 AS builder
WORKDIR app
# Copy over cached dependencies
COPY --from=cacher /app/target target
COPY --from=cacher /usr/local/cargo /usr/local/cargo
COPY . .
ENV SQLX_OFFLINE true
# Build application, using cached dependencies
RUN cargo build --release --bin zero2prod


#* Runtime Stage
FROM debian:buster-slim AS runtime
WORKDIR app
# Install OpenSSL
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
# Copy compiled binary from `builder` environment
COPY --from=builder /app/target/release/zero2prod/ zero2prod
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT [ "./target/release/zero2prod" ]
