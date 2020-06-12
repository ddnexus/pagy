# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/support'
require 'pagy/countless'

SimpleCov.command_name 'support' if ENV['RUN_SIMPLECOV']

describe Pagy::Frontend do

  let(:view) { MockView.new }

  describe "#pagy_prev_url" do

    it 'returns the prev url for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(view.pagy_prev_url(pagy)).must_be_nil
      _(view.pagy_prev_url(pagy_countless)).must_be_nil
    end

    it 'returns the prev url for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(view.pagy_prev_url(pagy)).must_equal '/foo?page=2'
      _(view.pagy_prev_url(pagy_countless)).must_equal '/foo?page=2'
    end

    it 'returns the prev url for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(view.pagy_prev_url(pagy)).must_equal '/foo?page=5'
      _(view.pagy_prev_url(pagy_countless)).must_equal '/foo?page=5'
    end

    it 'returns the prev url for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(view.pagy_prev_url(pagy)).must_equal '/foo?page=49'
      _(view.pagy_prev_url(pagy_countless)).must_equal '/foo?page=49'
    end

  end

  describe "#pagy_next_url" do

    it 'returns the next url for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(view.pagy_next_url(pagy)).must_equal '/foo?page=2'
      _(view.pagy_next_url(pagy_countless)).must_equal '/foo?page=2'
    end

    it 'returns the next url for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(view.pagy_next_url(pagy)).must_equal '/foo?page=4'
      _(view.pagy_next_url(pagy_countless)).must_equal '/foo?page=4'
    end

    it 'returns the url next for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(view.pagy_next_url(pagy)).must_equal '/foo?page=7'
      _(view.pagy_next_url(pagy_countless)).must_equal '/foo?page=7'
    end

    it 'returns the url next for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(view.pagy_next_url(pagy)).must_be_nil
      _(view.pagy_next_url(pagy_countless)).must_be_nil
    end

  end

  describe "#pagy_prev_link" do

    it 'renders the prev link for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(view.pagy_prev_link(pagy)).must_equal "<span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span>"
      _(view.pagy_prev_link(pagy_countless)).must_equal "<span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span>"
    end

    it 'renders the prev link for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(view.pagy_prev_link(pagy)).must_equal "<span class=\"page prev\"><a href=\"/foo?page=2\" rel=\"prev\" aria-label=\"previous\"  >&lsaquo;&nbsp;Prev</a></span>"
      _(view.pagy_prev_link(pagy_countless)).must_equal "<span class=\"page prev\"><a href=\"/foo?page=2\" rel=\"prev\" aria-label=\"previous\"  >&lsaquo;&nbsp;Prev</a></span>"
    end

    it 'renders the prev link for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(view.pagy_prev_link(pagy)).must_equal "<span class=\"page prev\"><a href=\"/foo?page=5\" rel=\"prev\" aria-label=\"previous\"  >&lsaquo;&nbsp;Prev</a></span>"
      _(view.pagy_prev_link(pagy_countless)).must_equal "<span class=\"page prev\"><a href=\"/foo?page=5\" rel=\"prev\" aria-label=\"previous\"  >&lsaquo;&nbsp;Prev</a></span>"
    end

    it 'renders the prev link for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(view.pagy_prev_link(pagy)).must_equal "<span class=\"page prev\"><a href=\"/foo?page=49\" rel=\"prev\" aria-label=\"previous\"  >&lsaquo;&nbsp;Prev</a></span>"
      _(view.pagy_prev_link(pagy_countless)).must_equal "<span class=\"page prev\"><a href=\"/foo?page=49\" rel=\"prev\" aria-label=\"previous\"  >&lsaquo;&nbsp;Prev</a></span>"
    end

  end

  describe "#pagy_next_link" do

    it 'renders the next link for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      _(view.pagy_next_link(pagy)).must_equal "<span class=\"page next\"><a href=\"/foo?page=2\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
      _(view.pagy_next_link(pagy_countless)).must_equal "<span class=\"page next\"><a href=\"/foo?page=2\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
    end

    it 'renders the next link for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      _(view.pagy_next_link(pagy)).must_equal "<span class=\"page next\"><a href=\"/foo?page=4\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
      _(view.pagy_next_link(pagy_countless)).must_equal "<span class=\"page next\"><a href=\"/foo?page=4\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
    end

    it 'renders the next link for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      _(view.pagy_next_link(pagy)).must_equal "<span class=\"page next\"><a href=\"/foo?page=7\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
      _(view.pagy_next_link(pagy_countless)).must_equal "<span class=\"page next\"><a href=\"/foo?page=7\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
    end

    it 'renders the next link for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      _(view.pagy_next_link(pagy)).must_equal "<span class=\"page next disabled\">Next&nbsp;&rsaquo;</span>"
      _(view.pagy_next_link(pagy_countless)).must_equal "<span class=\"page next disabled\">Next&nbsp;&rsaquo;</span>"
    end

  end

end
