# pblog2rangitaki

This is a small script which converts pBlog/Rangitaki 0.2.x XML files into Rangitaki blog posts

## Usage

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

## HHVM

This script works also in HHVM. Just replace the first line with

```
#!/bin/hhvm
```
