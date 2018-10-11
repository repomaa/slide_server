# SlideServer

Simple server that allows sharing slides in given directory tree written in
markdown

## Installation and Usage

### From source

```bash
$~> git clone https://github.com/jreinert/slide_server
$~> cd slide_server
$~> shards build --production --release
$~> bin/slide_server path/to/slide/root
```

### From binary

- Get the latest release from https://github.com/jreinert/slide_server/releases
- Run it like above

### Using Docker

```bash
$~> docker run -p 3000:3000 -v /path/to/slide/root:/slides jreinert/slide_server
```

## Contributing

1. Fork it (<https://github.com/jreinert/slides/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [jreinert](https://github.com/jreinert) Joakim Reinert - creator, maintainer
