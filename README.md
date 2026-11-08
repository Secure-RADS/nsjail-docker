# nsjail-docker

Container image used by the Secure-RADS registry service to run the Data Controller app inside the enclave.

This repository holds the packaging metadata only. The image is published to GitHub Container Registry:

```
ghcr.io/secure-rads/nsjail-docker
```

The build is based on the upstream nsjail project and the unofficial weekly build previously published from `prdai/nsjail-docker`, which has been archived. The registry service pins the image by digest:

```
FROM ghcr.io/secure-rads/nsjail-docker@sha256:6c500a51d3ccadf2fb8fb312c2738aa1a6ba867a3982c0d206478c6a7edec35b
```

## Publishing

Run the `publish` workflow manually. It copies the pinned upstream manifest list into this repository's package, preserving every platform. Change the source digest and tag in the workflow when a new build is needed.

## License

The image repackages nsjail, licensed under Apache-2.0. The packaging files here carry no separate license.
