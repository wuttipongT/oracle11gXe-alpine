Oracle Database 11g Express Edition Docker image (Alpine)
=======================================================

This is a Oracle image to easily build an Oracle environment for test purposes.

Prerequisites
-------------

- Oracle Database 11g Release 2 Express Edition requires Docker 1.10.0 and above. *(Docker supports ```--shm-size``` since Docker 1.10.0)*
- Oracle Database 11g Release 2 Express Edition uses shared memory for MEMORY_TARGET and needs at least 1 GB.

## How to build

- Download the official Oracle Database 11g Release 2 Express Edition installer on the [oracle site](https://www.oracle.com/database/technologies/xe-prior-releases.html)
- Put the archive `oracle-xe-11.2.0-1.0.x86_64.rpm.zip` in the root directory
- Execute  `docker build -t <image name>:<tag> . --build-arg ORACLE_RPM="oracle-xe-11.2.0-1.0.x86_64.rpm.zip"`. It will create the image and install Oracle on it. it can take some time.   

## How to run

The Oracle instance can be launched with this command :
```
docker run -d -P --shm-size=1g -v db_data:/u01/app/oracle/oradata -p 1521:1521 <image name>:<tag>
```

## Usage Example

A build of the image is available on the [docker hub](https://hub.docker.com/r/bedwuttipong/oracle/).

```
docker run -d -P --shm-size=1g -v db_data:/u01/app/oracle/oradata -p 1521:1521 bwutti/oracle:11gXe-alpine
```

The default list of ENV variables is:

```
PROCESSES=500
SESSIONS=555
TRANSACTIONS=610
```

## Connect to database

with the naming system and password ```password```.

## Thankful
* [cosmomill](https://github.com/cosmomill/docker-alpine-oracle-xe)
