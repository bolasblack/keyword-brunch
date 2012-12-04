fs = require "fs"

module.exports = class KeywordProcesser
  brunchPlugin: yes

  generateDefaultMap: ->
    map = {}
    for keyword in ["version", "name"]
      do (keyword) =>
        map["{!#{keyword}!}"] = =>
          unless @packageInfo[keyword]
            throw new Error "package need a #{keyword}"
          @packageInfo[keyword]
    map

  constructor: (@config) ->
    @packageInfo = JSON.parse fs.readFileSync "package.json"
    @keywordConfig = @config.keyword or {}
    @filePattern = @keywordConfig.filePattern ? /\.(js|css|html)$/

    @keywordMap = {}
    defaultMap = @generateDefaultMap()
    configMap = @keywordConfig.map or {}
    for own k, v of defaultMap
      @keywordMap[k] = if configMap[k]? then configMap[k] else v

    Object.freeze this

  processFolder: (folder) ->
    fs.readdir folder, (err, fileList) =>
      throw err if err
      fileList.forEach (file) =>
        filePath = "#{folder}/#{file}"
        return unless @filePattern.test file
        @processFile filePath

  processFile: (file) ->
    return @processFolder file if fs.lstatSync(file).isDirectory()
    fileContent = fs.readFileSync file, "utf-8"
    return unless fileContent

    resultContent = fileContent
    for keyword, processer of @keywordMap
      keywordRE = new RegExp keyword, "g"
      resultContent = resultContent.replace keywordRE, processer
    fs.writeFileSync file, resultContent, "utf-8"

  onCompile: (generatedFiles) ->
    return if @filePattern is false
    @processFolder @config.paths.public
    if (extraFiles = @keywordConfig.extraFiles)? and extraFiles.length
      extraFiles.forEach (file) => @processFile file
