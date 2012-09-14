fs = require "fs"

module.exports = class KeywordProcesser
  brunchPlugin: yes

  constructor: (@config) ->
    keywordConfig = @config.keyword or {}
    @keywordMap = keywordConfig.map or {}
    @filePattern = keywordConfig.filePttern or /\.(js|css|html)$/
    @publicFolder = @config.paths.public
    Object.freeze this

  processFolder: (folder) ->
    fs.readdir folder, (err, fileList) =>
      throw err if err
      fileList.forEach (file) =>
        filePath = "#{folder}/#{file}"
        @processFile filePath

  processFile: (file) ->
    return @processFolder file if fs.lstatSync(file).isDirectory()
    return unless @filePattern.test file
    fileContent = fs.readFileSync file, "utf-8"
    return unless fileContent

    resultContent = ""
    for keyword, processer of @keywordMap
      keywordRE = new RegExp keyword, "g"
      resultContent = fileContent.replace keywordRE, processer
    fs.writeFileSync file, resultContent, "utf-8"

  onCompile: (generatedFiles) ->
    return unless @keywordMap
    @processFolder @publicFolder
