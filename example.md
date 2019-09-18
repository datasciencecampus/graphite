<p align="center"><img align="center" src="meta/logo/graphite_logo_v1.png" width="400px"></p>

## Contents

* [Introduction](#introduction)
* [GTFS feed](#gtfs-feed)
  	* [Creating a GTFS feed](#creating-a-gtfs-feed)
  	* [TransXChange to GTFS](#transxchange-to-gtfs)
  		* [TransXChange2GTFS by danbillingsley](transxchange2gtfs-by-danbillingsley)
  		* [transxchange2gtfs by planar network](transxchange2gtfs-by-planar-network)
  	* [CIF to GTFS](#cif-to-gtfs)
  	* [Cleaning the GTFS data](#cleaning-the-gtfs-data)
* [FAQ](#faq)    

## Introduction

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

The converted GTFS ZIP files may not work directly with [OpenTripPlanner (OTP)](http://www.opentripplanner.org/). Often this is caused by stops within the stop.txt file that are not handled by other parts of the GTFS feed, but there are other issues too, such as latitude and longitudes of stops being assigned to 0. In [propeR](https://github.com/datasciencecampus/proper) we have created a function called `cleanGTFS()` to clean and preprocess the GTFS files. To run:

```
#R
library(propeR)
cleanGTFS(gtfs.dir, gtfs.filename)
```

Where `gtfs.dir` is the directory where the GTFS ZIP folder is located, and `gtfs.filename` is the filename of the GTFS feed. This will create a new, cleaned GTFS ZIP folder in the same location as the old ZIP folder, but with the suffix '\_new'. Run this function for each GTFS feed.
