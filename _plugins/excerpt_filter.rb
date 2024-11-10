module Jekyll
    module ExcerptFilter
      def clean_excerpt(content)
        # 디버그: content 값 확인
        puts "Original Content: #{content.inspect}"
  
        # 만약 content가 nil이거나 비어있으면 기본값 반환
        if content.nil? || content.strip.empty?
          puts "Content is nil or empty"
          return "No content available"
        end
  
        # 이미지 태그들 제거
        filtered_content = content.dup
        
        # Markdown 이미지 제거 (![text](url) 형식)
        filtered_content.gsub!(/!\[([^\]]*?)\][\s]*\(([^\)]+)\)/, '')
        
        # HTML 이미지 태그 제거 (<img> 태그)
        filtered_content.gsub!(/<img\s+[^>]*>/i, '')
        
        # 필터링 후 내용이 비어있는지 확인
        if filtered_content.strip.empty?
          return "No text content available"
        end
  
        # 나머지 Markdown 문법 제거
        filtered_content.gsub!(/\*\*?(.*?)\*\*?/, '\1')  # 볼드/이탤릭
        filtered_content.gsub!(/^>\s*(.*)$/, '\1')  # 인용구
        filtered_content.gsub!(/^\s*[-*+]\s+(.*)$/, '\1')  # 불릿 리스트
        filtered_content.gsub!(/^\s*\d+\.\s+(.*)$/, '\1')  # 숫자 리스트
        filtered_content.gsub!(/\[(.*?)\]\(.*?\)/, '\1')  # 링크
        filtered_content.gsub!(/^#+\s*(.*)$/, '\1')  # 헤더
        
        # HTML 태그 제거
        filtered_content.gsub!(/<(script|style).*?<\/\1>/m, '')
        filtered_content.gsub!(/<\/?[^>]*>/, '')
  
        # 줄바꿈 및 공백 정리
        filtered_content.strip!
        filtered_content.gsub!(/\s+/, ' ')
  
        puts "Filtered Content: #{filtered_content.inspect}"
        filtered_content
      end
    end
  end
  
  Liquid::Template.register_filter(Jekyll::ExcerptFilter)