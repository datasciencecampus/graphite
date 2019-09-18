# graphite manual

<p align="center"><img align="center" src="meta/logo/propeR_logo_v1.png" width="200px"></p>

## Contents

* [Introduction](#introduction)

* [Software Prerequisites](#software-prerequisites)

* [GTFS feed](#gtfs-feed)
  	* [Creating a GTFS feed](#creating-a-gtfs-feed)
  	* [TransXChange to GTFS](#transxchange-to-gtfs)
  		* [TransXChange2GTFS by danbillingsley](transxchange2gtfs-by-danbillingsley)
  		* [transxchange2gtfs by planar network](transxchange2gtfs-by-planar-network)
  	* [CIF to GTFS](#cif-to-gtfs)
  	* [Cleaning the GTFS data](#cleaning-the-gtfs-data)
  	* [Sample GTFS data](#˜sample-gtfs-data)  

* [Creating and running an OpenTripPlanner server](#creating-and-running-an-opentripplanner-server)
	* [Java method](#java-method)
  * [Docker method](#docker-method)

* [FAQ](#faq)    

## Introduction

The R package ([propeR](https://github.com/datasciencecampus/proper)) was created to analyse multimodal transport for a number of research projects at the [Data Science Campus, Office for National Statistics](https://datasciencecampus.ons.gov.uk/).

## Software Prerequisites

* GTFS building (optional)
  * A C# compiler such as Visual Studio Code, AND
  * MySQL
* OTP server (required)
  * Java SE Runtime Environment 8 (preferrably 64-bit) [[download here]](https://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html), OR
  * Docker

## GTFS feed

[propeR](https://github.com/datasciencecampus/proper) can be used without a General Transit Feed Specification (GTFS)](https://en.wikipedia.org/wiki/General_Transit_Feed_Specification) dataset. However, a GTFS feed is required to analyse public transport. Without it you can analyse car, bicycle, and foot transport using OpenStreetMap (OSM) data.

Understanding the complete UK transit network relies on the knowledge and software that can parse various other transit feeds such as bus data, provided in [TransXChange](https://www.gov.uk/government/collections/transxchange) format, and train data, provided in [CIF](https://www.raildeliverygroup.com/our-services/rail-data/timetable-data.html) format.

The initial tasks was to convert these formats to GTFS. The team indentified two viable converters: (i) C# based [TransXChange2GTFS](https://github.com/danbillingsley/TransXChange2GTFS) to convert TransXChange data; and (ii) sql based [dtd2mysql](https://github.com/open-track/dtd2mysql) to convert CIF data. The [TransXChange2GTFS](https://github.com/danbillingsley/TransXChange2GTFS) code was modified by the Campus and pushed back (successfully) to the original repository. The team behind [dtd2mysql](https://github.com/open-track/dtd2mysql), [planar network](https://planar.network/), have since created their own [TransXChange to GTFS converter](https://github.com/planarnetwork/transxchange2gtfs), which does not require a C# compiler.

Below is a more detailed set-by-step guide on how these converters are used.

### Creating a GTFS feed

A [GTFS](https://en.wikipedia.org/wiki/General_Transit_Feed_Specification) folder typically comprises the following files:

| Filename  | Description | Required? |
|---------------|-------------------------- |:---------:|
| agency.txt  | Contains information about the service operator | Yes |
| stops.txt | Contains details of each stop in the timetables provided  | Yes |
| routes.txt  | Contains information about the route  | Yes |
| trips.txt | Contains information about each trip on a route and service | Yes |
| stop_times.txt  | Contains the start and end times for stops on a journey | Yes |
| calendar.txt  | The start and end dates of journeys | Yes |
| calendar_dates.txt  | Shows exceptions for journeys for holidays etc  | Optional  |
| fare_attributes.txt | Contains information about journey fares  | Optional  |
| fare_rules.txt  | Assigns fares to certain journeys | Optional  |
| transfers.txt | Transfer type and time between stops  | Optional  |

Transport network models such as [OpenTripPlanner (OTP)](http://www.opentripplanner.org/) require a ZIP folder of these files.

#### TransXChange to GTFS

UK bus data in [TransXChange](https://www.gov.uk/government/collections/transxchange) format can be downloaded from [here](ftp://ftp.tnds.basemap.co.uk/) following the creation of an account at the Traveline website, [here](https://www.travelinedata.org.uk/traveline-open-data/traveline-national-dataset/). The data is catergorised by region. For our work, we downloaded the Wales (W) data. The data will be contained within a series of [XML](https://en.wikipedia.org/wiki/XML) files for each bus journey. For example, here is a snippet of the `CardiffBus28-CityCentre-CityCentre6_TXC_2018803-1215_CBAO028A.xml`:

```
<?xml version="1.0" encoding="utf-8"?>
<TransXChange xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xsi:schemaLocation="http://www.transxchange.org.uk/ http://www.transxchange.org.uk/schema/2.1/TransXChange_general.xsd" CreationDateTime="2018-08-03T12:15:26" ModificationDateTime="2018-08-03T12:15:26" Modification="revise" RevisionNumber="1" FileName="CardiffBus28-CityCentre-CityCentre6_TXC_2018803-1215_CBAO028A.xml" SchemaVersion="2.1" RegistrationDocument="false" xmlns="http://www.transxchange.org.uk/">
  <ServicedOrganisations>
    <ServicedOrganisation>
      <OrganisationCode>CDS</OrganisationCode>
      <Name>Cardiff</Name>
      <WorkingDays>
```

##### TransXChange2GTFS by danbillingsley

Initially, we used [TransXChange2GTFS](https://github.com/danbillingsley/TransXChange2GTFS) to convert the TransXChange files into GTFS format. TransXChange is a C# tool. Our method to convert the data was:

1. Place the XML files in the 'dir/input' folder.
2. Run the Program.cs file (i.e., `dotnet run Program.cs`).
3. The GTFS txt files will be created in the 'dir/output' folder.
4. Compress the txt files to a ZIP folder with an appropriate name (e.g., 'bus_GTFS.zip').

##### transxchange2gtfs by planar network

The team, [planar network](https://planar.network/), who we initially used to convert the UK train data to GTFS, have created a TypeScript TransXChange to GTFS converter, [transxchange2gtfs](https://github.com/planarnetwork/transxchange2gtfs). Their GitHub page provides good detailed instructions to installing and converting the files. The method we used was:

1. Install the converter as per the GitHub instructions.
3. Run `transxchange2gtfs path/to/GTFS/file.zip gtfs-output.zip` in terminal/command line.

#### CIF to GTFS

As mentioned above, UK train data in CIF format can be downloaded from [here](http://data.atoc.org/data-download) following the creation of an account. The timetable data will download as a zipped folder named 'ttis\*\*\*.zip'.

Inside the zipped folder will be the following files: ttfis\*\*\*.alf, ttfis\*\*\*.dat, ttfis\*\*\*.flf, ttfis\*\*\*.mca, ttfis\*\*\*.msn, ttfis\*\*\*.set, ttfis\*\*\*.tsi, and ttfis\*\*\*.ztr. Most of these files are difficult to read, hence the need for GTFS.

We used the sql tool [dtd2mysql](https://github.com/open-track/dtd2mysql) created by [planar network](https://planar.network/) to convert the files into a SQL database, then into the GTFS format. The [dtd2mysql github](https://github.com/open-track/dtd2mysql) page gives a guide on how to convert the data. This method used here was:

1. Create a sql database with an appropriate name (e.g., 'train_database'). Note, this is easiest done under the root username with no password.
2. Run the following in a new terminal/command line window within an appropriate directory:
```
DATABASE_USERNAME=root DATABASE_NAME=train_database dtd2mysql --timetable /path/to/ttisxxx.ZIP
```
3. Run the following to download the GTFS files into the root directory:
```
DATABASE_USERNAME=root DATABASE_NAME=train_database dtd2mysql --gtfs-zip train_GTFS.zip
```
4. As [OpenTripPlanner (OTP)](http://www.opentripplanner.org/) requires GTFS files to not be stored in subfolders in the GTFS zip file, extract the downloaded 'train_GTFS.zip' and navigate to the subfolder level where the txt files are kept, then zip these files to a folder with an appropriate name (e.g., 'train_GTFS.zip').

**Note**: _if you are receiving a 'group_by' error, you will need to temporarily or permenantly disable `'ONLY_FULL_GROUP_BY'` in mysql._

### Cleaning the GTFS Data

The converted GTFS ZIP files may not work directly with [OpenTripPlanner (OTP)](http://www.opentripplanner.org/). Often this is caused by stops within the stop.txt file that are not handled by other parts of the GTFS feed, but there are other issues too, such as latitude and longitudes of stops being assigned to 0. In propeR we have created a function called `cleanGTFS()` to clean and preprocess the GTFS files. To run:

```
#R
library(propeR)
cleanGTFS(gtfs.dir, gtfs.filename)
```

Where `gtfs.dir` is the directory where the GTFS ZIP folder is located, and `gtfs.filename` is the filename of the GTFS feed. This will create a new, cleaned GTFS ZIP folder in the same location as the old ZIP folder, but with the suffix '\_new'. Run this function for each GTFS feed.

### Sample GTFS data

The Data Science Campus has created some cleaned GTFS data from March 2019 (using the steps above) for:

* buses in Cardiff, Wales, UK. [Download, 1.7MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/cardiff_bus/Cardiff-gtfs.zip)
* buses in Wales, UK. [Download, 22.3MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/wales_bus/W_GTFS.zip)
* buses in Scotland, UK. [Download, 34.6MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/scotland_bus/S_GTFS.zip)
* buses in East Anglia, England, UK. [Download, 3.5MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/EA_GTFS.zip)
* buses in East Midlands, England, UK. [Download, 28.0MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/EM_GTFS.zip)
* buses in Greater London, England, UK. [Download, 99.8MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/L_GTFS.zip)
* buses in the North East, England, UK. [Download, 43,4MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/NE_GTFS.zip)
* buses in the North West, England, UK. [Download, 34.1MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/NW_GTFS.zip)
* buses in the South East, England, UK. [Download, 55.3MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/SE_GTFS.zip)
* buses in the South West, England, UK. [Download, 26.7MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/SW_GTFS.zip)
* buses in the West Midlands, England, UK. [Download, 25.5MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/WM_GTFS.zip)
* buses in Yorkshire, England, UK. [Download, 29.2MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/england_bus/Y_GTFS.zip)
* national coaches in the UK. [Download, 1.2MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/ncsd/NCSD_GTFS.zip)
* trains in the UK. [Download, 21.4MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/uk_train/train_GTFS.zip)

The Data Science Campus has also created a bespoke OpenStreetMap (osm) file for Cardiff, Wales, UK for March 2019:

* Cardiff OSM file. [Download, 101.1MB](https://a2s-gtfs.s3.eu-west-2.amazonaws.com/Mar19/cardiff_osm/cardiff.osm)

**Note**: _these GTFS do not contain the most recent timetables, it is only designed as a practice set of GTFS data for use with the propeR tool. Some (but not most) services have end dates of 2018-08-15, 2018-09-02, 2018-10-31. Therefore, analysing journeys after these dates will not include these services. Most services have an end date capped at 2020-01-01._

## Creating and running an OpenTripPlanner server

### Java method

[OpenTripPlanner (OTP)](http://www.opentripplanner.org/) is an open source multi-modal trip planner, which runs on Linux, Mac, Windows, or potentially any platform with a Java virtual machine. More details, including basic tutorials can be found [here](http://docs.opentripplanner.org/en/latest/). Guidance on how to setup the OpenTripPlanner locally can be found [here](https://github.com/opentripplanner/OpenTripPlanner/wiki). Here is the method that worked for us:

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

Again for convenience we have created several docker images to run an OTP server. First fire up OTP server (parse `-d` flag to daemonise).

```
docker run -p 8080:8080 datasciencecampus/<docker_image>
```

where `<docker_image>` is:

* `dsc_otp` (graph for Cardiff, Wales, UK from March 2019)
* `dsc_otp_wales_mar19` (graph for Wales, UK from March 2019)
* `dsc_otp_scotland_mar19` (graph for Scotland, UK from March 2019)
* `dsc_otp_england_mar19` (graph for England, UK from March 2019)

A stand-alone OTP server can also be built and deployed in the [otp/](otp/) directory by editing the `Dockerfile` and `build.sh` files.

## FAQ

Q: Do I need an OpenStreetMap (.osm) file to build a graph?

>A: Yes, whilst you can build the graph without an .osm file. You will need it to analyse the graph.

Q: Do I need a GTFS file to build a graph?

>A: Only if you want to analyse public transport. Without a GTFS file you can still analyse private transport or walking by setting `modes` to `CAR`, `BICYCLE` or `WALK` in each of the functions.

Q: I found a bug!

>A: Please use the GitHub issues form to provide us with the information ([here](https://github.com/datasciencecampus/graphite/issues))
