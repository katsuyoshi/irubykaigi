require 'rubygems'
require 'mechanize'
require 'open-uri'
require File.expand_path(File.dirname(__FILE__) + '/simple-json')

@base_dir = File.expand_path(File.dirname(__FILE__))
@store_dir = @base_dir + "/.."


def get_sessions timetable

  times = []
  sessions = []
  rooms = nil
  
  times = timetable.search('tr').collect{|l| l.search('th').text }
  times.shift
  times.collect! {|l| a = l.split("|"); { :start_at => a[0].gsub("\n", "").strip, :end_at => a[1].gsub("\n", "").strip }}
  
  lines = timetable.search('tr')

  cols = lines[0].search('th').size
  rowspan_flags = Array.new(lines.size) { Array.new(cols) }
  
  lines.each_with_index do |tr, row|
    if row == 0
      rooms = tr.search('th').collect{|e| e.inner_text.gsub("\n", "").strip}
      rooms.shift
    else
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
          s = td.search('div.session')
          session = {
            :title => s.search('p.title').text.gsub("\n", "").strip,
            :speakers => s.search('p.speaker').text.split("/").collect{|e| e.gsub("\n", "").strip},
            :start_at => times[row - 1][:start_at],
            :end_at => times[row + rowspan - 2][:end_at],
            :room => rooms[col],
            :type => 'session'
          }
        when "break"
          s = td.search('div.session')
          session = {
            :title => s.search('p.title').text.gsub("\n", "").strip,
            :start_at => times[row - 1][:start_at],
            :end_at => times[row + rowspan - 2][:end_at],
            :room => rooms[col],
            :type => 'break'
          }
        when "empty"
        else
          $stderr.puts "unknown class '#{td[:class]}'"
        end
        
        sessions << session if session
        
      end
    end
  end
  return sessions, rooms
end

def get_timetables uri
  timetables = []

  # セッション情報の取得
  agent = WWW::Mechanize.new
  agent.get(uri)
  page = agent.page
  
  days = ['2010/8/27', '2010/8/28', '2010/8/29']

  rooms = nil
  page.search('table.timetable').each_with_index do |timetable, i|
    sessions, rooms = get_sessions(timetable)
    timetables << { :day => days[i],
                    :sessions => sessions  }
  end
  
  { :timetables => timetables,
    :rooms => rooms }
end

def get_all_timetables
   { :ja => get_timetables('http://rubykaigi.org/2010/ja/timetable'),
               :en => get_timetables('http://rubykaigi.org/2010/en/timetable') }
end


puts WebAPI::JsonBuilder.new.build(get_all_timetables)
