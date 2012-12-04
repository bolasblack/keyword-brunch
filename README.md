## keyword-brunch
make [brunch](http://brunch.io) replace keywords of public files after every time complied

## Usage
<del>
Add `"keyword-brunch": "x.y.z"` to `package.json` of your brunch app.

Pick a plugin version that corresponds to your minor (y) brunch version.
</del>

If you want to use git version of plugin, add
`"keyword-brunch": "git+ssh://git@github.com:bolasblack/keyword-brunch.git"`.

Usage:

```coffeescript
module.exports = 
  keyword:
    # file filter
    filePattern: /\.(js|css|html)$/

    # Extra files, add brunch didn't process file here,
    # will not filter by `filePattern`
    extraFiles: [
      "public/humans.txt"
    ]

    # Now keyword-brunch has two keyword: {!version!}, {!name!}
    # read information from package.json
    map:
      "{!version!}": processer
```

plugin will do:

```coffeescript
fileContent = fileContent.replace (new RegExp "{!version!}"), processer
```
