require 'spec_helper'

describe ErrorNotifier do
  describe 'with a registered block' do
    before(:each) do
      described_class.add_notifier(:kernel) do |error, option|
        Kernel.puts(error)
      end
    end

    describe '.notify' do
      let(:error) { StandardError.new('Foo') }
      subject { described_class.notify(error) }

      it 'invokes the notifiers to do their job' do
        expect(Kernel).to receive(:puts).with(error)
        subject
      end
    end

    describe '.delete_notifier' do
      subject { described_class.delete_notifier(:kernel) }

      it 'invokes the notifiers to do their job' do
        expect { subject }.to change { described_class.instance_variable_get('@notifiers')}.from(anything).to({})
      end
    end
  end
end
