# frozen_string_literal: true

require "spec_helper"

describe ErrorNotifier do
  describe ".notify" do
    let(:error) { StandardError.new("Foo") }
    subject { described_class.notify(error) }
    describe "with a registered block" do
      before(:each) do
        described_class.add_notifier(:kernel) do |error, _option|
          Kernel.puts(error)
        end
      end

      it "invokes the notifiers to do their job" do
        expect(Kernel).to receive(:puts).with(error)
        subject
      end
    end
    describe "with a registered class" do
      before(:each) { described_class.add_notifier(klass) }
      let(:klass) do
        Class.new do
          def self.call(_err, _options); end
        end
      end

      it "invokes the class" do
        expect(klass).to receive(:call) do |e, o|
          expect(e).to eql error
          expect(o).to eql({})
        end
        subject
      end
    end
  end

  describe ".delete_notifier" do
    before(:each) do
      described_class.add_notifier(:kernel) do |error, _option|
        # :nocov:
        Kernel.puts(error)
      end
    end
    subject { described_class.delete_notifier(:kernel) }

    it "invokes the notifiers to do their job" do
      expect { subject }.to change { described_class.instance_variable_get("@notifiers") }.from(anything).to({})
    end
  end
end
