#!/usr/bin/ruby
require 'time'
if ARGV[0] == "-h" || ARGV[0] == "--help"
    puts "\njekyll2rangitaki converter\n\n" \
    "2015 (C) Marcel Kapfer (mmk2410)\n" \
    "MIT License\n\n" \
    "Version: 0.1.0\n" \
    "Release Date: 03 November 2015\n\n" \
    "Usage:\n" \
    "Copy the jekyll files into an directory called\n" \
    " ./in and run the script. The converted files \n" \
    "are saved in ./out\n\n" \
    "Options:\n" \
    "-h || --help       print the help and exit\n\n"
    exit
end
if !File.directory?("./in/")
    puts "No input directory"
    exit
end
articles = Dir.entries('./in')
for article in articles
    title = ""
    date = ""
    time = Time.new
    tags = ""
    text = ""
    if article.length > 2 && (article.end_with?(".md") || article.end_with?(".markdown"))
        file = File.open("./in/#{article}")
        file.each do |line|
            if line.start_with?("---")
                next
            elsif line.start_with?("layout")
                next
            elsif line.start_with?("title")
                title = line[7...line.length].strip!
                title = title.chomp("\"")[1...title.length]
            elsif line.start_with?("date")
                date = line[5...line.length].strip
                time = Time.new(date[0...4],date[5...7],date[8...10],date[11...13],date[14...16],date[17...19])
            elsif line.start_with?("categories")
                tags = line[12...line.length].strip
                tags[" "] = ", "
            elsif line.start_with?("{% highlight") || line.start_with?("{% endhighlight")
                text += "```\n"
            else
                text += line
            end
        end
        if !File.directory?("./out")
            Dir.mkdir("./out")
        end
        article[".markdown"] = ".md"
        post = File.new("./out/#{article}", "w")
        post.puts "%TITLE: #{title}" if !title.empty?
        post.puts "%DATE: #{time.strftime("%d %B %Y %H:%M")}" if time != nil
        post.puts "%TAGS: #{tags}" if !tags.empty?
        post.puts text if !text.empty?
        post.close
    end
end
