require 'oystercard'

describe Oystercard do
  let(:entry_station) { :limehouse }
  let(:exit_station) { :bank }
  let(:journey_cost) { 3 }

  it 'has an empty list of journeys by default' do
    expect(subject.journeys).to eq []
  end

  it 'has zero balance by default' do
    expect(subject.balance).to eq 0
  end

  describe '#balance' do
    it 'checks money on card' do
      subject.top_up(42)
      expect(subject.balance).to eq 42
    end
  end
  
  describe '#top_up' do
    it 'lets me add money' do
      subject.top_up(10)
      expect(subject.balance).to eq 10
    end

    it 'raises an error if balance raised to more then maximum' do
      maximum_balance = described_class::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect { subject.top_up(1) }.to raise_error "Limit is #{maximum_balance}"
    end
  end

  describe "#touch_in" do
    it 'allows me to touch in' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject).to be_in_journey
    end

    it 'raises an error if i touch in with balance less than the minimum' do
      minimum_balance = described_class::MINIMUM_FOR_ONE_JOURNEY
      subject.top_up(minimum_balance - 1)
      expect { subject.touch_in(entry_station) }.to raise_error "Minimum balance of #{minimum_balance} required"
    end

    it 'logs the entry station' do
      subject.top_up(10)
      subject.touch_in(entry_station)
      expect(subject.journeys[-1][:entry]).to eq entry_station
    end

    it 'raises an error if no entry station given' do
      subject.top_up(10)
      expect { subject.touch_in }.to raise_error ArgumentError
    end
  end

  describe '#touch_out' do
    before :each do
      subject.top_up 10
    end
    
    it 'allows me to touch out' do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station, journey_cost)
      expect(subject).not_to be_in_journey
    end

    it 'deducts the correct amount' do
      cost_of_journey = 1
      subject.touch_in(entry_station)
      expect { subject.touch_out(exit_station, cost_of_journey) }.to change { subject.balance }.by(-cost_of_journey)
    end

    it "logs the exit station" do
      subject.touch_in(entry_station)
      subject.touch_out(exit_station, journey_cost)
      expect(subject.journeys[-1][:exit]).to eq exit_station
    end

    it "raises an error if i'm not in a journey" do
      expect { subject.touch_out(exit_station, journey_cost) }.to raise_error "Not in journey"
    end
  end

  # not sure about this bit... was in response to section 12's:
  #    "Write a test that checks that touching in and out creates one journey"
  describe "touching in and touching out a bunch of times" do
    before :each do
      5.times do
        subject.top_up(journey_cost)
        subject.touch_in(entry_station)
        subject.touch_out(exit_station, journey_cost)
      end
    end

    it 'makes a bunch of journeys' do
      expect(subject.journeys.count).to eq 5
    end
  end
end
