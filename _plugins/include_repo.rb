module Jekyll
  module Tags
    class IncludeRepoTag < IncludeTag

      def tag_includes_dirs(context)
        Array(Pathname.new(File.expand_path("../", __dir__) + '/repos'))
      end

      def locate_include_file(context, file, safe)
        includes_dirs = tag_includes_dirs(context)
        includes_dirs.each do |dir|
          path = PathManager.join(dir, file+'.md')
          return path if valid_include_file?(path, dir.to_s, safe)
        end
        raise IOError, could_not_locate_message(file, includes_dirs, safe)
      end
    end
  end
end

Liquid::Template.register_tag('include_repo', Jekyll::Tags::IncludeRepoTag)
