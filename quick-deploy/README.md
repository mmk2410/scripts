# Quick Deploy

Quick Deploy is a simple and dirty script-based solution for continous delivery.

## Basic idea

You have a Git server (like [Gitea](https://gitea.io), but just a bare repo should also work) where you host a repo that you want to deploy somewhere. The somewhere (same or other server) has a Web Server with PHP capabilities running (my use case: I develop a TYPO3 site package, TYPO3 runs on PHP). In your Git repo (server-side) you define post-receive Git hook which just sends a simple HTTP GET request your deploy-server (over HTTTPS, of course) like https://example.com/quick-deploy.php?secret=YOUR_SECRET. Where your secret is known to you, your git post-receive hook and the quick-deploy script. If the given secret matches the predefinded than a pull request in the given repository is attempted. It git fails, a 500 error will be returned. Additionally the git output will be printed.

## Setup

1. Download the `quick-deploy.php` script and the `config.example.json` in a public accesible folder on your server where you want to deploy your code.
1. Create a secret. For example run `openssl rand -base64 42`
1. Copy (or rename) the `config.example.json` and edit it to your liking. You can find a list of options and their requirement later. Remove the example file afterwards.
1. Set correct permissions on `config.json`. It needs to be readable by the `quick-deploy.php` script (presumably run by the user `www-data`) but must not be accessible over the web. Otherwise your secret is no longer one. `chmod 600 config.json` should do that.
1. Create g Git post-receive-hook in your Git repository like the following:

```
#!/bin/sh
curl https://your.deploy.server/quick-deploy.php?secret=YOUR_SECRET
```

## Configuration variables

Here is a alphabetically list of possible configuration variables and if it is necessary that their set.

| Key | Default | Required | Description |
| --- | ------- | -------- | ----------- |
| `branch` | `master` | No | Branch which should be used |
| `local-path` | N/A | Yes | Path of the deployed git repository |
| `remote-path` | N/A | Yes | Path or URL of the remote Git repository |
| `secret` | N/A | Yes | Secret which is exchanged as GET paramter |

## Contribute

Feel free to contribute if you want to.
