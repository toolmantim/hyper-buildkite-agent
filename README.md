# hyper-buildkite-agent

A docker-enabled [Buildkite](https://buildkite.com/) Agent that runs on [hyper.sh](https://hyper.sh/).

Usage:

```shell
hyper run --rm toolmantim/hyper-buildkite-agent start
```

## Secure token and git credential storage

You can store the Buildkite Agent token and [git credentials](https://git-scm.com/docs/git-credential-store#_storage_format) in a container volume, and mount them into the container, rather than using insecure environment variables.

To do this you'll need to first create the secrets container:

```
hyper run --name buildkite-agent-secrets -d -v /buildkite-agent-secrets hyperhq/nfs-server
```

Enter the container and add in any credentials:

```
hyper exec <secrets-container-id> bash
vi /buildkite-agent-secrets/buildkite-agent.cfg
vi /buildkite-agent-secrets/git-credentials
exit
```

Now you can start an agent, mounting the `/buildkite-agent-secrets` volume into it:

```
hyper run --rm --volumes-from buildkite-agent-secrets toolmantim/hyper-buildkite-agent start
```

The agent should start up using the token from the `buildkite-agent.cfg` file, and be able to clone from private repositories based on the `git-credentials` file.

## Credits

* Builds upon [ptptptptptpt/docker-in-hyper](https://github.com/ptptptptptpt/docker-in-hyper)

## License

MIT (see [License.md](License.md))