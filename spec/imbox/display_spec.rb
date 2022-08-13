# frozen_string_literal: true

require 'spec_helper'

describe Imbox::Display do
  subject { described_class.new(config) }
  let(:config) { {} }
  let(:window) { instance_double('Window') }
  let(:subwindow) { instance_double('Window') }
  let(:maxx) { 5 }

  before do
    allow(Curses).to receive(:init_screen)
    allow(Curses).to receive(:curs_set)
    allow(Curses).to receive(:noecho)
    allow(Curses).to receive(:close_screen)

    allow(Curses::Window).to receive(:new) { window }
    allow(window).to receive(:resize)
    allow(window).to receive(:clear)
    allow(window).to receive(:box)
    allow(window).to receive(:subwin).and_return(subwindow)
    allow(window).to receive(:setpos)
    allow(window).to receive(:addstr)
    allow(window).to receive(:maxx).and_return(maxx)
    allow(window).to receive(:maxy).and_return(5)
    allow(window).to receive(:refresh)

    allow(subwindow).to receive(:setpos)
    allow(subwindow).to receive(:maxy).and_return(5)
    allow(subwindow).to receive(:maxx).and_return(5)
    allow(subwindow).to receive(:addstr)
  end

  describe '.await_input' do
    it 'gets input from Curses' do
      expect(window).to receive(:getch)
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
    it 'sets up the window' do
      expect(window).to receive(:resize).with(0, 0)
      expect(window).to receive(:clear)
      expect(window).to receive(:box)
      expect(window).to receive(:subwin).with(5, maxx - 2, 1, 1)
      expect(window).to receive(:setpos).twice.with(2, 2)

      subject.redraw
    end

    context 'when there is no config' do
      it "doesn't draw the title" do
        expect(window).not_to receive(:setpos).with(0, 5)
        subject.redraw
      end
    end

    context 'when there is a config' do
      let(:title_text) { 'yeah buddy' }
      let(:config) { { title: title_text } }

      it 'does draw the title' do
        expect(window).to receive(:setpos).with(0, 5)
        expect(window).to receive(:addstr).with("[ #{title_text} ]")
        subject.redraw
      end
    end
  end
end
