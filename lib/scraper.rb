require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page = Nokogiri::HTML(open(index_url))
    students = []

    page.css("div.roster-cards-container").each do |info|
      info.css(".student-card a").each do |stu|
        student_name = stu.css('.student-name').text
        student_location = stu.css('.student-location').text
        student_url = "#{stu.attr('href')}"
        students << {name: student_name, location: student_location, profile_url: student_url}
      end
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    scraped_student = {}

    profile_page = Nokogiri::HTML(open(profile_url))

    links = profile_page.css(".social-icon-container").children.css("a").map { |el| el.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        scraped_student[:linkedin] = link
      elsif link.include?("github")
        scraped_student[:github] = link
      elsif link.include?("twitter")
        scraped_student[:twitter] = link
      else
        scraped_student[:blog] = link
      end
    end

    scraped_student[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    scraped_student[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")

    scraped_student
  end

end

