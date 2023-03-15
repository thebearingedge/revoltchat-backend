# Build Stage
ARG BASE_IMAGE=ghcr.io/revoltchat/base:latest
FROM ${BASE_IMAGE} AS base

# Bundle Stage
FROM debian:buster-slim
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    apt-get clean
COPY --from=base /home/rust/src/target/release/revolt-delta ./
EXPOSE 8000
ENV ROCKET_ADDRESS 0.0.0.0
ENV ROCKET_PORT 8000
CMD ["./revolt-delta"]
