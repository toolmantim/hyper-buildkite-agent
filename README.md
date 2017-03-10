# hyper-buildkite-agent

A [Buildkite](https://buildkite.com/) Agent that runs on [hyper.sh](https://hyper.sh/). It ships with a running Docker daemon so you're able to build docker images and use Docker Compose for testing.

Usage:

```shell
hyper run --rm toolmantim/hyper-buildkite-agent start
```

## Secure token and git credential storage

You can store the [Buildkite Agent config](https://buildkite.com/docs/agent/configuration) and [git credentials](https://git-scm.com/docs/git-credential-store#_storage_format) in a container volume, and mount them into the container, rather than using insecure environment variables.

To do this you'll need to first create the secrets container:

```shell
hyper run --name buildkite-agent-secrets -d -v /buildkite-agent-secrets hyperhq/nfs-server
```

Enter the container and add in any credentials:

```shell
hyper exec -it secrets-container-id bash
vi /buildkite-agent-secrets/buildkite-agent.cfg
vi /buildkite-agent-secrets/git-credentials
exit
```

Now you can start an agent, mounting the `/buildkite-agent-secrets` volume into it:

```
hyper run --rm --volumes-from buildkite-agent-secrets toolmantim/hyper-buildkite-agent start
```

The agent should now start using the token from `buildkite-agent.cfg`, and be able to clone private repositories using the credentials in `git-credentials`.

## Credits

* Builds upon [ptptptptptpt/docker-in-hyper](https://github.com/ptptptptptpt/docker-in-hyper)

## License

MIT (see [License.md](License.md))