When copying source files from the build context, paths are interpreted as relative to the root of the context.

Specifying a source path with a leading slash or one that navigates outside the build context, such as `COPY ../something /something`, automatically removes any parent directory navigation (`../`). Trailing slashes in the source path are also disregarded, making `COPY something/ /something` equivalent to `COPY something /something`.

==If the source is a directory, the contents of the directory are copied, including filesystem metadata. The directory itself isn't copied, only its contents.== If it contains subdirectories, these are also copied, and merged with any existing directories at the destination. Any conflicts are resolved in favor of the content being added, on a file-by-file basis, except if you're trying to copy a directory onto an existing file, in which case an error is raised.

If the source is a file, the file and its metadata are copied to the destination. File permissions are preserved. If the source is a file and a directory with the same name exists at the destination, an error is raised.

If you pass a Dockerfile through stdin to the build (`docker build - < Dockerfile`), there is no build context. In this case, you can only use the `COPY` instruction to copy files from other stages, named contexts, or images, using the [`--from` flag](https://docs.docker.com/reference/dockerfile/#copy---from). You can also pass a tar archive through stdin: (`docker build - < archive.tar`), the Dockerfile at the root of the archive and the rest of the archive will be used as the context of the build.

When using a Git repository as the build context, the permissions bits for copied files are 644. If a file in the repository has the executable bit set, it will have permissions set to 755. Directories have permissions set to 755.^[1]

```bash
$ tree
.
├── dir
│   ├── a.txt
│   └── b.txt
└── Dockerfile

2 directories, 3 files
```

```dockerfile
FROM alpine:latest

WORKDIR /app

COPY ./* .

CMD tree
```

```bash
$ docker build -t pig .

$ docker run pig:latest
.
├── Dockerfile
├── a.txt
└── b.txt

0 directories, 3 files
```

[1]: https://docs.docker.com/reference/dockerfile/#copying-from-the-build-context
