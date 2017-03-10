# hyper-buildkite-agent

A [Buildkite](https://buildkite.com/) Agent that runs on [hyper.sh](https://hyper.sh/). It ships with a running Docker daemon so you're able to build docker images and use Docker Compose for testing.

Usage:

```shell
hyper run -it --rm toolmantim/hyper-buildkite-agent start
```

## Getting started

To get started you'll need a builds volume to cache git checkouts, and a secrets volume for storing the agent token and git credentials.

Firstly, create a builds container volume:

```shell
hyper run --name buildkite-data -d -v /buildkite/builds -v /buildkite/secrets hyperhq/nfs-server
```

Secondly, add your agent token and SCM credentials to the secrets volume:

```shell
hyper run -it --rm --volumes-from buildkite-data --workdir /buildkite bash
echo 'token="<agent-token>"' > /buildkite/secrets/buildkite-agent.cfg'
echo 'https://<user>:<pass>@scm.org' > /buildkite/secrets/git-credentials
exit
```

Finally, start an agent:

```shell
hyper run -d --rm --volumes-from buildkite-data toolmantim/hyper-buildkite-agent start
```

You should now see the agent connected in Buildkite, and can successfully run a build (using Docker Compose if you like) of a private repository.

## Volumes

### `/buildkite/builds`

To cache git checkouts effectively you need to mount a persistent volume to `/buildkite/builds`.

### `/buildkite/secrets`

Rather than using insecure environment variables or command line arguments you should store secrets, such as the agent token or SCM credentials, in a persistent volume mounted to `/buildkite/secrets`.

Files:

* `/buildkite/secrets/buildkite-agent.cfg` - a Buildkite Agent config file containing a Buildkite agent token, and any other settings.
* `/buildkite/secrets/git-credentials` - a [git credentials file](https://git-scm.com/docs/git-credential-store#_storage_format) that will be used by git when cloning private https repositories.

## Credits

* Builds upon [ptptptptptpt/docker-in-hyper](https://github.com/ptptptptptpt/docker-in-hyper)

## License

MIT (see [License.md](License.md))