class Oystercard
  attr_reader :balance, :entry_station
  
  MINIMUM_FOR_ONE_JOURNEY = 1
  MAXIMUM_BALANCE = 90

  def initialize
    @balance = 0
    @entry_station = nil
    @journeys = []
  end

  def top_up(amount)
    raise "Limit is #{MAXIMUM_BALANCE}" if @balance + amount > MAXIMUM_BALANCE

    @balance += amount
  end

  def touch_in(entry_station)
    raise "Minimum balance of #{MINIMUM_FOR_ONE_JOURNEY} required" if
      @balance < MINIMUM_FOR_ONE_JOURNEY

    @journeys << { entry: entry_station }
  end

  def touch_out(exit_station, cost)
    raise "Not in journey" unless in_journey?

    @journeys[-1][:exit] = exit_station
    deduct(cost)
  end

  def in_journey?
    @journeys != [] && @journeys[-1][:exit].nil?
  end

  def journeys
    @journeys
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end
