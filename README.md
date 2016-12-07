# GrootFS (BOSH release) [![slack.cloudfoundry.org](https://slack.cloudfoundry.org/badge.svg)](https://slack.cloudfoundry.org)

A [BOSH](http://docs.cloudfoundry.org/bosh/) release for deploying
[GrootFS](https://github.com/cloudfoundry/grootfs).

## Assumptions

### newuidmap / newgidmap

We assume that this release will be used with the
[garden-runc-release](https://github.com/cloudfoundry/garden-runc-release).
Based on that we ship our own `newuidmap` and `newgidmap` that has hard coded
user mappings inside, ignoring the `/etc/subuid` and `/etc/subgid` files.

This is necessary due to the way garden create non-privileged containers
(as the user uid 4294967294). These binaries have no use outside the
grootfs-garden context.

### volume creation

The release will never recreate the btrfs volume on an update if the file already exists,
even if you change it's size in the manifest. Current flow:

* If there's no volume file: create volume file -> format with btrfs -> mount
* If there's a volume file: check if it's formatted with btrfs
  * if yes -> mount
  * if no -> format with btrfs -> mount

The btrfs mount point will always owned by user ~4294967294 (or the max uid possible)
because that's the user that garden will be calling grootfs for non-privileged containers.

## Contributing

In order to help us extend GrootFS, we recommend opening a Github issue to
describe the proposed features or changes. We also welcome pull requests.

## Shipped packages

* btrfs-progs 4.4.1
* e2fsprogs 1.43.3
* autoconf 2.69
* automake 1.15
* gettext 0.19.8.1
* libtool 2.4.6
* pkg-config 0.29
* lzo 2.09
* util-linux 2.28
* zlib 1.2.8
* go 1.7.3

## License

Apache License 2.0
