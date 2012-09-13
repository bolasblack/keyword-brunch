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
    filePattern: /\.(js|css|html)$/
    map:
      "{!version!}": processer
```

plugin will do:

```coffeescript
fileContent = fileContent.replace (new RegExp "{!version!}"), processer
```
