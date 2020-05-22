# bash-utilities

### verify-hash

`verify-hash` is a simple bash script to check if the hash of downloaded file is the same as the hash provvided on the web site. It requires `openssl` to be installed in order to work.

```bash
Usage: verify-hash.sh [-h] <hash type> <file name> <hash file>

Options: -h  Display this help message.
```

The arguments are the message digest, the name of the file to calculate the hash of and the file containing the hash itself, downloaded separately. All openssl message digest algorithms are accepted in verify-hash.sh. See 'openssl dgst' man page for more options.

### git-create-remote-repo

`git-create-remote-repo` is a bash script that creates a new, remote repository on GitHub, and then pushes the local repository from the current directory to the new remote directory. It requires an existing local repository to work.