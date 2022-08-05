# frozen_string_literal: true

require 'spec_helper'

describe Imbox::App do
  describe '.call' do
    subject { described_class.call(mbox_path) }

    let(:mbox_path) { 'path/to/file.mbox' }
    let(:display_instance) { instance_double('Display') }

    before do
      allow(Mbox).to receive(:open)
      allow(Imbox::Display).to receive(:new) { display_instance }
      allow(display_instance).to receive(:await_input) { 'q' }
    end

    it 'runs through the loop and breaks on q' do
      expect(Mbox).to receive(:open).with(mbox_path)
      expect(display_instance).to receive(:close)
      subject
    end
  end
end
