binrep
======

Simple static binary repository manager on Amazon S3 as backend storage.

# Overview

`binrep` provides a simple way to store and deploy your static binary files such as Go binary. binrep pushes the binary files into your S3 bucket, builds the directory layout like `go get` does on the bucket, and pulls the binary files from the bucket.

The deployment of (internel) tools written by Go takes a lot more works, especially in the environment with many servers, than that of no-dependent LL scripts such as shell script, Perl, Python, Ruby). Git is an informat approach to the deployment, but git is not for binary management. The next approach is a package manager such apt or yum, but it takes a lot of trouble to make packages. The other approach is just to use a HTTP file server including S3, but it needs uniform and accessible location of the binary files and version management. There, `binrep` resolves the problem of the binary management.

# Usage

## Prepareation

- Create S3 bucket for `binrep`.
- Install `binrep` binary, see https://github.com/yuuki/binrep/releases .

## Commands

### list

```sh
$ binrep list --endpoint s3://binrep-bucket
github.com/fujiwara/stretcher/20171013135903/
github.com/fujiwara/stretcher/20171014110009/
github.com/motemen/ghq/20171013140424/
github.com/yuuki/droot/20171017152626/
github.com/yuuki/droot/20171018125535/
github.com/yuuki/droot/20171019204009/
...
```

### show

```sh
$ binrep show --endpoint s3://binrep-bucket github.com/yuuki/droot
NAME                    TIMESTAMP       BINNARY1
github.com/yuuki/droot  20171019204009  droot//2e6ccc3
```

### push

```sh
$ binrep push --endpoint s3://binrep-bucket github.com/yuuki/droot ./droot
--> Uploading [./droot] to s3://binrep-bucket/github.com/yuuki/droot/20171020152356
Uploaded to s3://binrep-bucket/github.com/yuuki/droot/20171020152356
--> Cleaning up the old releases
Cleaned up 20171017152626
```

`push` supports to push multiple binary files.

### pull

```sh
$ binrep pull --endpoint s3://binrep-bucket github.com/yuuki/droot /usr/local/bin
--> Downloading s3://binrep-bucket/github.com/yuuki/binrep/20171019204009 to /usr/local/bin
```

### sync

```sh
$ binrep sync --endpoint s3://binrep-bucket --concurrency 4 --max-bandwidth '5 MB' /opt/binrep/
Set max bandwidth total: 10 MB/sec, per-release: 2.5 MB/sec
--> Downloading to /opt/binrep/github.com/fujiwara/stretcher/20171014110009/
--> Downloading to /opt/binrep/github.com/motemen/ghq/20171013140424/
--> Downloading to /opt/binrep/github.com/yuuki/droot/20171019204009/
...
```

`sync` skips the download if there are already the same timestamp release on local filesystem.

# Directory layout on S3 bucket

```
s3://<bucket>/<host>/<user>/<project>/<timestamp>/
                                         -- <bin>
                                         -- meta.yml
```

The example below.

```
s3://binrep-repository/
|-- github.com/
    -- yuuki/
        -- droot/
            -- 20171013080011/
                -- droot
                -- meta.yml
            -- 20171014102929/
                -- droot
                -- meta.yml
    -- prometheus/
        -- prometheus/
            -- 20171012081234/
                -- prometheus
                -- promtool
                -- meta.yml
|-- ghe.internal/
    -- opsteam/
        -- tools
            -- 20171010071022/
                -- ec2_bootstrap
                -- ec2_build_ami
                -- mysql_create_slave_snapshot

```

# Terms

- `release`: `<host>/<user>/<project>/<timestamp>/`

# How to release

binrep uses the following tools for the artifact release.

- [goreleaser](https://goreleaser.com/)
- [gobump](https://github.com/motemen/gobump)
- [ghch](https://github.com/Songmu/ghch)

```sh
make release
```

# License

[The MIT License](./LICENSE).

# Author

[y_uuki](https://github.com/yuuki)
