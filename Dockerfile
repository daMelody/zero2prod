# We use the latest Rust stable release as base image
FROM rust:1.47

# Let's swithc our working directory to `app`
# The `app` folder will be created for us by Docker in case it does not exist already.
WORKDIR app

# Copy all files from our working environment to our Docker image
COPY . .

# Let's build our binary! using release profile
RUN cargo build --release

# When `docker run` is executed, launch the binary!
ENTRYPOINT [ "./target/release/zero2prod" ]
