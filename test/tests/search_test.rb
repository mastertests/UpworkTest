require_relative 'base_test'

Dir[File.join(__dir__, '../pages', '*.rb')].each(&method(:require))

#-------------------------------------------------------------------------------------------------------
# SUMMARY: Searching for +keyword+ and check results
#-------------------------------------------------------------------------------------------------------
class SearchTest < BaseTest

  # [1] Run `<browser>`
  # [2] Clear `<browser>` cookies
  Log.step('Run browser and clear cookies')
  page = HomePage.new(BaseTest.driver)
  page.clear_cookies

  # [3] Go to www.upwork.com
  Log.step('Open upwork home page')
  page.get(Constants::HOME_URL)

  # [4] Focus onto "Find freelancers"
  # [5] Enter `<keyword>` into the search input right from the dropdown
  # and submit it (click on the magnifying glass button)
  Log.step('Input <keyword> into the search field and submit')
  search_page = page.search_for(Constants::KEYWORD)

  # [6] Parse the 1st page with search results:
  # store info given on the 1st page of search results as structured data of any chosen by you type
  Log.step('Parse the 1st page with search results')
  freelancer_profiles = search_page.results

  # [7] Make sure at least one attribute (title, overview, skills, etc) of each item (found freelancer)
  # from parsed search results contains `<keyword>` Log in stdout which freelancers and attributes contain `<keyword>` and which do not.
  Log.step('Make sure at least one attribute of each item contains `<keyword>`')
  freelancer_profiles.each(&:attr_check)

end