#!/usr/bin/php
<?php
include '/opt/md2html/src/strings.php';
include '/opt/md2html/libs/Parsedown.php';
$parsedown = new Parsedown();
if(count($argv) == 1 || count($argv) > 3) {
    echo "Arguments not possible.\n";
    echo $usage;
} elseif (isset($argv[2])) {
    if(substr_compare($argv[1], ".md", -3) == 0){
        if(substr_compare($argv[2], ".txt", -4) == 0 ||
            substr_compare($argv[2], ".html", -5) == 0) {
            if(file_exists($argv[1])){
                $handler = fopen($argv[1], "r");
                $content = fread($handler, filesize($argv[1]));
                fclose($handler);
                $content = $parsedown
                    ->setBreaksEnabled(true)
                    ->text($content);
                if(file_exists($argv[2])){
                    echo "The file $argv[2] already exists.\nDo you want to override it? (Y)es / (N)o ";
                    $answer = trim(fgets(STDIN));
                    if(in_array($answer, array("y","yes","Yes","YES","Y"))) {
                        $whandler = fopen($argv[2], "w+");
                        if(substr_compare($argv[2], ".html", -5) == 0){
                            $content = $htmlbegin . $content . $htmlend;
                        }
                        if(fwrite($whandler, $content)){
                            echo "File sucessfully written.";
                        } else {
                            echo "An error occured.";
                        }
                        fclose($whandler);
                    } else {
                        echo "File not changed.";
                    }
                } else {
                    $whandler = fopen($argv[2], "x");
                    if(substr_compare($argv[2], ".html", -5) == 0){
                        $content = $htmlbegin . $content . $htmlend;
                    }
                    if(fwrite($whandler, $content)){
                        echo "HTML file sucessfully written.";
                    } else {
                        echo "An error occured.";
                    }
                    fclose($whandler);
                }
            }
        } else {
            echo "The output file is neither a HTML file nor a TXT file.";
        }
    } else {
        echo "This is not a Markdown file!";
    }
} elseif(isset($argv[1])){
    if(in_array($argv[1], array("--help","-h","-?","--usage","-u"))) {
        echo $usage;
    } else {
        if(substr_compare($argv[1], ".md", -3) == 0){
            if(file_exists($argv[1])){
                $handler = fopen($argv[1], "r");
                $content = fread($handler, filesize($argv[1]));
                fclose($handler);
                echo $parsedown
                    ->setBreaksEnabled(true)
                    ->text($content);
            } else {
                echo "The given file doesn't exist.";
            }
        } else {
            echo "This is not a Markdown file!";
        }
    }
}
echo "\n";
