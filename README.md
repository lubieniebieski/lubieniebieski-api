# lubieniebieski-api

## Development

Ruby 4.0.9 is managed by [mise](https://mise.jdx.dev/) locally and in CI.

```sh
mise trust
mise install
mise run setup
mise run test
mise run server
```

Keep the Ruby version in `mise.toml`, `.ruby-version`, and `Dockerfile` in sync.
The Gemfile reads `.ruby-version`. Bundler is pinned to 4.0.24 in
`Gemfile.lock`, `mise.toml`, and `Dockerfile`.

Most important command are run through Makefile:

- `server`: Starts the server.
- `lint`: Runs `rubocop` with the `-A` flag to automatically fix linting issues.
- `deploy`: Deploys the application to fly.io.
- `update_links`: Updates link repository