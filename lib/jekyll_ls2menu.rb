require "jekyll"
require "jekyll_ls2menu/version"
include FileUtils

module Jekyll

  class JekyllLs2menu < Liquid::Tag
    def initialize(tagName, content, tokens)
     super
     @content = content.strip!
    end

    def render(context)
      lsDir = File.join(context.registers[:site].source, @content)
      fs = []
      fs = lsDir(lsDir)
      ls2html(fs, @content)
    end

    def ls2html(fs, lsDir)
      res = "<ul>"
      fs.each do |item|
        if item.kind_of?(Hash)
            res += "<li>"
            res += "<span>#{item.keys[0]}</span>"
            res += ls2html(item.values[0], File.join(lsDir, item.keys[0]))
            res += "</li>"
        else
            filename  = File.basename(item,".*")
            res += "<li>"
            res += "<a href='#{File.join("/",lsDir, filename)}'>#{filename}</a>"
            res += "</li>"
        end
      end
      res += "</ul>"
      res
    end

    def lsDir(dir)
      entries = Dir.entries(dir)
      files = []
      dir_name = dir.split('/').last
      entries.each do |name|
        next if name == "." || name == ".."
        if File.directory? File.join(dir, name)
          ls = {}
          ls[name] = lsDir(File.join(dir,name))
          files << ls
        else
          files << name
        end
      end
      files
    end
  end
end

Liquid::Template.register_tag "jekyll_ls2menu", Jekyll::JekyllLs2menu