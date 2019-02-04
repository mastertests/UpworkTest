require_relative '../entities/freelancer_profile'

class SearchPage < BasePage

  SEARCH_RESULT_LOCATOR = '//section//section[contains(@data-compose-log-data,", ?)")]'.freeze
  SEARCH_RESULT_SECTION = ElementLocator.new(:xpath, '//section//section[@data-compose-log-data]')

  FREELANCER_NAME = ElementLocator.new(:xpath,
                                       SEARCH_RESULT_LOCATOR + '//div[contains(@class,"ellipsis")]//h4')
  FREELANCER_TITLE = ElementLocator.new(:xpath,
                                        SEARCH_RESULT_LOCATOR + '//div[contains(@class,"m-0-top-bottom")][not(contains(@class,"ellipsis"))]//h4')
  FREELANCER_DESCRIPTION = ElementLocator.new(:xpath,
                                              SEARCH_RESULT_LOCATOR + '//div[contains(@class,"d-lg-block")]//p')
  FREELANCER_SKILLS = ElementLocator.new(:xpath,
                                         SEARCH_RESULT_LOCATOR + '//a[contains(@class,"o-tag-skill")]')

  def results
    i = 1
    profiles = []

    while i <= get_elements(SEARCH_RESULT_SECTION).size
      profiles << FreelancerProfile.new(get_element_text(FREELANCER_NAME, i),
                                        get_element_text(FREELANCER_TITLE, i),
                                        displayed?(FREELANCER_DESCRIPTION, i) ? get_element_text(FREELANCER_DESCRIPTION, i) : 'No description',
                                        get_elements_text(FREELANCER_SKILLS, i))

      i += 1
    end

    profiles
  end
end