require_relative '../entities/element_locator'

class HomePage < BasePage

  SEARCH_FIELD = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//input[@name="q"]')
  SEARCH_BUTTON = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//button[contains(.,"Submit search")]')
  SEARCH_CATEGORY_BUTTON = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//button[contains(.,"Switch search source")]')

  DROPDOWN_OPTION_FREELANCERS = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//li[@data-label="Freelancers"]')
  DROPDOWN_OPTION_JOBS = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//li[@data-label="Jobs"]')

  def search_for(category, keyword)

    unless %w[jobs freelancers].include?(category.to_s)
      Log.error("Category #{category} is not allowed")
      return
    end

    if category.to_s.include?('freelancers')
      search_for_freelancers(keyword)
    else
      search_for_jobs(keyword)
    end
  end

  private

  def search_for_jobs(keyword)
    Log.message("Input <#{keyword}> and search for jobs >>")

    Log.message('Choose <Jobs> category')
    click_wait(SEARCH_CATEGORY_BUTTON, 3)
    click(DROPDOWN_OPTION_JOBS) unless selected?(DROPDOWN_OPTION_JOBS, nil, false)

    Log.message("Input <#{keyword}> and click on search button")
    click(SEARCH_FIELD)
    type(SEARCH_FIELD, keyword)
    click_wait(SEARCH_BUTTON, 10)

    SearchResultPage.new(BaseTest.driver)
  end

  def search_for_freelancers(keyword)
    Log.message("Input <#{keyword}> and search for freelancer >>")

    Log.message('Choose <Freelancers> category')
    click_wait(SEARCH_CATEGORY_BUTTON, 3)
    click(DROPDOWN_OPTION_FREELANCERS) unless selected?(DROPDOWN_OPTION_FREELANCERS, nil, false)

    Log.message("Input <#{keyword}> and click on search button")
    click(SEARCH_FIELD)
    type(SEARCH_FIELD, keyword)
    click_wait(SEARCH_BUTTON, 10)

    SearchResultPage.new(BaseTest.driver)
  end
end