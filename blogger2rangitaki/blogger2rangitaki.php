#!/bin/php
<?php
// This is a php script for converting a blogger atom feed into rangitaki blog posts
require './vendor/autoload.php';
use League\HTMLToMarkdown\HtmlConverter;
if(in_array($argv[1], array("-h", "--help", "--usage", "-?"))) {
	help();
} else if (isset($argv[1])) {
	$content = file_get_contents("$argv[1]");
	$xml = new SimpleXMLElement($content);
	$converter = new HtmlConverter(array('strip_tags' => true));
	$i = 0;
	foreach ($xml->entry as $entry) {
		if($i > 56) {

			// TITLE
			$title = $entry->title;

			// CONTENT
			$content = $entry->content;
			$content = $converter->convert($content);

			// AUTHOR
			$author = $entry->author->name;

			// TAGS
			if (isset($entry->categories)) {
				echo "YES!";
				foreach ($entry->categories->attributes as $tag) {
					if (!(substr_compare($tag->scheme, "http://schemas.google.com/", 0, 26))) {
						$tags = $tags . $tag->term . ", ";
					}
					$tags = substr($tags, 0, strlen($tags) - 2);
				}
			}

			// Pubdate
			$pubdate = $entry->published;
			date_default_timezone_set("UTC");
			$pubdate = date("d F Y", strtotime($pubdate));

			// FILENAME
			$date = $entry->published;
			$date = date("Y-m-d-H-i", strtotime($date));
			$filetitle = str_replace(" ", "-", $title);
			$filename = $date . "-" . $filetitle . ".md";

			if(isset($tags)){
			$filecontent = <<<EOD
%TITLE: $title
%DATE: $pubdate
%AUTHOR: $author
%TAGS: $tags

$content
EOD;
		} else {
		$filecontent = <<<EOD
%TITLE: $title
%DATE: $pubdate
%AUTHOR: $author

$content
EOD;
			}


			// Make a output directory
			if(!(file_exists("articles"))) {
				mkdir("articles");
			}

			// Save the file
			$handle = fopen("articles/$filename", "c");
			fwrite($handle, $filecontent);
			fclose($handle);
		}
		$i++;
	}
} else {
	help();
}

function help() {
	$help = <<<EOD

blogger2rangitaki

A small PHP script which converts a Blogger XML export to Rangitaki blog posts.

COPYRIGHT © 2015 Rangitaki Project

MIT License

Usage:

./blogger2rangitaki filename.xml

Where filename.xml is the Blogger export.

The articels are saved in articles/

EOD;

	echo $help;
}
