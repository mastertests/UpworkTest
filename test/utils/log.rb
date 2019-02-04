class Log
  @logger = Logger.new(STDOUT)
  @logger.level = Logger::INFO

  # Variable for step counting
  @last_step_number = 1

  # Use for test-case step message
  def self.step(message)
    @logger.unknown(" [#{@last_step_number}] #{message}:")
    @last_step_number += 1
  end

  # Use for regular message
  def self.message(message)
    @logger.info(message)
  end

  # Use for warning message
  def self.warning(message)
    @logger.warn(message)
  end

  # Use for unhandleable and fatal errors
  def self.error(message, is_fatal = false)
    if is_fatal
      @logger.fatal(message)
    else
      @logger.error(message)
    end
  end
end