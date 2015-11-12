# md2html

md2html is a simple script that converts markdown files to html code and optionally saves it into a .txt or .html file. The library that powers the whole thing is [Parsedown](https://github.com/erusev/parsedown).

## Installation

To use this script, install `php` and run the following command:
```
sudo make install
```

**You have to add /opt/md2html to your php.ini open_basedir !**

## Usage

Print the help:
```
md2html --help
```

To just print out the HTML code of the given `.md` file run:
```
md2html text.md
```

To print the HTML code into a `.txt` or `.html` file run:
```
md2html text.md text.html
```
If you pass a `.html` file for the output it will automatically add a basic HTML5 structure.
