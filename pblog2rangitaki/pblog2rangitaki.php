#!/bin/php
<?php
// This is a php script for converting a pBlog / Rangitaki 0.2.x XML file into rangitaki blog posts
if(in_array($argv[1], array("-h", "--help", "--usage", "-?"))) {
	help();
} else if (isset($argv[1])) {
	$content = file_get_contents("$argv[1]");
	$xml = new SimpleXMLElement($content);
	foreach ($xml->post as $entry) {
		// TITLE
		$title = $entry->title;

		// CONTENT
		$content = $entry->content;

		// Pubdate
		$pubdate = $entry->pubdate;
		date_default_timezone_set("UTC");
		$pubdate = date("d F Y", strtotime($pubdate));



		// FILENAME
		$date = $entry->pubdate;
		$date = date("Y-m-d-H-i", strtotime($date));
		$filetitle = str_replace(" ", "-", $title);
		$filename = $date . "-" . $filetitle . ".md";

		if(isset($entry->mainlink)){
		$filecontent = <<<EOD
%TITLE: $title
%DATE: $pubdate

$content

[$entry->mainlink]($entry->mainurl)
EOD;
		} else {
		$filecontent = <<<EOD
%TITLE: $title
%DATE: $pubdate

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
} else {
	help();
}

function help() {
	$help = <<<EOD

blogger2rangitaki

A small PHP script which converts pBlog/Rangitaki 0.2.x XML files to Rangitaki blog posts.

COPYRIGHT © 2015 Rangitaki Project

MIT License

Usage:

./pblog2rangitaki filename.xml

Where filename.xml is the pBlog XML file.

The articels are saved in articles/

The <otherlinks> tag are not supported.

EOD;

	echo $help;
}
