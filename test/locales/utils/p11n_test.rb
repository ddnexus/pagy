# frozen_string_literal: true

# Tests adapted from https://github.com/svenfuchs/rails-i18n

require_relative '../../test_helper'

describe 'locales/utils/p11n' do
  let(:p11n) { eval(Pagy.root.join('locales', 'utils', 'p11n.rb').read)[1].freeze }    #rubocop:disable Security/Eval

  describe :one_other do
    it "detects that 1 belongs to 'one'" do
      _(p11n[:one_other].call(1)).must_equal 'one'
    end
    [0, 0.3, 1.2, 2, 3, 5, 10, 11, 21, 23, 31, 50, 81, 99, 100].each do |count|
      it "detects that #{count} belongs to 'other'" do
        _(p11n[:one_other].call(count)).must_equal 'other'
      end
    end
  end

  describe :one_two_other do
    it "detects that 1 belongs to 'one'" do
      _(p11n[:one_two_other].call(1)).must_equal 'one'
    end
    it "detects that 2 belongs to 'two'" do
      _(p11n[:one_two_other].call(2)).must_equal 'two'
    end
    [0, 0.3, 1.2, 3, 5, 10, 11, 21, 23, 31, 50, 81, 99, 100].each do |count|
      it "detects that #{count} belongs to 'other'" do
        _(p11n[:one_two_other].call(count)).must_equal 'other'
      end
    end
  end

  describe :one_upto_two_other do
    [0, 0.5, 1, 1.2, 1.8].each do |count|
      it "detects that #{count} belongs to 'one'" do
        _(p11n[:one_upto_two_other].call(count)).must_equal 'one'
      end
    end
    [2, 2.1, 5, 11, 21, 22, 37, 40, 900.5].each do |count|
      it "detects that #{count} belongs to 'other'" do
        _(p11n[:one_upto_two_other].call(count)).must_equal 'other'
      end
    end
  end

  describe :other do
    [0, 1, 1.2, 2, 5, 11, 21, 22, 27, 99, 1000].each do |count|
      it "detects that #{count} belongs to 'other'" do
        _(p11n[:other].call(count)).must_equal 'other'
      end
    end
  end

  describe :east_slavic do
    [1, 21, 51, 71, 101, 1031].each do |count|
      it "detects that #{count} belongs to 'one'" do
        _(p11n[:east_slavic].call(count)).must_equal 'one'
      end
    end
    [2, 3, 4, 22, 23, 24, 92, 93, 94].each do |count|
      it "detects that #{count} belongs to 'few'" do
        _(p11n[:east_slavic].call(count)).must_equal 'few'
      end
    end
    [0, 5, 8, 10, 11, 18, 20, 25, 27, 30, 35, 38, 40].each do |count|
      it "detects that #{count} belongs to 'many'" do
        _(p11n[:east_slavic].call(count)).must_equal 'many'
      end
    end
    [1.2, 3.7, 11.5, 20.8, 1004.3].each do |count|
      it "detects that #{count} in ru is 'other'" do
        _(p11n[:east_slavic].call(count)).must_equal 'other'
      end
    end
  end

  describe :polish do
    it "detects that 1 belongs to 'one'" do
      _(p11n[:polish].call(1)).must_equal 'one'
    end
    [2, 3, 4, 22, 23, 24, 92, 93, 94].each do |count|
      it "detects that #{count} belongs to 'few'" do
        _(p11n[:polish].call(count)).must_equal 'few'
      end
    end
    [0, 5, 8, 10, 11, 18, 20, 21, 25, 27, 30, 31, 35, 38, 40, 41, 114].each do |count|
      it "detects that #{count} belongs to 'many'" do
        _(p11n[:polish].call(count)).must_equal 'many'
      end
    end
    [1.2, 3.7, 11.5, 20.8, 1004.3].each do |count|
      it "detects that #{count} belongs to 'other'" do
        _(p11n[:polish].call(count)).must_equal 'other'
      end
    end
  end
end
