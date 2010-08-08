require 'rubygems'
require 'mechanize'
require 'open-uri'
require File.expand_path(File.dirname(__FILE__) + '/simple-json')

@base_dir = File.expand_path(File.dirname(__FILE__))
#@store_dir = @base_dir + "/../../../public/irubykaigi/2010/"
@store_dir = @base_dir + "/"
@filename = @store_dir + "timetables.json"

class String
  def strip_ns
    self.gsub("\n", "").strip
  end
end


def get_lightningtalks content
  talks = content.search("li").collect do |l|
    talk = { :speakers => []}
    t = l.text.strip_ns
    t.gsub!('Urabe, Shyouhei', 'Urabe Shyouhei')
    t.split(",").each_with_index do |e, i|
      case i
      when 0
        talk[:title] = e.strip_ns
      when 1
        talk[:speakers] << { :name =>  e.split('(')[0].strip_ns }
      end
    end
    talk
  end
  talks
end


def get_foot_section content, day
  th = content.search('th').text
  return nil if th == ""
  
  a = th.strip_ns.split('-')
  session = { :start_at => a[0].strip_ns, :end_at => a[1].strip_ns }
  
  a = content.search('td').text.strip_ns.split(',')
  session[:title] = a[0].strip_ns
  /([^\(]+)(\([^\)]+\))?/ =~ a[1].strip_ns.gsub("於 ", "").gsub(/\s*at\s*/, "")
  session[:room] = $1;
  session[:summary] = $2 if $2
  session[:type] = 'party'
  session[:code] = "#{day}|#{$1}|#{session[:start_at]}"
  session
end

def get_session href
  url = "http://rubykaigi.org" + href
  agent = WWW::Mechanize.new
  agent.get(url)
  page = agent.page

  content = page.search("div#content")[0]
  
  session = { :code => url.split('/').last }
  
  key = nil
  index = 0
  content.children.each do |c|
    case c.name
    when "h1"
      session[:title] = c.text.strip_ns
      case session[:title]
      when "Lightning Talks"
        session[:type] = 'lightning_talks'
      when "Opening"
        session[:type] = 'opening'
      when "Closing"
        session[:type] = 'closing'
      end
#p session
      key = nil
    when "h2"
      case c.text.strip_ns
      when "スピーカー", "Speaker(s)"
        key = :speakers
      when "概要", "Abstract"
        key = :summary
        index = 0
      when "日程", "Date"
        key = :time
      when "会場", "Room"
        key = :room
      when "話す自然言語", "Spoken Language"
        key = nil
      else
        key = nil
      end
    when "p"
      if session[key] == nil
        case key
        when :speakers
          n = c.text.split('/').collect { |s| { :name => s.strip_ns.split('(').first } }
          session[:speakers] = n
        when :summary
          session[:summary] = c.text.strip_ns if index == 1
          index += 1
        when :time
          t = c.text.strip_ns.split(' ')
          session[:start_at] = t[1]
          session[:end_at] = t[3]
        when :room
          session[:room] = c.text.strip_ns
        end
      end
    end
  end

  session[:lightning_talks] = get_lightningtalks content if session[:type] == "lightning_talks"
  
  session
end


def get_sessions timetable, day

  times = []
  sessions = []
  rooms = nil
  
  times = timetable.search('tbody').search('tr').collect{|l| l.search('th').text }
  times.collect! do |l|
    a = l.split("|");
    if a.size == 2
      { :start_at => a[0].strip_ns, :end_at => a[1].strip_ns }
    else
      nil
    end
  end
  
  rooms = timetable.search('thead').search('th').collect{|e| e.inner_text.strip_ns}
  rooms.shift  
  
  lines = timetable.search('tbody').search('tr')

  cols = lines[0].search('th').size
  rowspan_flags = Array.new(lines.size) { Array.new(cols) }
  
  lines.each_with_index do |tr, row|
    col = 0
    tr.search('td').each_with_index do |td, i|

      # rowspan割当分colを進める
      until rowspan_flags[row][col].nil?
        col += 1
      end

      # マーク
      rowspan = td[:rowspan] ? td[:rowspan].to_i : 1
      rowspan.times {|i| rowspan_flags[row + i][col] = 1 }

      session = nil

      case td[:class]
      when "room", "room_hall"
        a = td.search('a')
        session = get_session(a.first[:href]) if a && a.first
        session[:speakers] = td.search('p.speaker').text.split("/").collect{|e| { :name => e.strip_ns } } if session
#p session
      when "break"
        s = td.search('div.session')
        session = {
            :title => s.search('p.title').text.strip_ns,
            :start_at => times[row][:start_at],
            :end_at => times[row + rowspan - 1][:end_at],
            :room => rooms[col],
            :type => 'break',
            :code => "#{day}|#{rooms[col]}|#{times[row - 1][:start_at]}"
        }
      when "empty", nil
      else
        $stderr.puts "unknown class '#{td[:class]}'"
      end
        
      sessions << session if session
        
    end
  end
  
  foot = timetable.search("tfoot")
  unless foot == ""
    session = get_foot_section foot, day
#p session
    if session
      rooms << session[:room] unless rooms.include? session[:room]
#puts rooms
      sessions << session
    end
  end

  return sessions, rooms
end

def get_timetables url
  timetables = []

  # セッション情報の取得
  agent = WWW::Mechanize.new
  agent.get(url)
  page = agent.page
  
  days = ['2010/8/27', '2010/8/28', '2010/8/29']

  rooms = nil
  page.search('table.timetable').each_with_index do |timetable, i|
    sessions, rooms = get_sessions(timetable, days[i])
    timetables << { :day => days[i],
                    :sessions => sessions  }
  end
  
  { :timetables => timetables,
    :rooms => rooms }
end

def get_all_timetables
   { :ja => get_timetables('http://rubykaigi.org/2010/ja/timetable'),
     :en => get_timetables('http://rubykaigi.org/2010/en/timetable'),
     :updated_at => Time.now.strftime("%Y-%m-%d %X %z") }
end


timetables = get_all_timetables
old_timetables = File.exists?(@filename) ? WebAPI::JsonParser.new.parse(File.read(@filename)) : {}
unless timetables[:ja] == old_timetables["ja"] && timetables[:en] == old_timetables["en"]
  File.open(@filename, 'w') do |f|
    f.write(WebAPI::JsonBuilder.new.build(timetables))
  end
end
