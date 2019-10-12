# GitHub Action for Deploying via `rsync` Over `ssh`

## Disclaimer

GitHub actions is still [in limited public beta](https://github.com/features/actions) and advises against [usage in production](https://developer.github.com/actions/).

This action requires ssh private keys (see secrets), and **may thus be vulnerable**.
The ssh authentification **may need improvement** (see [issues](https://github.com/bvelastegui/rsync/issues)).


## Secrets

This action requires two secrets to authenticate over ssh:

- `SSH_PRIVATE_KEY`
- `SSH_PUBLIC_KEY`

You get both of these from the server you interact with.

Remember to never commit these keys, but [provide them through the GitHub UI](https://developer.github.com/actions/creating-workflows/storing-secrets/) (repository settings/secrets).


## Environment Variables

This action requires three environment variables used to register the target server in `$HOME/.ssh/known_hosts`.
This is to make sure that the action is talking to a trusted server.

**`known_hosts` verification currently fails and is overriden, see [issue 1](https://github.com/maxheld83/rsync/issues/1)**.

- `HOST_NAME` (the name of the server you wish to deploy to, such as `foo.example.com`)
- `HOST_IP` (the IP of the server you wish to deploy to, such as `111.111.11.111`)
- `HOST_FINGERPRINT` (the fingerprint of the server you wish to deploy to, can have different formats)


## Required Arguments

`rsync` requires `[ARGS FOLDER HOST_USERNAME@HOST_NAME:HOST_DESTINATION`:

- `ARGS` (arguments for *rsync*, such as `"-avzr --delete"`)
- `FOLDER` (the folder to sync, such as `"dist/"`)
- `HOST_USERNAME` (the username of the server you wish to deploy to)
- `HOST_DESTINATION` (the destination of the server you wish to deploy to, such as `"/home/user/nodeapp"`)

For action `rsync` options, see `entrypoint.sh` in the source.
For more options and documentation on `rsync`, see [https://rsync.samba.org](https://rsync.samba.org).

## Example Usage

```yaml
name: Node CI

on: [push]

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v1
    - name: Use Node.js 10.x
      uses: actions/setup-node@v1
      with:
        node-version: 10.x
    - name: Install npm dependencies and build for deployment
      run: |
        npm install
        npm build
      env:
        NODE_ENV: production
    - name: Deploy to Server
      uses: bvelastegui/rsync
      env:
        HOST_NAME: ${{ secrets.HOST_NAME }}
        HOST_IP: ${{ secrets.HOST_IP }}
        HOST_FINGERPRINT: ${{ secrets.HOST_FINGERPRINT }}
        SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
        SSH_PUBLIC_KEY: ${{ secrets.SSH_PUBLIC_KEY }}
        HOST_USERNAME: ${{ secrets.HOST_USERNAME }}
        HOST_DESTINATION: ${{ secrets.HOST_DESTINATION }}
        FOLDER: ""
        ARGS: "-avzr --delete"
```
