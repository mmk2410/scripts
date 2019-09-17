# Scripts
A collection of all my scripts - written in different Language

## How to use

If nothing other is written, do this:

 1. Download the script you want.
 2. Run ``chmod +x script`` to make it executable
 3. Run it with ``./script``

## buildpdf.sh

A script for automatically creating PDf files from a latex document. You can set the amounts of builds and the time between the builds.

**Usage:** ``./buildpdf.sh filename [build amount] [time between builds in s]``

## cpy_pst

A small but useful script for copying and pasting files and directories once or more often.

**Install:** ``sudo make install``

**Usage:**

```
cpy filename # Copies a file / directory
pst filename # Pasts a file / directory
```

**Remove:** ``sudo make uninstall``

## intellij-hidpi.sh

This is a small script for enabling and disabling HiDPI support on IntelliJ IDEA Community Edition on every Linux distribution where IntelliJ is installed in /usr/share/intellijidea-ce/. If the installation is somewhere else you have to change the variable IDEA_PATH.

**Usage:**

 - Help: ``./intellij-hidpi.sh -h``
 - Enable ``./intellij-hidpi.sh -e``
 - Disable ``./intellij-hidpi.sh -d``

## android-studio-hidpi.sh

This is a small script for enabling and disabling HiDPI support in Android Stuido on every linux distribution where Android Stuido is installed in /opt/android-studio. If the installation is somewhere else you have to change the variable STUDIO_PATH.

**Usage:**

 - Help: ``./android-studio-hidpi.sh -h``
 - Enable ``./android-studio-hidpi.sh -e``
 - Disable ``./android-studio-hidpi.sh -d``

## jekyll2rangitaki

A small script for converting Jekyll markdown blog posts to Rangitaki blog posts.

### How to use

You don"t have to install anything. Just run

```
ruby jekyll2rangitaki.rb
```

or

```
chmod +x jekyll2rangitaki.rb
./jekyll2rangitaki.rb
```

The converter will read all `.md` and `.markdown` in the directory `./in/`, so copy the blog posts, you want to convert into this directory, and it will then throw the converted files out into the directory `./out/`.

## PHP Scripts

These scripts are **not for web development**, there for executing on your computer. Just like a bash script, but written in PHP. There also **written for Linux**. I have no idea if they run under another system and I'm not going to test it (if you tested it and  if they worked, write me a mail at opensource(at)mmk2410(dot)org and I will add it to this README).

In order to use these scripts you have to install `php` on your computer.

Here are installation instruction for a few distributions:

```
Arch Linux:
sudo pacman -S php-cgi

Ubuntu:
sudo apt-get install php5-cli

Fedora:
sudo dnf install php-cli
```

### md2html

md2html is a simple script that converts markdown files to html code and optionally saves it into a .txt or .html file. The library that powers the whole thing is [Parsedown](https://github.com/erusev/parsedown).

#### Installation

To use this script, install `php` (see the section above) and run the following command:
```
sudo make install
```

**You have to add /opt/md2html to your open_basedir in php.ini**

#### Usage

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

### blogger2rangitaki

This is a small PHP script for converting a Blogger XML to Rangitaki blog posts.

This script uses [html-to-markdown](https://github.com/thephpleague/html-to-markdown) to convert the blogposts.

#### Usage

You don't need to install that script on your computer. It is enough to make it runnable:

```
chmod +x blogger2rangitaki.php
```

And to run it:

```
./blogger2rangitaki.php blog.xml
```

where `blog.xml` is your Blogger XML file (the exported blog).

**This script doesn't import your media files into Rangitaki.**

### pblog2rangitaki

This is a small script which converts pBlog/Rangitaki 0.2.x XML files into Rangitaki blog posts

### Usage

You don't need to install this script on your computer, it's enough to make it executable:

```
chmod +x pblog2rangitaki.php
```

Run it then:

```
./pblog2rangitaki.php posts.xml
```

Where `posts.xml` is your pBlog/Rangitaki 0.2 XML file.

The Rangitaki blog posts are saved in `articles/`

**The `<otherlinks>` tag is not supported.**

## Contributing

1. Fork it
2. Create a feature branch with a meaningful name (`git checkout -b my-new-feature`)
3. Add yourself to the CONTRIBUTORS file
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to your branch (`git push origin my-new-feature`)
6. Create a new pull request
