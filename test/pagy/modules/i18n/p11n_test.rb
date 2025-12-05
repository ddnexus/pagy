# frozen_string_literal: true

# Tests adapted from https://github.com/svenfuchs/rails-i18n

require 'test_helper'

describe 'p11n' do
  let(:p11n) { Pagy::I18n::P11n }

  describe :arabic do
    it "detects that 0 belongs to 'zero'" do
      _(p11n::Arabic.plural_for(0)).must_equal :zero
    end
    it "detects that 1 belongs to :one" do
      _(p11n::Arabic.plural_for(1)).must_equal :one
    end
    it "detects that 2 belongs to :two" do
      _(p11n::Arabic.plural_for(2)).must_equal :two
    end
    [3, 4, 103, 208, 210, 807].each do |count|
      it "detects that #{count} belongs to :few" do
        _(p11n::Arabic.plural_for(count)).must_equal :few
      end
    end
    [11, 112, 280, 344, 523, 699, 820, 25, 27, 936].each do |count|
      it "detects that #{count} belongs to :many" do
        _(p11n::Arabic.plural_for(count)).must_equal :many
      end
    end
    [101, 102, 801, 1.2, 3.7, 11.5, 20.8, 1004.3].each do |count|
      it "detects that #{count} belongs to :other" do
        _(p11n::Arabic.plural_for(count)).must_equal :other
      end
    end
  end

  describe :east_slavic do
    [1, 21, 51, 71, 101, 1031].each do |count|
      it "detects that #{count} belongs to :one" do
        _(p11n::EastSlavic.plural_for(count)).must_equal :one
      end
    end
    [2, 3, 4, 22, 23, 24, 92, 93, 94].each do |count|
      it "detects that #{count} belongs to :few" do
        _(p11n::EastSlavic.plural_for(count)).must_equal :few
      end
    end
    [0, 5, 8, 10, 11, 18, 20, 25, 27, 30, 35, 38, 40].each do |count|
      it "detects that #{count} belongs to :many" do
        _(p11n::EastSlavic.plural_for(count)).must_equal :many
      end
    end
    [1.2, 3.7, 11.5, 20.8, 1004.3].each do |count|
      it "detects that #{count} belongs to :other" do
        _(p11n::EastSlavic.plural_for(count)).must_equal :other
      end
    end
  end

  # default
  describe :one_other do
    it "detects that 1 belongs to :one" do
      _(p11n::OneOther.plural_for(1)).must_equal :one
    end
    [0, 0.3, 1.2, 2, 3, 5, 10, 11, 21, 23, 31, 50, 81, 99, 100].each do |count|
      it "detects that #{count} belongs to :other" do
        _(p11n::OneOther.plural_for(count)).must_equal :other
      end
    end
  end

  describe :one_upto_two_other do
    [0, 0.5, 1, 1.2, 1.8].each do |count|
      it "detects that #{count} belongs to :one" do
        _(p11n::OneUptoTwoOther.plural_for(count)).must_equal :one
      end
    end
    [2, 2.1, 5, 11, 21, 22, 37, 40, 900.5].each do |count|
      it "detects that #{count} belongs to :other" do
        _(p11n::OneUptoTwoOther.plural_for(count)).must_equal :other
      end
    end
  end

  describe :other do
    [0, 1, 1.2, 2, 5, 11, 21, 22, 27, 99, 1000].each do |count|
      it "detects that #{count} belongs to :other" do
        _(p11n::Other.plural_for(count)).must_equal :other
      end
    end
  end

  describe :polish do
    it "detects that 1 belongs to :one" do
      _(p11n::Polish.plural_for(1)).must_equal :one
    end
    [2, 3, 4, 22, 23, 24, 92, 93, 94].each do |count|
      it "detects that #{count} belongs to :few" do
        _(p11n::Polish.plural_for(count)).must_equal :few
      end
    end
    [0, 5, 8, 10, 11, 18, 20, 21, 25, 27, 30, 31, 35, 38, 40, 41, 114].each do |count|
      it "detects that #{count} belongs to :many" do
        _(p11n::Polish.plural_for(count)).must_equal :many
      end
    end
    [1.2, 3.7, 11.5, 20.8, 1004.3].each do |count|
      it "detects that #{count} belongs to :other" do
        _(p11n::Polish.plural_for(count)).must_equal :other
      end
    end
  end

  describe :west_slavic do
    it "detects that 1 belongs to :one" do
      _(p11n::WestSlavic.plural_for(1)).must_equal :one
    end
    [2, 3, 4].each do |count|
      it "detects that #{count} belongs to :few" do
        _(p11n::WestSlavic.plural_for(count)).must_equal :few
      end
    end
    [0, 5, 8, 10, 1.2, 3.7, 11.5, 20.8, 1004.3].each do |count|
      it "detects that #{count} belongs to :other" do
        _(p11n::WestSlavic.plural_for(count)).must_equal :other
      end
    end
  end
end
