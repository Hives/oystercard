require 'oystercard'

describe Oystercard do
  it 'checks money on card' do
    expect(subject.balance).to eq 0
  end
  it 'lets me add money' do
    subject.top_up(10)
    expect(subject.balance).to eq 10
  end
  it 'raises an error if balance raised to more then 90' do
    subject.top_up(90)
    expect { subject.top_up(1) }.to raise_error 'Limit is 90'
  end
  it 'deducts money' do
    subject.deduct(10)
    expect(subject.balance).to eq -10
  end
  it 'allows me to touch in' do
    subject.touch_in
    expect(subject).to be_in_journey
  end
  it 'allows me to touch out' do
    subject.touch_in
    subject.touch_out
    expect(subject).not_to be_in_journey
  end
end
