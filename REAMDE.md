
Helical is a demo in Weex
----

...another Todolist demo

### Usage

Compile with CoffeeScript on the fly:

```bash
coffee --no-header -o lib -bwc src/helical.coffee
```

Start an HTTP server:

```bash
http-server -c-1 lib/
```

Get QR code for Weex http://www.qr-code-generator.com/

### Problems

Currently it's Vanilla mode running with standard `weex` object, which is not supported by Weex Playground.

### License

MIT
