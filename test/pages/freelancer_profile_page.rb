require_relative '../entities/element_locator'

class FreelancerProfilePage < BasePage

  FREELANCER_NAME = ElementLocator.new(:xpath, '//div[@class="media"]//h2')
  FREELANCER_TITLE = ElementLocator.new(:xpath, '//div[@class="overlay-container"]//h3')
  FREELANCER_DESCRIPTION = ElementLocator.new(:xpath, '//o-profile-overview[@words=80]//p')
  FREELANCER_SKILLS = ElementLocator.new(:xpath, '//div[contains(@class,"o-profile-skills")]/a')

  # Checking actual profile on page with expected
  #
  # @param profile [FreelancerProfile]: Freelancer profile
  def profile_check(profile)
    Log.message("Checking freelancer #{get_element_text(FREELANCER_NAME)} profile >>")

    # Name check
    if get_element_text(FREELANCER_NAME).include?(profile.name)
      Log.message('Name attribute check successful')
    else
      Log.warning("Name attribute check failed\nExpected: #{get_element_text(FREELANCER_NAME)}\nActual: #{profile.name}")
    end

    # Title check
    if get_element_text(FREELANCER_TITLE).include?(profile.title)
      Log.message('Title attribute check successful')
    else
      Log.warning("Title attribute check failed\nExpected: #{get_element_text(FREELANCER_TITLE)}\nActual: #{profile.title}")
    end

    # Description check
    if get_element_text(FREELANCER_DESCRIPTION).delete("\n")[0..(profile.description.length - 3)].concat(' ...').include?(profile.description)
      Log.message('Description attribute check successful')
    else
      Log.warning("Description attribute check failed\nExpected: #{get_element_text(FREELANCER_DESCRIPTION)}\nActual: #{profile.description}")
    end

    # Skills check
    if get_elements_text(FREELANCER_SKILLS).to_s.include?(profile.skills.to_s)
      Log.message('Skills attribute check successful')
    else
      Log.warning("Skills attribute check failed\nExpected: #{get_element_text(FREELANCER_SKILLS)}\nActual: #{profile.skills}")
    end
  end

  def attr_check(text)
    Log.message("Checking attributes contains <#{text}> >>")

    if get_element_text(FREELANCER_TITLE).include?(text) || get_element_text(FREELANCER_DESCRIPTION).include?(text) || get_element_text(FREELANCER_SKILLS).include?(text)

      get_element_text(FREELANCER_TITLE).include?(text) ? Log.message("Title attribute contains <#{text}>") : Log.warning("Title attribute NOT contains <#{text}>")
      get_element_text(FREELANCER_DESCRIPTION).include?(text) ? Log.message("Description attribute contains <#{text}>") : Log.warning("Description attribute NOT contains <#{text}>")
      get_element_text(FREELANCER_SKILLS).include?(text) ? Log.message("Skills attribute contains <#{text}>") : Log.warning("Skills attribute NOT contains <#{text}>")
      true
    else
      Log.warning("No one attribute contains <#{text}>")
      false
    end
  end
end