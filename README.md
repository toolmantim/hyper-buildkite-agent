# hyper-buildkite-agent

A [Buildkite](https://buildkite.com/) Agent that runs on [hyper.sh](https://hyper.sh/). It ships with a running Docker daemon so you're able to build docker images and use Docker Compose for testing.

Usage:

```shell
hyper run -it --rm toolmantim/hyper-buildkite-agent start
```

See also:

* [hyper-buildkite-agent-scheduler](https://github.com/toolmantim/hyper-buildkite-agent-scheduler)
* [hyper-buildkite-agent-runner](https://github.com/toolmantim/hyper-buildkite-agent-runner)

## Getting started

To get started you'll need a builds volume to cache git checkouts, and a secrets volume for storing the agent token and git credentials.

Firstly, create a `buildkite-data` container with volumes for builds and secrets:

```shell
hyper run --name buildkite-data -d -v /buildkite/builds -v /buildkite/secrets hyperhq/nfs-server
```

Secondly, add your agent token and SCM credentials to the secrets volume:

```shell
hyper run -it --rm --volumes-from buildkite-data bash
echo 'token=<agent-token>' > /buildkite/secrets/buildkite-agent.cfg
echo 'https://<user>:<pass>@scm.org' > /buildkite/secrets/git-credentials
exit
```

Now you can start an agent:

```shell
hyper run -it --rm --volumes-from buildkite-data toolmantim/hyper-buildkite-agent start
```

You should now see the agent connected in Buildkite, and can successfully run a build (using Docker Compose if you like) of a private repository.

## Volumes

### `/buildkite/builds`

To cache git checkouts effectively you need to mount a persistent volume to `/buildkite/builds`.

### `/buildkite/secrets`

Instead of using insecure environment variables, or command line arguments, you should store secrets in a persistent volume mounted to `/buildkite/secrets`.

Secrets files that are automatically read and used by the agent:

* `/buildkite/secrets/buildkite-agent.cfg` - [Buildkite Agent config file](https://buildkite.com/docs/agent/configuration) containing the agent token and any other agent settings you wish.
* `/buildkite/secrets/git-credentials` - [git credentials file](https://git-scm.com/docs/git-credential-store#_storage_format) to be used by git when cloning private https repositories (e.g. `https://<user>:<token>@github.com`)

You can also add any other secrets that you want to make available to your agents.

## Credits

* Builds upon [ptptptptptpt/docker-in-hyper](https://github.com/ptptptptptpt/docker-in-hyper)

## License

MIT (see [License.md](License.md))