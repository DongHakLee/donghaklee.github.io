Jekyll::Hooks.register :documents, :pre_render do |doc, payload|
    if doc.data["permalink"]
      # 기존 permalink를 기반으로 프린트용 URL 생성
      print_permalink = "/print" + doc.data["permalink"]
  
      # 새로운 페이지 객체 생성
      print_page = Jekyll::Page.new(doc.site, doc.site.source, File.dirname(doc.path), File.basename(doc.path))
  
      print_page.data = doc.data.clone
      print_page.data["layout"] = "print"
      print_page.data["permalink"] = print_permalink
  
      # 사이트에 새로운 인쇄 페이지 추가
      doc.site.pages << print_page
    end
  end
  