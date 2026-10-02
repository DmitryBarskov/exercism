class AssemblyLine
  def initialize(speed)
    @speed = speed
  end

  def production_rate_per_hour
    production_per_hour * success_rate
  end

  def working_items_per_minute
    (production_rate_per_hour / 60).to_i
  end

  private

  def production_per_hour
    @speed * 221
  end

  def success_rate
    case @speed
    when 1..4 then 1.0
    when 5..8 then 0.9
    when 9    then 0.8
    when 10   then 0.77
    end
  end
end
