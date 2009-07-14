require 'rubygems'
require 'mechanize'

@base_dir = File.expand_path(File.dirname(__FILE__))
@store_dir = @base_dir + "/.."

@keys = %w(date title speaker belonging)
@lightning_talks = []


# 所属の開始位置を検索する
def search_belonging_point str
  if str[str.length() -1] == ')'[0]
    count = 1
    (str.length() - 2).downto(0) do |i|
      case str[i]
      when '('[0]
        count = count - 1
      when ')'[0]
        count = count + 1
      end
      if count == 0
        return i
      end
    end 
  end
  0
end


def parse_lightning_talks page, skip_title

  # 日付の取得
  /\((.*)\)/ =~ page.search('h2').first
  day = $1
  
  # 発表内容の取得
  page.search('ol').each do |ol|
    ol.search('li').each do |li|
      talk = Hash.new
      talk['date'] = day
      text = li.inner_text.strip
      a = []
      unless skip_title
        i = search_belonging_point text
        talk['title'] = text[0, i]
        a = text[i + 1, text.length() - i - 2].split(',')
      else
        a = text.split(',')
      end
      talk['speaker'] = a[0].strip if a[0]
      talk['belonging'] = a[1].strip if a[1]
      @lightning_talks << talk
    end
  end
end

def get_parse_store_and_love uris, filename, skip_title = false
  @lightning_talks = []
  
  # セッション情報の取得
  agent = WWW::Mechanize.new
  uris.each do |uri|
    agent.get(uri)
    parse_lightning_talks agent.page, skip_title
  end

  # ファイルのデータに整形
  lines = []
  @lightning_talks.each do |s|
    a = []
    @keys.each do |key|
      a << s[key] ? s[key] : ''
    end
    lines << a.join("\t")
  end

  # ファイルに保存
  File.open(filename, 'w') do |f|
    f.puts @keys.join("\t")
    lines.each do |l|
      f.puts l
    end
  end
  
end
  
get_parse_store_and_love ['http://rubykaigi.org/2009/ja/talks/17H05', 'http://rubykaigi.org/2009/ja/talks/18H06'], @store_dir + '/Japanese.lproj/lightning_talks_info.csv'
get_parse_store_and_love ['http://rubykaigi.org/2009/en/talks/17H05', 'http://rubykaigi.org/2009/en/talks/18H06'], @store_dir + '/English.lproj/lightning_talks_info.csv', true
