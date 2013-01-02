fs = require "fs"

module.exports = class KeywordProcesser
  brunchPlugin: yes

  generateDefaultMap: ->
    map = {}
    packageInfo = JSON.parse fs.readFileSync "package.json", 'utf-8'
    for keyword in ["version", "name"]
      if packageInfo[keyword]?
        map["{!#{keyword}!}"] = packageInfo[keyword]
      else
        console.log "Package.json need a #{keyword}"
    map["{!date!}"] = "" + Date()
    map["{!timestamp!}"] = "" + (new Date).getTime()
    map

  constructor: (@config) ->
    return unless @config.keyword
    @keywordConfig = @config.keyword or {}
    @filePattern = @keywordConfig.filePattern ? /\.(js|css|html)$/

    @keywordMap = @generateDefaultMap()
    configMap = @keywordConfig.map or {}
    @keywordMap[k] = v for own k, v of configMap

    Object.freeze this

  processFolder: (folder) ->
    fs.readdir folder, (err, fileList) =>
      throw err if err
      fileList.forEach (file) =>
        filePath = "#{folder}/#{file}"
        return unless @filePattern.test file
        @processFile filePath

  processFile: (file) ->
    fs.exists file, (isExist) =>
      return console.log(file, "is not exist") if not isExist
      return @processFolder(file) if fs.lstatSync(file).isDirectory()
      return unless fileContent = fs.readFileSync file, "utf-8"

      resultContent = fileContent
      for keyword, processer of @keywordMap
        keywordRE = RegExp keyword, "g"
        resultContent = resultContent.replace keywordRE, processer
      fs.writeFileSync file, resultContent, "utf-8"

  onCompile: (generatedFiles) ->
    return if @filePattern is false
    @processFolder @config.paths.public
    if (extraFiles = @keywordConfig.extraFiles)? and extraFiles.length
      extraFiles.forEach (file) => @processFile file
