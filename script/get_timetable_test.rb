require File.expand_path(File.dirname(__FILE__) + '/get_timetable')



class ParseTest < Test::Unit::TestCase

  def setup
    @h = get_all_timetables
  end
  
  def gather sessions, room
    a = []
    sessions.each do |session|
      a << session if session[:room] == room
    end
    a
  end
  
=begin
  def test_ja
    
    sessions = @h[:ja][:timetables][0][:sessions]
    assert_equal 10, gather(sessions, "大ホール").size
    assert_equal 10, gather(sessions, "中ホール200").size
    assert_equal 1, gather(sessions, "202-B").size
    assert_equal 3, gather(sessions, "202-A").size
    assert_equal 0, gather(sessions, "201-B").size
    assert_equal 2, gather(sessions, "201-A").size
    assert_equal 1, gather(sessions, "ホワイエ").size
    
    sessions = @h[:ja][:timetables][1][:sessions]
    assert_equal 10, gather(sessions, "大ホール").size
    assert_equal 9, gather(sessions, "中ホール200").size
    assert_equal 1, gather(sessions, "202-B").size
    assert_equal 3, gather(sessions, "202-A").size
    assert_equal 4, gather(sessions, "201-B").size
    assert_equal 2, gather(sessions, "201-A").size
    assert_equal 1, gather(sessions, "ホワイエ").size
    
    sessions = @h[:ja][:timetables][2][:sessions]
    assert_equal 12, gather(sessions, "大ホール").size
    assert_equal 12, gather(sessions, "中ホール200").size
    assert_equal 2, gather(sessions, "202-B").size
    assert_equal 3, gather(sessions, "202-A").size
    assert_equal 3, gather(sessions, "201-B").size
    assert_equal 0, gather(sessions, "201-A").size
    assert_equal 1, gather(sessions, "ホワイエ").size
  end

  def test_en
    
    sessions = @h[:en][:timetables][0][:sessions]
    assert_equal 10, gather(sessions, "Main Convention Hall").size
    assert_equal 10, gather(sessions, "Convention Hall 200").size
    assert_equal 1, gather(sessions, "202-B").size
    assert_equal 3, gather(sessions, "202-A").size
    assert_equal 0, gather(sessions, "201-B").size
    assert_equal 2, gather(sessions, "201-A").size
    assert_equal 1, gather(sessions, "Foyer").size
    
    sessions = @h[:en][:timetables][1][:sessions]
    assert_equal 10, gather(sessions, "Main Convention Hall").size
    assert_equal 9, gather(sessions, "Convention Hall 200").size
    assert_equal 1, gather(sessions, "202-B").size
    assert_equal 3, gather(sessions, "202-A").size
    assert_equal 4, gather(sessions, "201-B").size
    assert_equal 2, gather(sessions, "201-A").size
    assert_equal 1, gather(sessions, "Foyer").size
    
    sessions = @h[:en][:timetables][2][:sessions]
    assert_equal 12, gather(sessions, "Main Convention Hall").size
    assert_equal 12, gather(sessions, "Convention Hall 200").size
    assert_equal 2, gather(sessions, "202-B").size
    assert_equal 3, gather(sessions, "202-A").size
    assert_equal 3, gather(sessions, "201-B").size
    assert_equal 0, gather(sessions, "201-A").size
    assert_equal 1, gather(sessions, "Foyer").size
  end
=end

  def test_get_lightningtalks
    url = "http://rubykaigi.org/2010/ja/events/38"
    agent = WWW::Mechanize.new
    agent.get(url)
    page = agent.page
    content = page.search("div#content")[0]
    
    get_lightningtalks context
  end
  
end
