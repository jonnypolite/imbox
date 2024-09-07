# frozen_string_literal: true

shared_examples 'a call to redraw with no title' do
  it 'sets up the window' do
    header_height = Imbox::View::Display::HEADER_HEIGHT

    # reset_main_window
    expect(main_window).to receive(:resize).with(0, 0)
    expect(main_window).to receive(:clear)
    expect(main_window).to receive(:box)

    # no draw_title
    expect(main_window).not_to receive(:setpos).with(0, 5)

    # draw_header
    expect(main_window).to receive(:subwin).with(header_height, maxx - 2, 1, 1)
    expect(subwindow).to receive(:clear)
    expect(subwindow).to receive(:resize).once.with(header_height, maxx - 2)
    expect(subwindow).to receive(:setpos).with(0, 0)
    expect(subwindow).to receive(:addstr).with('Header placeholder text.')

    # draw_content_window
    expect(main_window).to receive(:subwin).with(maxy - header_height - 2, maxx - 2, header_height + 1, 1)
    expect(subwindow).to receive(:resize).once.with(maxy - header_height - 2, maxx - 2)

    subject.redraw
  end
end

shared_examples 'a call to redraw with title' do
  it 'sets up the window' do
    header_height = Imbox::View::Display::HEADER_HEIGHT

    # reset_main_window
    expect(main_window).to receive(:resize).with(0, 0)
    expect(main_window).to receive(:clear)
    expect(main_window).to receive(:box)

    # draw_title
    expect(main_window).to receive(:setpos).with(0, 5)
    expect(main_window).to receive(:addstr).with("[ #{title_text} ]")

    # draw_header
    expect(main_window).to receive(:subwin).with(header_height, maxx - 2, 1, 1)
    expect(subwindow).to receive(:clear)
    expect(subwindow).to receive(:resize).once.with(header_height, maxx - 2)
    expect(subwindow).to receive(:setpos).with(0, 0)
    expect(subwindow).to receive(:addstr).with('Header placeholder text.')

    # draw_content_window
    expect(main_window).to receive(:subwin).with(maxy - header_height - 2, maxx - 2, header_height + 1, 1)
    expect(subwindow).to receive(:resize).once.with(maxy - header_height - 2, maxx - 2)

    subject.redraw
  end
end

describe Imbox::View::Display do
  subject { described_class.new(config) }

  let(:config) { {} }
  let(:main_window) { instance_double('Curses::Window') }
  let(:subwindow) { instance_double('Curses::Window') }
  let(:mail_menu) { instance_double('Imbox::View::Menu') }
  let(:maxx) { 20 }
  let(:maxy) { 20 }

  before do
    allow(Curses).to receive(:init_screen)
    allow(Curses).to receive(:curs_set)
    allow(Curses).to receive(:noecho)
    allow(Curses).to receive(:close_screen)

    allow(Curses::Window).to receive(:new) { main_window }
    allow(main_window).to receive(:resize)
    allow(main_window).to receive(:clear)
    allow(main_window).to receive(:box)
    allow(main_window).to receive(:subwin).and_return(subwindow)
    allow(main_window).to receive(:setpos)
    allow(main_window).to receive(:addstr)
    allow(main_window).to receive(:maxx).and_return(maxx)
    allow(main_window).to receive(:maxy).and_return(maxy)
    allow(main_window).to receive(:refresh)

    allow(subwindow).to receive(:setpos)
    allow(subwindow).to receive(:maxy).and_return(5)
    allow(subwindow).to receive(:maxx).and_return(5)
    allow(subwindow).to receive(:addstr)

    allow(Imbox::View::Menu).to receive(:new) { mail_menu }
  end

  describe '.await_input' do
    it 'gets input from Curses' do
      expect(main_window).to receive(:getch)
      subject.await_input
    end
  end

  describe '.close' do
    context 'it is not already closed' do
      before do
        allow(Curses).to receive(:closed?).and_return(false)
      end

      it 'closes the window' do
        expect(Curses).to receive(:close_screen)
        subject.close
      end
    end

    context 'it is already closed' do
      before do
        allow(Curses).to receive(:closed?).and_return(true)
      end

      it 'does not close the window' do
        expect(Curses).not_to receive(:close_screen)
        subject.close
      end
    end
  end

  describe '.redraw' do
    context 'when there is no config' do
      it_behaves_like 'a call to redraw with no title'
    end

    context 'when there is a config' do
      let(:title_text) { 'yeah buddy' }
      let(:config) { { title: title_text } }

      it_behaves_like 'a call to redraw with title'
    end
  end

  describe '.refresh' do
    it 'refreshes windows' do
      expect(subwindow).to receive(:refresh)
      expect(main_window).to receive(:refresh)

      subject.refresh
    end
  end

  describe '.show_menu_content' do
    let(:content) { 'blah blah blah' }

    it 'adds menu content' do
      expect(Imbox::View::Menu).to receive(:new).with(content, subwindow)
      expect(mail_menu).to receive(:display)
      expect(subwindow).to receive(:refresh)

      subject.show_menu_content(content)
    end
  end

  # describe '.show_content' do
  #   let(:content) { 'blah blah blah' }

  #   context 'when no menu is desired' do
  #     let(:menu) { false }

  #     it 'adds basic content' do
  #       expect(subwindow).to receive(:setpos).with(0, 0)
  #       expect(subwindow).to receive(:addstr).with(content)
  #       expect(subwindow).to receive(:setpos).with(1, 0)
  #       expect(subwindow).to receive(:refresh)

  #       subject.show_content(content, menu:)
  #     end
  #   end
  # end

  describe '.menu_up' do
    before do
      expect(subwindow).to receive(:refresh)
      subject.show_menu_content('whatever')
    end

    it 'tells mail_menu to move up' do
      expect(mail_menu).to receive(:move_up)

      subject.menu_up
    end
  end

  describe '.menu_down' do
    before do
      expect(subwindow).to receive(:refresh)
      subject.show_menu_content('whatever')
    end

    it 'tells mail_menu to move down' do
      expect(mail_menu).to receive(:move_down)

      subject.menu_down
    end
  end
end
