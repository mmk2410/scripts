# jekyll2rangitaki

A small script for converting Jekyll markdown blog posts to Rangitaki blog posts.

## How to use

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

## License

This small piece of code is licensed under MIT license.

## Contribute

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create New Pull Request
