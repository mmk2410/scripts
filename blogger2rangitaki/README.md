# blogger2rangitaki

This is a small PHP script for converting a Blogger XML to Rangitaki blog posts.

This script uses [html-to-markdown](https://github.com/thephpleague/html-to-markdown) to convert the blogposts.

## Usage

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

## HHVM

This script works also in HHVM. Just replace the first line with

```
#!/bin/hhvm
```
