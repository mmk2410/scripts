# Eclipse Version Scraping

Since Eclipse does not provide a convenient (or I did not find one) way to get informed when a new version is released it is quite difficult to keep my unofficial packages up-to-date.
 
So I wrote this script to scrape the eclipse.org page and set it up as a cron job to get notified, one a new version of Eclipse releases.

## Usage

`dart bin/main.dart [options] recipient`

Where options are one of the following:

 - `-h` or `--help`: prints a help and exits
 - `-f` or `--file`: specify a file, `./version.txt` is used by default

The recipient is the person that gets mailed, if a new version is released. 