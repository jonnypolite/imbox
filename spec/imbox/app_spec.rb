# frozen_string_literal: true

describe Imbox::App do
  describe '.call' do
    subject { described_class.call(mbox_path) }

    let(:mbox_path) { 'path/to/file.mbox' }
    let(:display_instance) { instance_double('Imbox::View::Display') }
    let(:mail_instance) { instance_double('Imbox::Mail') }
    let(:summary) { 'foommary' }

    before do
      allow(Imbox::View::Display).to receive(:new) { display_instance }
      allow(display_instance).to receive(:await_input) { 'q' }

      allow(Imbox::Mail).to receive(:new) { mail_instance }
      allow(mail_instance).to receive(:summary_list) { summary }
    end

    it 'runs through the loop and breaks on q' do
      expect(mail_instance).to receive(:summary_list)
      expect(display_instance).to receive(:show_content).with(summary, menu: true)
      expect(display_instance).to receive(:await_input)
      expect(display_instance).to receive(:close)
      expect(display_instance).not_to receive(:refresh)
      subject
    end
  end
end
