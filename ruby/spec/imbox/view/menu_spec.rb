# frozen_string_literal: true

describe Imbox::View::Menu do
  subject { described_class.new(content, window) }

  let(:content) { [1, 2, 3] }
  let(:window) { instance_spy('Curses::Window') }

  before do
    allow(window).to receive(:maxy).and_return(10)
  end

  it 'displays a menu' do
    expect(window).to receive(:clear)

    expect(window).to receive(:setpos).with(0, 0)
    expect(window).to receive(:setpos).with(1, 0)
    expect(window).to receive(:setpos).with(2, 0)

    expect(window).to receive(:standout).once

    expect(window).to receive(:addstr).with('1')
    expect(window).to receive(:addstr).with('2')
    expect(window).to receive(:addstr).with('3')

    expect(window).to receive(:standend).exactly(3).times

    subject.display
  end
end
