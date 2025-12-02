# CodeSanta

Code Santa is a simple Slack bot that posts [Advent of Code](https://www.adventofcode.com) to a slack channel. It tries
to replicate as much of the original formatting as possible, including:

The application requires little configuration and comes with a [Dockerfile](Dockerfile) so it's very easy to get going for your own Slack workspace.

## Features

### Automatic message posting

Automatically posts new AoC puzzles 5 minutes after they are released (that is, at 00:05 EST). Should the message fail to be posted for whatever reason, the application will try again every 10 minutes, up to a maximum of 20 attempts. If the 20th attempt fails (e.g. the puzzle hasn't been posted by 03:15 EST), it will stop trying indefinitely. Check out [the troubleshooting section](#troubleshooting) for help.

### Text formatting

Code Santa tries to replicate as much of the original text formatting as possible using [Slack's message formatting capabilities](https://slack.com/help/articles/202288908-Format-your-messages). The supported formatting includes:

- _bold_
- ⭐ _stars_ ⭐
- [links](https://adventofcode.com/)
- `code snippets`
- ```
  code blocks
  ```

## Deploying

### Environment variables

All the necessary environment variables are documented in the [.mise.local.example.toml](.mise.local.example.toml) environment file. You will need [mise](https://mise.jdx.dev/) in order to use it.

For more information on how to get the OAuth token, and creating Slack apps in general, follow [this official guide](https://api.slack.com/authentication/basics).

### Fly.io

This app comes with a [fly.io configuration file](fly.toml), making ready to deploy on fly. It also fits very comfortably in fly's free tier. Here are the steps you need to follow:

1. Create your own app
1. Change the app name in the configuration file (this will be done automatically if you create your app using `fly launch`)
1. Provision a database and associate it with your application
1. Deploy!

You can check out [fly's documentation](https://fly.io/docs/) for more information on how to accomplish these steps.

## Troubleshooting

This app uses [Elixir](https://elixir-lang.org/) and [Oban](https://getoban.pro/) to handle the automatic download and publication of the puzzles. This means that all job errors are stored in the PostgreSQL database that supports the application under the `oban_jobs` table.

To view the errors, you can either access the database directly or fetch the jobs through a live interactive Elixir shell on your server. It is highly recommended to use the interactive shell approach as it will also be the easiest and safest way to fix issues or manually retry jobs should you need to.

## Contributing

### Dependencies

The specific language runtimes required by the application are listed in the [mise.toml](mise.toml) file. If you use [mise](https://mise.jdx.dev) you can install them with `mise install`. Otherwise, any recent of Erlang and Elixir should do the trick.

If you used the following command, you shouldn't have to change the default database url provided in [.env.dev.example](.env.dev.example).

### Setting up the project

You can use the `mix setup` command to install the project's dependencies and perpare the database for development.
