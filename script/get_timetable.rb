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
#p rooms
    else
      col = 0
      tr.search('td').each_with_index do |td, i|
        
        # rowspan割当分colを進める
        unless rowspan_flags[row][col].nil?
#p rowspan_flags[row][col]
          col += 1
        end
#puts "#{row}, #{col}"
        # マーク
        rowspan = td[:rowspan] ? td[:rowspan].to_i : 1
        rowspan.times {|i| rowspan_flags[row + i][col] = 1 }

#p [row, col]        
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
#puts "#{row}, #{col}, #{session[:title]}"
          sessions << session
        when "break"
          s = td.search('div.session')
          session = {
            :title => s.search('p.title').text.gsub("\n", "").strip,
            :start_at => times[row - 1][:start_at],
            :end_at => times[row + rowspan - 2][:end_at],
            :room => rooms[col],
            :type => 'break'
          }

#puts "#{row}, #{col}, #{session[:title]}"

# puts col, rooms[col]
          sessions << session
        when "empty"
        else
          $stderr.puts "unknown class '#{td[:class]}'"
        end 
        
        col += 1
        
      end
    end
  end
  sessions
end

def get_timetables uri
  timetables = []

  # セッション情報の取得
  agent = WWW::Mechanize.new
  agent.get(uri)
  page = agent.page
  
  days = ['8/27', '8/28', '8/29']

  page.search('table.timetable').each_with_index do |timetable, i|
    timetables << { :day => days[i],
                    :sessions => get_sessions(timetable) }
  end
  
  { :timetables => timetables }
end


h = { :ja => get_timetables('http://rubykaigi.org/2010/ja/timetable'),
               :en => get_timetables('http://rubykaigi.org/2010/en/timetable') }

puts WebAPI::JsonBuilder.new.build(h)
