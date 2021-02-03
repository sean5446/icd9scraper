# ICD9 Website scraper

There really doesn't seem to be any good way to download all the data from http://www.icd9data.com in 2017. Other people have attempted to write programs to do this. This is my attempt. I'm not sure if icd9data.com will ban you for using too much of their bandwidth. This program allows the user to use proxies.

### Usage

- Make sure you have Perl and curl installed and they are accessible from the command line
-- Linux: sudo apt-get install curl
-- Windows: https://curl.haxx.se/download.html  extract it, and add it's location to %PATH%.  Active Perl or Strawberry Perl for windows
- Get proxies and add them to `scraper_start.pl` or I think `localhost` may work if you don't want to use proxies `proxtest.pl` can help testing proxies
- Run a quick test `perl scraper.pl -x 192.241.225.201:80 -c "001-139" -m 5 -o data/001-139.txt` to check if things are working... `-m 5` sets a maximum of 5 queries so you can catch any bugs before crawling the entire code bank
- If that worked, go ahead and run: `perl scraper_start.pl`. This will open lots of terminal windows (18?) each will scan a top level code. The data, by default, is placed in the folder: `data` 
- `count.pl` will give you a count of the number of lines in each file- this is helpful for comparing different runs. It can also be modified to combine all the files in the `data` folder into one file
- `parser.pl` reads the data files and formats the input to be a CSV, Excel readable file
# icd9scraper
