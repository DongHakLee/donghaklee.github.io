Jekyll::Hooks.register [:pages, :posts, :documents], :post_render do |page|
    # 빈 generator 태그 제거
    page.output.gsub!(/<meta name="generator">\s*/, '')
  
    # Jekyll SEO 태그가 추가한 generator 태그 수정
    if page.output =~ /<meta name="generator" content="Jekyll/
    #   page.output.gsub!(/<meta name="generator" content="Jekyll[^>]+>/, '<meta name="generator" content="원하시는 내용으로 변경" />')
      page.output.gsub!(/<meta name="generator" content="Jekyll[^>]+>/, '')
    end

    # Jekyll SEO 주석 제거
    page.output.gsub!(/<!-- Begin Jekyll SEO tag v[\d\.]+ -->\s*/, '')
    page.output.gsub!(/<!-- End Jekyll SEO tag -->\s*/, '')

    # HTML lang 속성 변경
    if page.output =~ /<html lang="en"/
        page.output.gsub!(/<html lang="en"/, '<html lang="ko"')
    end

    # Open Graph og:locale 속성 변경
    if page.output =~ /<meta property="og:locale" content="en_US"/
        page.output.gsub!(/<meta property="og:locale" content="en_US"/, '<meta property="og:locale" content="ko_KR"')
    end
  end