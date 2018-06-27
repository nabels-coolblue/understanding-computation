class DTM < Struct.new(:configuration, :accept_states, :rulebook)
  def current_configuration
    configuration
  end

  def accepting?
    accept_states.include?(configuration.state)
  end

  def step
    self.configuration = rulebook.next_configuration(configuration)
  end

  def run
    while !accepting? && !stuck?
      step
    end
  end

  def stuck?
    !accepting? && !rulebook.rule_for?(configuration)
  end
end
