# omop-on-fhir-deployment

This repository is used to build a PostgreSQL database of synthetic data (i.e., SynPUF1k531). The synthetic data is in OMOP 5.3.1 format. This repo then builds a Docker container that launches [a FHIR server](https://github.com/omoponfhir/omoponfhir-main-v531-r4). This FHIR server is from the [OMOP-on-FHIR project](http://omoponfhir.org/) from Georgia Tech, and connects to our PostgreSQL database in OMOP format,and serves requests conforming to the FHIR API.

## 1. Dependencies

- Git
- Docker
- PostgreSQL
- GNU Make

## 2. Installation

The installation process can be done on your local machine or a remote VM. The steps should be roughly identical.

#### 2.1 Cloning this Repo

We begin by cloning this repository to the desired VM or local machine. If we are working on a VM or local machine with SSH keys already configured with GitHub, then we can clone this repo using the command below.

```
git clone git@github.com:bcbi/omop-on-fhir-deployment.git
```

#### 2.2 Fetch Vocabularies

The Athena vocabularies are not contained within the repo, so these must be fetched before building the database. We can fetch the vocabularies by running the command below. Note that the `make fetch-vocabs` step often seems the "hang" after it has actually completed. When this happens, we need to press return/enter and we'll get a prompt again.

```
cd omop-on-fhir-deployment
make fetch-vocabs
make untar-vocabs
```

#### 2.3 Fix Absolute Paths in `\copy` Commands

Both the `sql/load_synpuf.sql` and the `sql/load_vocabs.sql` files have absolute paths describing the location of the SynPUF data and the vocabularies, respectively. Depending on your installation location, these paths may need to be adjusted. This can be done with a `sed` command. For example, the `sed` command below was used to change from the path one might have on their local machine, to the path one would use on a shared VM.

```
cd sql
sed -i 's/\/Users\/pstey\/projects\/omop-on-fhir-deployment/\/opt\/omop_on_fhir\/omop-on-fhir-deployment/g' *.sql
```

#### 2.4 Specify PosgreSQL Server's Hostname

If we are building the database on a machine _other_ than the machine we will use for the FHIR server, then we need to ensure our `Makefile` contains the correct `--host` argument when we're calling `psql`. This can be done by updating the `HOST` variables assignment at the top of the `Makefile`. If our PostgreSQL database is on the _same_ machine as the eventual FHIR server, we can omit the `--host` argument altogether, or else use `localhost`.

#### 2.5 Creating the PostgreSQL Database

The PostgreSQL database can now be created. The first step is to create the various user roles that we will need, and then we use the newly created `omop_admin_user` account to perform the subsequent actions. This can all be done using the following command from within the top-level of this directory.

```
make initdb
```

One thing to note is that the above may fail when attempting to run the `sql/create_schema.sql` script. This is the first SQL script we run as the `omop_admin_user`, and it will fail if the `pg_hba.conf` file has not been updated to allow connections from the `omop_admin_user`. When this happens, the error message—at least on PostgreSQL 15 or above—is pretty clear about the cause of the issue.

#### 2.6 Load Vocabularies and Data

Now we are ready to load the data and vocabularies. If the above steps have gone smoothly, then these two should both go smoothly as well. The commands below will take several minutes to run, and we will be prompted to enter the password of the `omop_admin_user` several times along the way.

```
make vocab
make data
make f-tables
```

## 3 Running the FHIR Server

## 4. To-do
