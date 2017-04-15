# frozen_string_literal: true

require "spec_helper"

describe ErrorNotifier do
  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  describe ".add_notifier" do
    subject { described_class.add_notifier(:foo) { |_x| true } }

    it "adds to the list of notifiers" do
      expect { subject }.to change { described_class.instance_variable_get("@notifiers") }.to include(foo: anything)
    end

    describe "passing an object to the notifier" do
      context "when the object does not implement call" do
        subject { described_class.add_notifier(object) }
        let(:object) { double("An Object") }
        it "raises an error" do
          expect { subject }.to raise_error StandardError
        end
      end

      context "when the object does implement call" do
        subject { described_class.add_notifier(object) }
        let(:object) { double("An Object", call: true) }

        context "when the arity is wrong" do
          before :each do
            allow(object).to receive(:method).with(:call).and_return(double(arity: 1))
          end
          it "raises an error" do
            expect { subject }.to raise_error StandardError
          end
        end

        context "when the arity is correct" do
          before :each do
            allow(object).to receive(:method).with(:call).and_return(double(arity: 2))
          end

          it "does not raise an error" do
            expect { subject }.not_to raise_error
          end

          it "adds the object to the list of observers" do
            expect { subject }.to change { described_class.instance_variable_get("@notifiers") }.to include(object.class.to_s => object)
          end
        end
      end
    end
  end

  describe ".delete_notifier" do
    before(:each) do
      described_class.instance_variable_set("@notifiers", foo: :foo)
    end

    subject { described_class.delete_notifier(:foo) }

    it "removes the notifier" do
      expect { subject }.to change { described_class.instance_variable_get("@notifiers") }.from(foo: :foo).to({})
    end
  end

  describe ".notify" do
    let(:error) { StandardError.new("A Message") }
    subject { described_class.notify(error) }

    it "returns nil" do
      expect(subject).to be_nil
    end

    context "given registered notifiers" do
      let(:block) { double("A Block") }
      before(:each) do
        described_class.instance_variable_set("@notifiers", foo: block)
      end

      context "when just the error is given" do
        it "call the block with the error message and an empty hash" do
          expect(block).to receive(:call) do |arg, option|
            expect(arg).to eql error
            expect(option).to eql({})
          end
          subject
        end
      end

      context "when the error is given with a hash" do
        let(:hash) { double("Hash") }
        subject { described_class.notify(error, hash) }
        it "call the block with the error message and the hash" do
          expect(block).to receive(:call) do |arg, option|
            expect(arg).to eql error
            expect(option).to eql(hash)
          end
          subject
        end
      end
    end

    context "without registered notifiers" do
      let(:block) { double("A Block") }
      before(:each) do
        described_class.instance_variable_set("@notifiers", {})
      end

      it "never calls the block" do
        expect(block).to receive(:call).never
        subject
      end
    end
  end
end
