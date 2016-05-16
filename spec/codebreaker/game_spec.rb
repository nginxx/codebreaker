require 'spec_helper'

module Codebreaker
  RSpec.describe Game do
    context '#start' do
      let(:game) { Game.new }
      before do
        game.instance_variable_set(:@secret_code, '1234')
        allow(game).to receive(:gets).and_return('yes')
      end

      it 'should create valid secret code' do
        expect(game.instance_variable_get(:@secret_code).length).to eq(4)
        expect(game.instance_variable_get(:@secret_code)).to match(/[1-6]+/)
      end
      it 'should validate inputs' do
        expect(game.validate('number', '111111')).to be_falsey
        expect(game.validate('number', '1111')).to be_truthy
        expect(game.validate('name', '11111')).to be_falsey
        expect(game.validate('name', 'ivan')).to be_truthy
      end
      it 'should compare num to code' do
        expect(game.compare_input('1111')).to be_falsey
        expect { game.compare_input('1234') }.to output(/Congratulations/).to_stdout
      end
      it 'should match position' do
        expect(game.send(:match_position, '1555')).to eq('+')
        expect(game.send(:match_position, '1234')).to eq('++++')
        expect(game.send(:match_position, '1334')).to eq('+++')
        expect(game.send(:match_position, '1146')).to eq('+-')
      end

      it 'should make hint' do
        hints = game.instance_variable_get(:@hints)
        expect { game.send(:make_hint) }.to change { hints.size }.by(1)
        expect { game.send(:make_hint) }.to output(/[1-4]/).to_stdout
      end

      it 'should count attempts' do
        attempts = game.instance_variable_get(:@attempts)
        expect { game.send(:check_attempts) }.to change { attempts.size }.by(1)
      end

      it 'should create statistics file' do
        game.send(:game_over)
        expect(File.exist?('results.json')).to be true
      end
    end
  end
end