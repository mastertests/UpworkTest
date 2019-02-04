require 'selenium-webdriver'

class BasePage
  class << self
    attr_accessor :browser
  end

  def initialize(browser)
    @browser = browser
  end

  #===========================================================================================
  # Base actions
  #===========================================================================================

  # Open defined url
  #
  # @param [String]: URL needed to open
  def get(url)
    Log.message("Open <#{url}> page >>")

    @browser.get(url)
    sleep 2
  end

  # Closing current page
  def close
    Log.message('Closing page >>')

    if @browser.nil?
      Log.error('Page is already closed')
    else
      @browser.close
      Log.message('Page closed')
    end
  end

  # Closing current browser
  def exit
    Log.message('Closing browser >>')

    if @browser.nil?
      Log.error('Browser is already closed')
    else
      @browser.quit
      Log.message('Browser closed')
    end
  end

  # Clear all cookies from browser
  def clear_cookies
    Log.message('Delete all cookies >>')

    @browser.manage.delete_all_cookies
  end

  # Get the URL of the current page
  #
  # @return [String]
  def url
    @browser.current_url
  end

  # Get the title of the current page
  #
  # @return [String]
  def title
    @browser.title
  end

  #===========================================================================================
  # Element actions
  #===========================================================================================

  # Get element by locator
  #
  # @param [ElementLocator]: Locator of element need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @return [Element]: Founded element
  def get_element(element, arg = nil)
    Log.message('Getting element >>')

    if element.instance_of?(ElementLocator)
      if arg.nil?
        @browser.find_element("#{element.locator_type}": element.locator)
      else
        @browser.find_element("#{element.locator_type}": element.locator.gsub('?', arg.to_s))
      end
    else
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
    end
  end

  # Get element by locator
  #
  # @param element [ElementLocator]: Locator of element need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @return [Array<Element>]: Array of founded elements
  def get_elements(element, arg = nil)
    Log.message('Getting elements >>')

    if element.instance_of?(ElementLocator)
      if arg.nil?
        @browser.find_elements("#{element.locator_type}": element.locator)
      else
        @browser.find_elements("#{element.locator_type}": element.locator.gsub('?', arg.to_s))
      end
    else
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
    end
  end

  # Get element text
  #
  # @param element [ElementLocator]: Locator of element need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in element locator
  #
  # @return [String]: Text of define element if element displayed
  def get_element_text(element, arg = nil)
    Log.message('Getting element text >>')

    get_element(element, arg).text
  end

  # Get elements text
  #
  # @param element [ElementLocator]: Locator of elements need to find
  #
  # @param arg [Symbol, String, Integer]: Argument in elements locator
  #
  # @return [Array<String>]: Text of define element if element displayed
  def get_elements_text(element, arg = nil)
    Log.message('Getting elements text >>')

    elements_text = []

    get_elements(element, arg).each do |web_element|
      elements_text << web_element.text
    end

    elements_text
  end

  # Check element displayed
  #
  # @param element [ElementLocator]: Locator of element need to check
  #
  # @param arg [Symbol, String, Integer]: Argument in elements locator
  #
  # @return [Boolean]: if element displayed return true
  def displayed?(element, arg = nil)
    Log.message('Checking element displayed >>')

    unless element.instance_of?(ElementLocator)
      Log.error('Param <element> is not [ElementLocator] ---Ignored')
      return
    end

    # Array should be empty if element(s) absent
    # This method quicker than default
    if get_elements(element, arg).empty?
      Log.error("Elements with #{element.locator_type} <#{element.locator}> is not displayed")
      false
    else
      Log.message("Elements with #{element.locator_type} <#{element.locator}> is displayed")
      true # return if at least one is displayed
    end
  end

  #===========================================================================================
  # Click actions
  #===========================================================================================

  # Click on element by locator
  #
  # @param element [ElementLocator]: Locator of element need to click
  #
  # @param arg [Symbol, String, Integer]: Argument in elements locator
  def click(element, arg = nil)
    Log.message("Clicking on element #{element.element_id} >>")

    if displayed?(element, arg)
      get_element(element, arg).click
    else
      Log.error("Element #{element.element_id} is absent")
    end
  end

  # Click on element and wait some time
  #
  # @param element [ElementLocator]: Locator of element need to click
  #
  # @param sec [Integer]: Waiting time in seconds
  #
  # @param arg [Symbol, String, Integer]: Argument in elements locator
  def click_wait(element, sec, arg = nil)
    Log.message("Clicking and wait element #{element.element_id} >>")

    click(element, arg)
    wait(sec)
  end

  # Click on element and wait until needed element displayed
  #
  # @param element [ElementLocator]: Locator of element need to click
  #
  # @param timeout [Integer]: Timeout in seconds
  #
  # @param element_waiting_for [ElementLocator]: Locator of element waiting for
  def click_wait_until_displayed(element, timeout, element_waiting_for)
    Log.message("Clicking and wait until element #{element_waiting_for.element_id} present >>")

    click(element)
    wait_until_element_displayed(element_waiting_for, timeout)
  end

  #===========================================================================================
  # Type actions
  #===========================================================================================

  # Type text in text field
  #
  # @param field [ElementLocator]: Locator of text field
  #
  # @param text [String]: Text to type
  def type(field, text)
    Log.message("Typing text <#{text}> in field <#{field.element_id}> >>")

    get_element(field).send_keys(text)
  end

  # Press button in specify area
  #
  # @param area [ElementLocator]: Locator of area where need to press button
  #
  # @param button [Symbol]: Button need to press
  #     e.g. :enter, :tab, :space
  def press_button(area, button)
    Log.message("Press #{button} button >>")

    get_element(area).send_keys(button)
  end

  #===========================================================================================
  # Wait actions
  #===========================================================================================

  # Wait some time in seconds
  #
  # @param [Integer]
  def wait(sec)
    Log.message("Waiting #{sec} sec >>")

    sleep sec
  end

  # Waiting for element present
  #
  #
  # @param element [ElementLocator]: Element waiting for
  #
  # @param timeout [Integer]: Timeout in seconds
  def wait_until_element_displayed(element, timeout = 5)
    Log.message('Waiting until element displayed >>')

    if timeout.instance_of?(Integer) && element.instance_of?(ElementLocator)
      Selenium::WebDriver::Wait.new(timeout: timeout).until { displayed?(element) }
    else
      Log.warning('Param <timeout> is not [Integer] ---Ignored and default used') unless timeout.instance_of?(Integer)
      Log.error('Param <element> is not [ElementLocator] ---Ignored') unless element.instance_of?(ElementLocator)
    end
  end
end