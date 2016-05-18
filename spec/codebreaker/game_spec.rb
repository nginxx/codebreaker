require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    context '#start game' do
      subject { Game.new }
      before do
        subject.instance_variable_set(:@secret_code, '1234')
        allow(subject).to receive(:gets).and_return('yes')
      end

      it 'should create valid secret code' do
        expect(subject.instance_variable_get(:@secret_code).length).to eq(4)
        expect(subject.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
      context '#validation' do
        it 'should validate number' do
          expect(subject.validate('number', '111111')).to be false
          expect(subject.validate('number', '1111')).to be true
        end
        it 'should validate name' do
          expect(subject.validate('name', '1111')).to be_falsey
          expect(subject.validate('name', 'ivan')).to be_truthy
        end
      end
      it 'should compare num to code' do
        expect(subject.compare_input('1111')).to be_falsey
        expect { subject.compare_input('1234') }.to output(/Congratulations/).to_stdout
      end
      it 'should match position' do
        inputs = %w(1555 1234 1334 1146 2323 4444 1656 3111)
        result = %w(+ ++++ +++ +- -- + + --)
        inputs.each_with_index do |val, key|
          expect(subject.send(:match_position, val)).to eq(result[key])
        end
      end
      context '#hint' do
        it 'should increase hint\'s count' do
          expect { subject.make_hint }.to change { subject.instance_variable_get(:@hints) }.by(1)
        end
        it 'should make a hint' do
          expect { subject.make_hint }.to output(/[1-4]/).to_stdout
        end
        it 'should warn lack of hints' do
          subject.instance_variable_set(:@hints, 1)
          expect { subject.make_hint }.to output(/No hints/).to_stdout
        end
      end

      it 'should count attempts' do
        expect { subject.send(:check_attempts) }.to change { subject.instance_variable_get(:@attempts) }.by(1)
      end

      it 'should create statistics file' do
        subject.send(:game_over)
        expect(File.exist?('results.json')).to be true
      end
    end
  end
end