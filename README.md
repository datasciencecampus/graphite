# G R A P H I T E

**graphite** [origin: german] _noun_
**Definitions:**
1. a very common mineral, soft native carbon, occurring in black to dark-gray foliated masses, with metallic luster and greasy feel: used for pencil leads, as a lubricant, and for making crucibles and other refractories; plumbago; black lead;
2. to write, draw

<p align="center"><img align="center" src="meta/logo/graphite_logo_v1.png" width="400px"></p>

## Contents

* [Introduction](#introduction)
* [Software Prerequisites](#software-prerequisites)
* [GTFS feed](#gtfs-feed)
  * [Sample GTFS data](#˜sample-gtfs-data)  
* [Creating and running an OpenTripPlanner server](#creating-and-running-an-opentripplanner-server)
  * [Java method](#java-method)
  * [Docker method](#docker-method)
* [FAQ](#faq)    

## Introduction

This repository shows how you can build an OpenTripPlanner server locally using a [Java Virtual Machine](https://en.wikipedia.org/wiki/Java_virtual_machine) (JVM) or [Docker](https://en.wikipedia.org/wiki/Docker_%28software%29).

## Software Prerequisites

* For GTFS building (optional)
  * A C# compiler such as Visual Studio Code, AND
  * MySQL
* For OTP server (required)
  * Java SE Runtime Environment 8 (preferrably 64-bit) [[download here]](https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html), OR
  * [Docker](https://www.docker.com/)

## GTFS feed

An OpenTripPlanner server can be built without a [General Transit Feed Specification](https://en.wikipedia.org/wiki/General_Transit_Feed_Specification) (GTFS) dataset. However, a GTFS feed is required to analyse public transport. Without it you can analyse car, bicycle, and foot transport using OpenStreetMap (OSM) data.

### Sample GTFS data

The [Data Science Campus](https://datasciencecampus.ons.gov.uk/) has created some cleaned GTFS data from March 2019 (using the [guide here](https://github.com/datasciencecampus/graphite/tree/master/example.md)) for:

* buses in Cardiff, Wales, UK. [Download, 1.7MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/cardiff_bus/Cardiff-gtfs.zip)
* buses in Wales, UK. [Download, 22.3MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/wales_bus/W_GTFS.zip)
* buses in Scotland, UK. [Download, 34.6MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/scotland_bus/S_GTFS.zip)
* buses in East Anglia, England, UK. [Download, 3.5MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/EA_GTFS.zip)
* buses in East Midlands, England, UK. [Download, 28.0MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/EM_GTFS.zip)
* buses in Greater London, England, UK. [Download, 99.8MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/L_GTFS.zip)
* buses in the North East, England, UK. [Download, 43.4MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/NE_GTFS.zip)
* buses in the North West, England, UK. [Download, 34.1MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/NW_GTFS.zip)
* buses in the South East, England, UK. [Download, 55.3MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/SE_GTFS.zip)
* buses in the South West, England, UK. [Download, 26.7MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/SW_GTFS.zip)
* buses in the West Midlands, England, UK. [Download, 25.5MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/WM_GTFS.zip)
* buses in Yorkshire, England, UK. [Download, 29.2MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/Y_GTFS.zip)
* national coaches in the UK. [Download, 1.2MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/ncsd/NCSD_GTFS.zip)
* trains in the UK. [Download, 21.4MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/uk_train/train_GTFS.zip)

The Data Science Campus has also created a bespoke OpenStreetMap (osm) file for Cardiff, Wales, UK for March 2019:

* Cardiff OSM file. [Download, 101.1MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/cardiff_osm/cardiff.osm)

OSM files for all other regions can be downloaded from [geofabrik](https://download.geofabrik.de/).

**Note**: _these GTFS do not contain the most recent timetables, it is only designed as a practice set of GTFS data for use with the propeR tool. Some (but not most) services have end dates of 2018-08-15, 2018-09-02, 2018-10-31. Therefore, analysing journeys after these dates will not include these services. Most services have an end date capped at 2020-01-01._

## Creating and running an OpenTripPlanner server

### Java method

[OpenTripPlanner (OTP)](http://www.opentripplanner.org/) is an open source multi-modal trip planner, which runs on Linux, Mac, Windows, or potentially any platform with a JVM. More details, including basic tutorials can be found [here](http://docs.opentripplanner.org/en/latest/). Guidance on how to setup the OpenTripPlanner locally can be found [here](https://github.com/opentripplanner/OpenTripPlanner/wiki). Here is the method that worked for us:

1. Check you have the latest java SE runtime installed on your computer, preferrably the 64-bit version on a 64-bit computer. The reason for this is that the graph building process in step 7 uses a lot of memory. The 32-bit version of java might not allow a sufficient heap size to be allocated to graph and server building. For the GTFS sample data [here](add link), a 32-bit machine may suffice.
2. Create an 'otp' folder in a preferred root directory.
3. Download the latest single stand-alone runnable .jar file of OpenTripPlanner [here](https://repo1.maven.org/maven2/org/opentripplanner/otp/). Choose the '-shaded.jar' file. Place this in the 'otp' folder.
4. Create a 'graphs' folder in the 'otp' folder.
5. Create a 'default' folder in the 'graphs' folder.
6. Put the GTFS ZIP folder(s) in the 'default' folder along with the latest OpenStreetMap .osm data for your area, found [here](https://download.geofabrik.de/europe/great-britain/wales.html). If you're using the sample GTFS data, an .osm file for Cardiff can be found [here](https://github.com/datasciencecampus/access-to-services/tree/master/propeR/data/osm).
7. Build the graph by using the following command line/terminal command whilst in the 'otp' folder:

    ```
    java -Xmx4G -jar otp-1.3.0-shaded.jar --build graphs/default
    ```
  changing the shaded.jar file name and end folder name to be the appropriate names for your build. '-Xmx4G' specifies a maximum heap size of 4G memory, graph building may not work with less memory than this.

8. Once the graph has been build you should have a 'Graphs.obj' file in the 'graphs/default' folder. Now initiate the server using the following command from the 'otp' folder:

    ```
    java -Xmx4G -jar otp-1.3.0-shaded.jar --graphs graphs --router default --server
    ```
Again, checking the shaded.jar file and folder names are correct.

9. If successful, the front-end of OTP should be accessible from your browser using [http://localhost:8080/](http://localhost:8080/).

### Docker method

For convenience we have created several docker images to run an OTP server for several regions in the UK. First you must install Docker. To run, type in the command line (parse `-d` flag to daemonise):

```
docker run -p 8080:8080 datasciencecampus/<docker_image>:<tag_number>
```

where `<docker_image>` is:

* `dsc_otp:1.0` ([docker image for Cardiff, Wales, UK from March 2019, 313MB](https://hub.docker.com/r/datasciencecampus/dsc_otp))
* `dsc_otp_wales_mar19:1.0` ([docker image for Wales, UK from March 2019, 693MB](https://hub.docker.com/r/datasciencecampus/dsc_otp_wales_mar19))
* `dsc_otp_scotland_mar19:1.0` ([docker image for Scotland, UK from March 2019, 850MB](https://hub.docker.com/r/datasciencecampus/dsc_otp_scotland_mar19))
* `dsc_otp_england_mar19:1.0` ([docker image for England, UK from March 2019, 2350MB](https://hub.docker.com/r/datasciencecampus/dsc_otp_england_mar19))

#### Killing a Docker container

To kill a docker container first list all containers running using:

```
docker ps
```

Then:

```
docker stop <container>
```

#### Building your own Docker container

A stand-alone OTP server can also be built and deployed in the [otp/](otp/) directory by editing the `Dockerfile` and `build.sh` files.

## FAQ

Q: Do I need an OpenStreetMap (.osm) file to build a graph?

>A: Yes, whilst you can build the graph without an .osm file. You will need it to analyse the graph.

Q: Do I need a GTFS file to build a graph?

>A: An OpenTripPlanner server can be built without a [General Transit Feed Specification](https://en.wikipedia.org/wiki/General_Transit_Feed_Specification) (GTFS) dataset. However, a GTFS feed is required to analyse public transport. Without it you can analyse car, bicycle, and foot transport using OpenStreetMap (OSM) data.

Q: I found a bug!

>A: Please use the [GitHub issues](https://github.com/datasciencecampus/graphite/issues) form to provide us with the information.

## Authors / Contributors

#### Data Science Campus - Office for National Statistics
* [Michael Hodge](https://github.com/mshodge)
* [Phillip Stubbings](https://github.com/phil8192)

## Contributions and Bug Reports

We welcome contributions and bug reports. Please do this on this repo and we will endeavour to review pull requests and fix bugs in a prompt manner.

## Licence

The Open Government Licence (OGL) Version 3

Copyright (c) 2018 Office of National Statistics

This source code is licensed under the Open Government Licence v3.0. To view this licence, visit [www.nationalarchives.gov.uk/doc/open-government-licence/version/3](www.nationalarchives.gov.uk/doc/open-government-licence/version/3) or write to the Information Policy Team, The National Archives, Kew, Richmond, Surrey, TW9 4DU.
