require 'rubygems'
require 'mechanize'

@keys = %w(date time title speaker break room floor)
@sessions = []
@rooms = []

def add_room room
  @rooms.each do |r|
    if r[0, room.size] == room
      return r
    end
  end
  if room == 'Hitotsubashi Memorial Hall'
    room = 'Hitotsubashi Memorial Hall(2nd Floor)'
  end
  /(.*)\((.*)\)/ =~ room
  @rooms << [$1, $2]
  room
end

def room_for_index i
  @rooms[i]
end

def parse_timetable elements, day
  # 部屋情報
  elements.search('th.room').map {|e| add_room(e.inner_text)}
  
  elements.search('tbody tr').each do |session_info|
    
    # 時間帯
    time = session_info.search('th').first.inner_text
    
    # session情報の取得
    session_info.search('div.session').each_with_index do |e, index|
      session = Hash.new
      titles = e.search('p.title')
      session['title'] = titles.first.inner_text.gsub(',', '、') if titles.first
      speakers = e.search('p.speaker')
      session['speaker'] = speakers.first.inner_text.gsub(',', '、') if speakers.first
      # 部屋は仮設定。この後sessionsのインデックスから振り直す
      session['room'], session['floor'] = room_for_index(index)
      session['time'] = time
      session['date'] = day
      @sessions << session
    end

    # breakの情報
    session_info.search('td.break').each do |e|
      session = Hash.new
      session['title'] = e.inner_text
      session['time'] = time
      session['date'] = day
      session['room'] = nil
      session['floor'] = nil
      session['break'] = true
      @sessions << session
    end
  end

  # 部屋の振り直し
  elements.search('tbody tr').each do |session_info|
    session_info.search('td.sessions').each_with_index do |sessions, index|
      sessions.search('div.session').each do |e|
        titles = e.search('p.title')
        if titles
          title = titles.first.inner_text.gsub(',', '、')
          if title
            session = @sessions.find {|e| e['title'] == title && !e['break'] }
            session['room'], session['floor'] = room_for_index(index) if session
          end
        end
      end
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

