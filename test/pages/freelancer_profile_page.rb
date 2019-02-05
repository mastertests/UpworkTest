require_relative '../entities/element_locator'

class FreelancerProfilePage < BasePage

  FREELANCER_NAME = ElementLocator.new(:xpath, '//div[@class="media"]//h2')
  COMPANY_NAME = ElementLocator.new(:xpath, '//div[@class="row"]//div[@class="media"]//h2')

  FREELANCER_TITLE = ElementLocator.new(:xpath, '//div[@class="overlay-container"]//h3')
  COMPANY_TITLE = ElementLocator.new(:xpath, '//div[contains(@class,"air-card")]//h3')

  FREELANCER_DESCRIPTION = ElementLocator.new(:xpath, '//o-profile-overview[@words=80]//p')
  COMPANY_DESCRIPTION = ElementLocator.new(:xpath, '//div[contains(@class,"air-card")]//div[@o-text-truncate]/span')

  FREELANCER_SKILLS = ElementLocator.new(:xpath, '//div[contains(@class,"o-profile-skills")]/a')

  # Checking actual profile on page with expected
  #
  # @param profile [FreelancerProfile]: Freelancer profile
  def profile_check(profile)
    Log.message("Checking freelancer #{profile.name} profile >>")

    # Name check
    if displayed?(FREELANCER_NAME, nil, false)
      if get_element_text(FREELANCER_NAME).include?(profile.name)
        Log.message('Name attribute check successful')
      else
        Log.warning("Name attribute check failed\nExpected: #{profile.name}\nActual: #{get_element_text(FREELANCER_NAME)}")
      end
    else
      if get_element_text(COMPANY_NAME).include?(profile.name)
        Log.message('Name attribute check successful')
      else
        Log.warning("Name attribute check failed\nExpected: #{profile.name}\nActual: #{get_element_text(COMPANY_NAME)}")
      end
    end

    # Title check
    if displayed?(FREELANCER_TITLE, nil, false)
      if get_element_text(FREELANCER_TITLE).include?(profile.title)
        Log.message('Title attribute check successful')
      else
        Log.warning("Title attribute check failed\nExpected: #{profile.title}\nActual: #{get_element_text(FREELANCER_TITLE)}")
      end
    elsif displayed?(COMPANY_TITLE, nil, false)
      if get_element_text(COMPANY_TITLE).include?(profile.title)
        Log.message('Title attribute check successful')
      else
        Log.warning("Title attribute check failed\nExpected: #{profile.title}\nActual: #{get_element_text(COMPANY_TITLE)}")
      end
    else
      if 'No description'.include?(profile.title)
        Log.message('Title attribute check successful')
      else
        Log.warning("Title attribute check failed\nExpected: No description\nActual: #{profile.title}")
      end
    end

    # Description check
    if displayed?(FREELANCER_DESCRIPTION, nil, false)
      @expected_text = profile.description.delete(' ...')
      actual_text = get_element_text(FREELANCER_DESCRIPTION).delete("\n ")[0..@expected_text.length]

      if actual_text.include?(@expected_text)
        Log.message('Description attribute check successful')
      else
        Log.warning("Description attribute check failed\nExpected: #{profile.description}\nActual: #{get_element_text(FREELANCER_DESCRIPTION)}")
      end
    else
      actual_text = get_element_text(COMPANY_DESCRIPTION).delete("\n ")

      if actual_text.include?(@expected_text)
        Log.message('Description attribute check successful')
      else
        Log.warning("Description attribute check failed\nExpected: #{profile.description}\nActual: #{get_element_text(COMPANY_DESCRIPTION)}")
      end

      # Skills check
      if get_elements_text(FREELANCER_SKILLS).to_s.include?(profile.skills.to_s)
        Log.message('Skills attribute check successful')
      else
        Log.warning("Skills attribute check failed\nExpected: #{profile.skills}\nActual: #{get_element_text(FREELANCER_SKILLS)}")
      end
    end
  end

  def attr_check(text)
    Log.message("Checking attributes contains <#{text}> >>")

    if displayed?(FREELANCER_TITLE, nil, false)
      get_element_text(FREELANCER_TITLE).include?(text) ? Log.message("Title attribute contains <#{text}>") : Log.warning("Title attribute NOT contains <#{text}>")
    else
      get_element_text(COMPANY_TITLE).include?(text) ? Log.message("Title attribute contains <#{text}>") : Log.warning("Title attribute NOT contains <#{text}>")
    end

    if displayed?(FREELANCER_DESCRIPTION, nil, false)
      get_element_text(FREELANCER_DESCRIPTION).include?(text) ? Log.message("Description attribute contains <#{text}>") : Log.warning("Description attribute NOT contains <#{text}>")
    else
      get_element_text(COMPANY_DESCRIPTION).include?(text) ? Log.message("Description attribute contains <#{text}>") : Log.warning("Description attribute NOT contains <#{text}>")
    end

    get_element_text(FREELANCER_SKILLS).include?(text) ? Log.message("Skills attribute contains <#{text}>") : Log.warning("Skills attribute NOT contains <#{text}>")
  end
end