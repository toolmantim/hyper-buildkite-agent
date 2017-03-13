# hyper-buildkite-agent

A [Buildkite](https://buildkite.com/) Agent that runs on [hyper.sh](https://hyper.sh/). It ships with a running Docker daemon so you're able to build docker images and use Docker Compose for testing.

Usage:

```shell
hyper run -it --rm toolmantim/hyper-buildkite-agent start
```

## Getting started

To get started you'll need a builds volume to cache git checkouts and secrets.

Firstly, create a `buildkite-data` container with volumes for builds and secrets:

```shell
hyper run --name buildkite-data -d -v /buildkite-builds -v /buildkite-secrets hyperhq/nfs-server
```

Secondly, add your agent token and SCM credentials to the secrets volume:

```shell
hyper run -it --rm --volumes-from buildkite-data bash
echo 'token=<agent-token>' > /buildkite-secrets/buildkite-agent.cfg
echo 'https://<user>:<pass>@scm.org' > /buildkite-secrets/git-credentials
exit
```

Now you can start an agent:

```shell
hyper run -it --rm --volumes-from buildkite-data toolmantim/hyper-buildkite-agent start
```

You should now see the agent connected in Buildkite, and can successfully run a build (using Docker Compose if you like) of a private repository.

## Scheduler mode

(Note: Scheduler mode doesn't quite work yet)

You can run your build jobs completely on-demand by running an agent in scheduler mode. This scheduler agent will spin up Hyper containers on demand for each job, allowing per-second CI billing for jobs, and the ability to run as many parallel jobs as your container quota allows.

To start the scheduler, add your hyper login credentials to the secrets volume:

```shell
# Start a container
hyper run -it --rm --volumes-from buildkite-data --entrypoint bash toolmantim/hyper-buildkite-agent
# In the container, do a hyper login
hyper --config /buildkite-secrets/hyper config
# Exit the container
exit
```

Now start a scheduler agent by setting the `HYPER_SCHEDULER=true` environment variable:

```
hyper run -d --size=S2 --volumes-from buildkite-data --name buildkite-job-scheduler -e HYPER_SCHEDULER=true toolmantim/hyper-buildkite-agent start --meta-data "queue=hyper" --name "hyper-scheduler-%n"
```

Now you can run Buildkite jobs targeting the scheduler (e.g. `queue=hyper`) and they'll be run and rescheduled on-demand to be run in one-off Hyper containers.

Configuration environment variables for the scheduler mode agent:

* `HYPER_RUNNER_SIZE` - The [Hyper.sh container size](https://hyper.sh/pricing.html) for your job runners. Default: `"S4"`

## Volumes

### `/buildkite-builds`

To cache git checkouts effectively you need to mount a persistent volume to `/buildkite-builds`.

### `/buildkite-secrets`

Instead of using insecure environment variables, or command line arguments, you should store secrets in a persistent volume mounted to `/buildkite-secrets`.

Secrets files that are automatically read and used by the agent:

* `/buildkite-secrets/buildkite-agent.cfg` - [Buildkite Agent config file](https://buildkite.com/docs/agent/configuration) containing the agent token and any other agent settings you wish.
* `/buildkite-secrets/git-credentials` - [git credentials file](https://git-scm.com/docs/git-credential-store#_storage_format) to be used by git when cloning private https repositories (e.g. `https://<user>:<token>@github.com`)
* `/buildkite-secrets/hyper/config.json` - [hyper.sh cli](https://git-scm.com/docs/git-credential-store#_storage_format) credentials, when used in scheduler mode.

You can also add any other secrets that you want to make available to your agents.

## Credits

* Builds upon [ptptptptptpt/docker-in-hyper](https://github.com/ptptptptptpt/docker-in-hyper)

## License

MIT (see [License.md](License.md))