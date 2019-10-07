For the application image we inherited from the `fedora:30` base image. You are not limited to deriving direct from an operating system base image. You can create your own intermediate base image. This will derive from the operating system base image, but add extra functionality you need which is common to many applications. Your application then derives from this image.

What we will do first is create an intermediate image which encapsulates what was required to add the dedicated user and lock down access to the `root` user.

Change to the `~/common-base-v1` sub directory.

```execute
cd ~/common-base-v1
```

View the contents of the `Dockerfile` by running:

```execute
cat Dockerfile
```

This is the same common instructions we had previously, but we have collapsed some of the instructions together to reduce the number of layers which are created in the container image.

We have also added a `container-usage` script and set it as the default command for the container image. When run it will display a simple usage message and exit. The intent is that this would be overridden in a derived image using the `CMD` instruction.

Build the image:

```execute
podman build -t common-base:v1 .
```

and run the image to see the default usage message:

```execute
podman run --rm common-base:v1
```

We could add to this common base image what we need for Python, but because we may want to create application images for other languages at some point, we can create an intermediate base image just for Python. This Python image can inherit from the common base image we just created though so we aren't duplicating it.

Change to the `~/python-base-v1` sub directory.

```execute
cd ~/python-base-v1
```
View the contents of the `Dockerfile` by running:

```execute
cat Dockerfile
```

For using Python, we need the system language package which includes locale definitions and we know we will also need additional system packages to enable us to build Python extension modules, so we add them now.

Because the common base image was closed off with a `USER` of 1001, we need to switch back to `root` to install the system packages, and then revert to the dedicated user once done.

In the `RUN` command for installing the additional system packages take note that we set the `HOME` environment variable for the command to `/root`, which is the home directory for `root`. This will temporarily override the setting for `HOME` defined in the common base image which referenced the home directory of the dedicated user.

This is done so that any commands we run as `root`, do not drop files into the home directory for our dedicated user. This can occur where cache files or other user specific credential files are written out. If we don't change `HOME`, we would have to ensure we removed them from the home directory of the dedicated user. If we were to forget it can be hard in some cases to clean things up later. Best thing to do therefore is to override the `HOME` environment variable for the command so that it drops such files in the home directory of `root` instead.

We have also set the environment variables discussed previously for setting UTF-8 as the default encoding, and disabled buffering of `stdout` by Python.

Build the image:

```execute
podman build -t python-base:v1 .
```

Run the image to verify the environment variables have been set:

```execute
podman run --rm python-base:v1
```
