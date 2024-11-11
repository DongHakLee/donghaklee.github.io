module Jekyll
  class ExcerptFilter
    def self.clean_excerpt(page)
      # 페이지의 내용을 문자열로 가져오기
      content = page.output.to_s.dup

      # Markdown 이미지 제거
      content.gsub!(/!\[(?:.*?)\]\((?:.*?)\)/, '')
      
      # HTML 이미지 태그 제거
      content.gsub!(/<img[^>]*>/i, '')
      
      # Markdown 문법 제거
      content.gsub!(/\*\*?(.*?)\*\*?/, '\1')        # 볼드/이탤릭
      content.gsub!(/^>\s*(.*)$/m, '\1')            # 인용구
      content.gsub!(/^\s*[-*+]\s+(.*)$/m, '\1')     # 불릿 리스트
      content.gsub!(/^\s*\d+\.\s+(.*)$/m, '\1')     # 숫자 리스트
      content.gsub!(/\[([^\]]*?)\]\((?:.*?)\)/, '\1') # 링크
      content.gsub!(/^#+\s*(.*)$/m, '\1')           # 헤더
      
      # HTML 태그 제거 (개선된 방식)
      content.gsub!(/<(script|style)[^>]*>.*?<\/\1>/mi, '')
      content.gsub!(/<[^>]*>/, '')

      # 특수문자 및 공백 처리
      content = CGI.unescapeHTML(content)
      content.gsub!(/\s+/, ' ')
      content.strip!

      # 페이지의 output을 업데이트
      page.output = content
    end
  end
end

# 후크 등록
Jekyll::Hooks.register [:pages, :posts, :documents], :post_render do |page|
  ExcerptFilter.clean_excerpt(page)
end
