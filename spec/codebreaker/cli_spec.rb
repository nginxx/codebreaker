require 'spec_helper'

module Codebreaker
  RSpec.describe Cli do
    context '#game creation' do
      it 'should create a new game' do
        expect(subject.instance_variable_get(:@game).is_a?(Game)).to be true
      end

      it 'should assign name' do
        allow(subject).to receive(:gets).and_return('igor')
        subject.send(:ask_name)
        expect(subject.instance_variable_get(:@game).name).to eq('igor')
      end

      it 'should make guess' do
        allow(subject).to receive(:gets).and_return('1212')
        expect(subject.send(:ask_number)).to eq('1212')
      end
    end
  end
end
