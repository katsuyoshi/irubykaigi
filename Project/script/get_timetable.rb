require 'rubygems'
require 'mechanize'

@keys = %w(date time title speaker room floor)
@sessions = []
@rooms = []

def normalized_room room
  @rooms.each do |r|
    if r[0, room.size] == room
      return r
    end
  end
  if room == 'Hitotsubashi Memorial Hall'
    room = 'Hitotsubashi Memorial Hall(2nd Floor)'
  end
  @rooms << room
  room
end

def parse_timetable elements, day
  rooms = elements.search('th.room').map {|e| e.inner_text}
  elements.search('tbody tr').each do |session_info|
    time = session_info.search('th').first.inner_text
    session_info.search('div.session').each_with_index do |e, i|
      session = Hash.new
      titles = e.search('p.title')
      session['title'] = titles.first.inner_text.gsub(',', '、') if titles.first
      speakers = e.search('p.speaker')
      session['speaker'] = speakers.first.inner_text.gsub(',', '、') if speakers.first
      if rooms[i]
        /(.*)\((.*)\)/ =~ normalized_room(rooms[i])
        session['room'] = $1
        session['floor'] = $2
      end
      session['time'] = time
      session['date'] = day
      @sessions << session
    end

    session_info.search('td.break').each do |e|
      session = Hash.new
      session['title'] = 'break'
      session['time'] = time
      session['date'] = day
      @sessions << session
    end
  end
end

def get_parse_store_and_love uri, filename
  @sessions = []
  @rooms = []
  
  # セッション情報の取得
  agent = WWW::Mechanize.new
  agent.get(uri)
  
  # 解析
  days = agent.page.search('h2').map {|e| e.inner_text.gsub(/年|月/, '-').gsub(/日.*/, '')}
  agent.page.search('table.timetable').each_with_index do |timetable, i|
    parse_timetable timetable, Date.parse(days[i])
  end

  # ファイルのデータに整形
  lines = []
  @sessions.each do |s|
    a = []
    @keys.each do |key|
      a << s[key] ? s[key] : ''
    end
    lines << a.join(',')
  end
#  puts lines.join('\n')

  # ファイルに保存
  File.open(filename, 'w') do |f|
    f.puts @keys.join(',')
    lines.each do |l|
      f.puts l
    end
  end
end


get_parse_store_and_love 'http://rubykaigi.org/2009/ja/talks', './Japanese.lproj/session_info.csv'
get_parse_store_and_love 'http://rubykaigi.org/2009/en/talks', './English.lproj/session_info.csv'

