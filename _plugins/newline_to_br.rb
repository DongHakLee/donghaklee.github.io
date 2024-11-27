module Jekyll
  module NewlineToBrFilter
    def newline_to_br(input)
      input.gsub(/\n/, "<br>")
    end
  end
end

Liquid::Template.register_filter(Jekyll::NewlineToBrFilter)