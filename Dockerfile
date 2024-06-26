# Phase 1: Build
FROM rust:1.78-bookworm as builder

RUN mkdir curler-counter
WORKDIR curler-counter
# Copy the source code into the container
COPY . .

# Build the project
RUN --mount=type=cache,target=/curler-counter/target --mount=type=cache,target=/usr/local/cargo/registry cargo build --release && cp -r target /target


# Phase 2: Run
FROM debian:bookworm-slim

# Install necessary runtime dependencies
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# Copy the binary from the build stage
COPY --from=builder /target/release/rust-curler-counter /usr/local/bin/rust-curler-counter

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/rust-curler-counter"]
