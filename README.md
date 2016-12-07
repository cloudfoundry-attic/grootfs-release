# GrootFS (BOSH release) [![slack.cloudfoundry.org](https://slack.cloudfoundry.org/badge.svg)](https://slack.cloudfoundry.org)

A [BOSH](http://docs.cloudfoundry.org/bosh/) release for deploying
[GrootFS](https://github.com/cloudfoundry/grootfs).

This release makes a lot of [assumptions](#assumptions) based on expected use
with [garden-runc-release](https://github.com/cloudfoundry/garden-runc-release)
in the context of Cloud Foundry / Diego. It may be useful in combination with
Garden-runC outside of Cloud Foundry, but it's unlikely to be useful in any
other context.

## Deploying with Diego / Cloud Foundry

_Disclaimer: not all of the properties mentioned below exist yet, but work is in
flight to implement them. If you think you want to deploy this in the meantime,
chat to someone in the #grootfs Slack channel about whether that's really a good
idea!_

Given an existing Diego / CF deployment, take the following steps to start using
grootfs-release on your Diego cells:

1. Upload grootfs-release to your BOSH director _(TODO: compatibility with
   Garden-runC versions?)_
1. Add grootfs-release to the `releases` section of your deployment manifest
1. Add the `grootfs` job to the `templates` section of your cell job
1. Add the following properties to your cell job
```
garden:
  image_plugin: "/var/vcap/packages/grootfs/bin/grootfs"
  image_plugin_extra_args: "/var/vcap/jobs/grootfs/config/grootfs_config.yml"

  # if you have capi.nsync.diego_privileged_containers and capi.stager.diego_privileged_containers set to true
  privileged_image_plugin: "/var/vcap/packages/grootfs/bin/grootfs"
  privileged_image_plugin_extra_args: "/var/vcap/jobs/grootfs/config/privileged_grootfs_config.yml"
```

If you have set any of the following `garden` properties, you should them on
`grootfs` to get the same behaviour:
- `docker_registry_endpoint`
- `graph_cleanup_threshold_in_mb`
- `insecure_docker_registry_list`
- `persistent_image_list`

You may also want to set the following optional properties on `grootfs` for
various reasons. See the [grootfs job spec](jobs/grootfs/spec) for more info on
what these properties do:
- `dropsonde_port`
- `log_level`
- `store_size`

## Assumptions

### newuidmap / newgidmap

We ship custom implementations of [`newuidmap` and
`newgidmap`](https://github.com/cloudfoundry/idmapper) that ignore `/etc/subuid`
and `/etc/subgid`. These custom binaries have a specific uid/gid mapping hard
coded. Currently, Garden-runC only ever uses one this one specific mapping.
Hard coding the mapping reduces the possible attack surface for exploits, which
we care about since these binaries execute as `root`. The usual approach of
describing allowed mappings in `/etc/sub{u,g}id` doesn't play very nicely with
BOSH.

### volume creation

The release will never recreate the btrfs volume on an update if the file
already exists, even if you change it's size in the manifest. Current flow:

* If there's no volume file: create volume file -> format with btrfs -> mount
* If there's a volume file: check if it's formatted with btrfs
  * if yes -> mount
  * if no -> format with btrfs -> mount

The btrfs mount point will always owned by user ~4294967294 (or the max uid
possible) because that's the user that garden will be calling grootfs for
non-privileged containers.

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
