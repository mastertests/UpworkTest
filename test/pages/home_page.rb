require_relative '../entities/element_locator'

class HomePage < BasePage

  SEARCH_FIELD = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//input[@name="q"]')
  SEARCH_BUTTON = ElementLocator.new(:xpath, '//div[contains(@class,"navbar-collapse d-none")]//button[contains(.,"Submit search")]')

  def search_for(keyword)
    Log.message("Input <#{keyword}> and search >>")

    click(SEARCH_FIELD)
    type(SEARCH_FIELD, keyword)
    click_wait(SEARCH_BUTTON, 10)

    SearchPage.new(BaseTest.driver)
  end
end