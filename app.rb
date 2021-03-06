require 'mechanize'
require 'pry'
require 'csv'

agent = Mechanize.new
agent.user_agent_alias = "Mac Safari 4"
base_url = "http://0.0.0.0:3000/"
time_stamp = Time.now.strftime("%H%M%S")

#for id in 13650..21663 do
ids = [13702,
16760,
16761,
16762,
16763,
16764,
20082,
20429,
20430,
20431,
20616,
20816,]
ids.each do |id|
  begin
    agent.get("#{base_url}/lesson/#{id}") do |page|
      doc = Nokogiri::HTML(page.content.toutf8)
      title = doc.css('h1').text
      puts title
    end
  rescue Mechanize::ResponseCodeError => e
    csv_data = CSV.generate do |csv|
      error_msg = []
      error_msg << id
      error_msg << e.page.uri
      error_msg << id - 2052
      error_msg << id - 12372
      error_msg << "ng"
      csv << error_msg
    end
    File.open("results/#{time_stamp}_results.csv", 'a') do |file|
      file.write(csv_data)
    end
    puts "#{e.page.uri}　でエラーです。"
    next
  end

  puts "#{base_url}/lesson/#{id}"
end
