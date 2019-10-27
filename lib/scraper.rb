require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url="https://learn-co-curriculum.github.io/student-scraper-test-page/index.html")
    doc = Nokogiri::HTML(open(index_url))
    student_container = doc.css("div.student-card")
    student_array = []
    student_container.each do |student|
      student_hash = {}
      student_hash[:name] = student.css("div.card-text-container h4").text
      student_hash[:location] = student.css("p.student-location").text
      student_hash[:profile_url] = student.css("a")[0].attributes["href"].value
      student_array.push(student_hash)
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    student_info = {}
    doc = Nokogiri::HTML(open(profile_url))
    social_container = doc.css("div.main-wrapper")
    
    social_container.css("div.social-icon-container a").each do |box|
      if box.attribute("href").value.include?("twitter")
        student_info[:twitter] = box.attribute("href").value
      elsif box.attribute("href").value.include?("linkedin")
        student_info[:linkedin] = box.attribute("href").value
      elsif box.attribute("href").value.include?("github")
        student_info[:github] = box.attribute("href").value
      else
        student_info[:blog] = box.attribute("href").value
      end
    end
    
    student_info[:profile_quote] = social_container.css("div.profile-quote").text
    student_info[:bio] = social_container.css("div.description-holder p").text
    
    student_info
    
  end

end

