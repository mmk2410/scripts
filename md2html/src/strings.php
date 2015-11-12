<?php

$usage =
"
md2html converter
mmk2410 2015
MIT License

Usage:

./md2html inputfile [outputfile]

If no output file is given, the converted code will printed in the console.
The input file must be a .md file and the outputfile a html or txt.

./md2html.php argument

Available arguments:

-h | --help
Prints this text

If no output file is given, the converted code will printed in the console.
";

$htmlbegin =
"
<!DOCTYPE html>
<html>
    <head>
        <meta charset='utf-8'>
        <title></title>
    </head>
    <body>
";

$htmlend =
"
    </body>
</html>
";
