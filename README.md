# A Starter Container

Docker's article on best practices for containers suggests making containers as small as possible. Small containers are easier to maintain, more secure, and use fewer resources. However, some researchers have asked for a container they can work inside of and use interactively. As a result, we've created this larger starter container.

Researchers looking for a more customized set of tools tailored to their needs should first consider searching Docker hub for containers that have the tools they need. If this fails, they should examine the Dockerfile included with this image and removing packages and tools they don't need while adding in the tools they require. This may require learning to use docker commands and understanding the basics of installing software on a Linux system. For frequent users of compute1, such knowledge is highly beneficial.

## Dockerfile Breakdown

### FROM (Select A Base Image)

```FROM ubuntu:latest```
[Dockerfile Documentation for FROM Command]([https://docs.docker.com/engine/reference/builder/#from](https://docs.docker.com/engine/reference/builder/#from))
Compute1 requires selecting a base image with a shell. Ubuntu is the Linux operating system that this container runs on. The latest tag indicates that every time this image is built, the most recent version of Ubuntu will be grabbed. It's possible to select specific version numbers that will change less frequently if desired.

### RUN (Run Commands)

[Dockerfile Documentation for RUN Command](https://docs.docker.com/engine/reference/builder/#run)

```apt-get update``` this is here to make sure that the list of packages availabvle is up to date.

```&&``` is used to chain commans together.

```DEBIAN_FRONTEND=noninteractive``` There can be occasional issues where Ubuntu will ask questions that it wants the user to resolve via the command line. 
This can can Docker built to fail. In some cases, it may not be needed.

```apt-get install -y``` This is the command to install packages. The ```-y``` just means that you don't want apt-get to ask if you really want to install this software; 
a behavior that would cause a Docker build to fail.

```default-jdk \``` packages that are to be installed proceed the "apt-get install" command. 
This is the default Java open JDK for the latest version of Ubuntu. Installing non default versions of Java takes more work! This version of Java may change over a period of several years.
Currently, it mirrors the version Oracle has designated for long term support for readability.

```vim emacs nano``` packages text editors.

```r-base r-base-dev``` packages for the R programming language.

## Workdir Change Working Directory

[Dockerfile documentation for WORKDIR]([https://docs.docker.com/engine/reference/builder/#workdir](https://docs.docker.com/engine/reference/builder/#workdir))
WORKDIR changes the working directory for al instructions that follow. It's worth noting that compute1's Docker wrapper will change the directory so that you won't always be in the last directory specified by the Dockerfile.

## ENV  Sets Environment Variables

[Dockerfile documentation for WORKDIR]([https://docs.docker.com/engine/reference/builder/#env](https://docs.docker.com/engine/reference/builder/#env))
```ENV LANG=C.UTF-8 LC_ALL=C.UTF-8```[Stackexchange explanation of what this does][[https://unix.stackexchange.com/questions/87745/what-does-lc-all-c-do](https://unix.stackexchange.com/questions/87745/what-does-lc-all-c-do)]
```ENV PATH=/opt:/opt/scripts:/opt/scripts/common:$PATH```
PATH tells Linux where to look for executable scripts. When using compute1 it can be usefol to set LSF_DOCKER_PRESERVE_ENVIRONMENT=false before a bsub command to preserve this environment variable. Otherwise you may have to specify the path to certain executables such as Java, bwa, and samtools in this image.

## ADD add files from a remote URL

[Dockerfile documentation for ADD](https://docs.docker.com/engine/reference/builder/#add)
Similar to COPY but has the ability to add files from a remote URL.
```ADD https://github.com/samtools/samtools/releases/download/1.6/samtools-1.6.tar.bz2 .``` Adds the file at that URL to the current directory as noted by the period.

## COPY copy files into container

[Dockerfile documenttaon for COPY](https://docs.docker.com/engine/reference/builder/#copy)
```COPY test.py /``` COPY requires both a source and a destination for the file(s) being copied. Here test.py in in the same directory as the Dockerfile and is being copies to the root directory.

## Python Unittest

[Python's unittest documentation](https://docs.python.org/3/library/unittest.html)

If you want to be absolutely certain that every application works properly, it's good to have test these applications are working properly. ```test.py``` is included in the image and contains examples of how to test an application by using the application's name and appending --version to the end. Unfortunately, bwa doesn't work like this and it's output isn't readable by Python's OS library, so there are no tests included for BWA. It's certainly possible to build on these tests to check for specific versions of applications if desirable.

```python
import unittest
import os

# Interested only that the software is present. Version isn't important.
def version_length(input):
    cmd = '{0} --version'.format(input)
    string = os.popen(cmd).read().strip('\n')
    if input != 'vim':
        # vim's output is too verbose. Versions will show when tests are run.
  print(string)
    return len(string.split(' '))

# If any test fails the build fails due to an exit code unittest provides.
class TestVersions(unittest.TestCase):

    def test_Conda(self):
        self.assertEqual(version_length('conda'), 2)

    def test_Emacs(self):
        self.assertEqual(version_length('emacs'), 39)

    def test_Git(self):
        self.assertEqual(version_length('git'), 3)

    def test_java(self):
        self.assertEqual(version_length('java'), 15)

    def test_Nano(self):
        self.assertEqual(version_length('nano'), 26)

    def test_Python(self):
        self.assertEqual(version_length('python'), 2)

    def test_R(self):
        self.assertEqual(version_length('R'), 51)

    def test_Samtools(self):
        self.assertEqual(version_length('samtools'), 9)

    def test_Vim(self):
        self.assertEqual(version_length('vim'), 1005)

if __name__ == '__main__':
    unittest.main()
```