require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    index_page = Nokogiri::HTML(open(index_url))
    students = []

    index_page.css("div.roster-cards-container").each do |card|
      card.css(".student-card").each do |container|
        profile_url = container.css("a").attribute("href").value
        name = container.css(".student-name").text
        location = container.css(".student-location").text
        students << {name: name, location: location, profile_url: profile_url}      
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    profile_page = Nokogiri::HTML(open(profile_url))
    student = {}
    
    x = profile_page.css("div.social-icon-container").children.css("a").collect {|profile| profile.attribute("href").value}
    x.each do |a|

      if a.include?("twitter") 
        student[:twitter] = a
      elsif a.include?("linkedin")
        student[:linkedin] = a
      elsif a.include?("github")
        student[:github] = a
      else
        student[:blog] = a
      end
    end
    student[:profile_quote] = profile_page.css(".profile-quote").text 
    student[:bio] = profile_page.css("div.description-holder p").text
    student
  end
end

