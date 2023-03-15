# Build Stage
ARG BASE_IMAGE=ghcr.io/revoltchat/base:latest
FROM ${BASE_IMAGE} AS base

# Bundle Stage
FROM debian:buster-slim
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    apt-get clean
COPY --from=base /home/rust/src/target/release/revolt-bonfire ./
EXPOSE 9000
CMD ["./revolt-bonfire"]
