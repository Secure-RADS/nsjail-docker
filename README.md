# nsjail-docker

Prebuilt [nsjail](https://github.com/google/nsjail) image, published to:

- `ghcr.io/secure-rads/nsjail-docker:latest`

Google ships nsjail as source only, no binary releases - this compiles it
from source and publishes the result so downstream projects can just pull
the image instead of compiling nsjail themselves.

Rebuilds hourly via GitHub Actions (tracks upstream `master`), plus on every
push to `main` and manually via workflow_dispatch. Multi-arch: amd64 + arm64.

## Using this in your own project

The image's final stage is nsjail's *entire* runtime - the compiled binary
plus every shared library it's dynamically linked against (libprotobuf,
libnl) - not just the bare binary. Pulling only the binary risks missing a
transitive dependency; pulling the whole rootfs guarantees it works.

In a multi-stage Dockerfile, pull the whole thing in as a build stage and
copy out of it:

```dockerfile
FROM ghcr.io/secure-rads/nsjail-docker:latest AS nsjail

FROM your-base-image
COPY --from=nsjail / /opt/assets/nsjail-runtime/
# /opt/assets/nsjail-runtime/bin/nsjail is now available, along with
# every library it needs to actually run.
```

If your final image's base already has compatible libprotobuf/libnl
versions, you can instead copy just the binary:

```dockerfile
COPY --from=nsjail /bin/nsjail /usr/local/bin/nsjail
```

but the whole-rootfs approach above is the safer default unless you've
specifically verified your base's library versions match.

## License

This repository is [Apache License 2.0](LICENSE) - the same license as
nsjail itself, since the published image redistributes nsjail's compiled
binary. Only the `Dockerfile` and CI workflow in this repo are original
work; nsjail itself is Google's, unmodified.
