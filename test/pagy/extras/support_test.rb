# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/support'
require 'pagy/countless'

SingleCov.covered! unless ENV['SKIP_SINGLECOV']

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_prev_url" do

    it 'returns the prev url for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      frontend.pagy_prev_url(pagy).must_be_nil
      frontend.pagy_prev_url(pagy_countless).must_be_nil
    end

    it 'returns the prev url for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      frontend.pagy_prev_url(pagy).must_equal '/foo?page=2'
      frontend.pagy_prev_url(pagy_countless).must_equal '/foo?page=2'
    end

    it 'returns the prev url for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      frontend.pagy_prev_url(pagy).must_equal '/foo?page=5'
      frontend.pagy_prev_url(pagy_countless).must_equal '/foo?page=5'
    end

    it 'returns the prev url for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      frontend.pagy_prev_url(pagy).must_equal '/foo?page=49'
      frontend.pagy_prev_url(pagy_countless).must_equal '/foo?page=49'
    end

  end

  describe "#pagy_next_url" do

    it 'returns the next url for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      frontend.pagy_next_url(pagy).must_equal '/foo?page=2'
      frontend.pagy_next_url(pagy_countless).must_equal '/foo?page=2'
    end

    it 'returns the next url for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      frontend.pagy_next_url(pagy).must_equal '/foo?page=4'
      frontend.pagy_next_url(pagy_countless).must_equal '/foo?page=4'
    end

    it 'returns the url next for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      frontend.pagy_next_url(pagy).must_equal '/foo?page=7'
      frontend.pagy_next_url(pagy_countless).must_equal '/foo?page=7'
    end

    it 'returns the url next for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      frontend.pagy_next_url(pagy).must_be_nil
      frontend.pagy_next_url(pagy_countless).must_be_nil
    end

  end

  describe "#pagy_prev_link" do

    it 'renders the prev link for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      frontend.pagy_prev_link(pagy).must_equal "<span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span>"
      frontend.pagy_prev_link(pagy_countless).must_equal "<span class=\"page prev disabled\">&lsaquo;&nbsp;Prev</span>"
    end

    it 'renders the prev link for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      frontend.pagy_prev_link(pagy).must_equal "<span class=\"page prev\"><a href=\"/foo?page=2\" rel=\"next\" aria-label=\"next\"  >&lsaquo;&nbsp;Prev</a></span>"
      frontend.pagy_prev_link(pagy_countless).must_equal "<span class=\"page prev\"><a href=\"/foo?page=2\" rel=\"next\" aria-label=\"next\"  >&lsaquo;&nbsp;Prev</a></span>"
    end

    it 'renders the prev link for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      frontend.pagy_prev_link(pagy).must_equal "<span class=\"page prev\"><a href=\"/foo?page=5\" rel=\"next\" aria-label=\"next\"  >&lsaquo;&nbsp;Prev</a></span>"
      frontend.pagy_prev_link(pagy_countless).must_equal "<span class=\"page prev\"><a href=\"/foo?page=5\" rel=\"next\" aria-label=\"next\"  >&lsaquo;&nbsp;Prev</a></span>"
    end

    it 'renders the prev link for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      frontend.pagy_prev_link(pagy).must_equal "<span class=\"page prev\"><a href=\"/foo?page=49\" rel=\"next\" aria-label=\"next\"  >&lsaquo;&nbsp;Prev</a></span>"
      frontend.pagy_prev_link(pagy_countless).must_equal "<span class=\"page prev\"><a href=\"/foo?page=49\" rel=\"next\" aria-label=\"next\"  >&lsaquo;&nbsp;Prev</a></span>"
    end

  end

  describe "#pagy_next_link" do

    it 'renders the next link for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      frontend.pagy_next_link(pagy).must_equal "<span class=\"page next\"><a href=\"/foo?page=2\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
      frontend.pagy_next_link(pagy_countless).must_equal "<span class=\"page next\"><a href=\"/foo?page=2\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
    end

    it 'renders the next link for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      frontend.pagy_next_link(pagy).must_equal "<span class=\"page next\"><a href=\"/foo?page=4\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
      frontend.pagy_next_link(pagy_countless).must_equal "<span class=\"page next\"><a href=\"/foo?page=4\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
    end

    it 'renders the next link for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      frontend.pagy_next_link(pagy).must_equal "<span class=\"page next\"><a href=\"/foo?page=7\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
      frontend.pagy_next_link(pagy_countless).must_equal "<span class=\"page next\"><a href=\"/foo?page=7\" rel=\"next\" aria-label=\"next\"  >Next&nbsp;&rsaquo;</a></span>"
    end

    it 'renders the next link for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      frontend.pagy_next_link(pagy).must_equal "<span class=\"page next disabled\">Next&nbsp;&rsaquo;</span>"
      frontend.pagy_next_link(pagy_countless).must_equal "<span class=\"page next disabled\">Next&nbsp;&rsaquo;</span>"
    end

  end

  describe "#pagy_serialized" do

    it 'returns the serialized object for page 1' do
      pagy = Pagy.new count: 1000, page: 1
      pagy_countless = Pagy::Countless.new(page: 1).finalize(21)
      frontend.pagy_serialized(pagy).must_equal({:count=>1000, :page=>1, :items=>20, :pages=>50, :last=>50, :offset=>0, :from=>1, :to=>20, :prev=>nil, :next=>2, :vars=>{:page=>1, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}, :count=>1000}, :series=>["1", 2, 3, 4, 5, :gap, 50], :prev_url=>nil, :next_url=>"/foo?page=2"})
      frontend.pagy_serialized(pagy_countless).must_equal({:count=>nil, :page=>1, :items=>20, :pages=>2, :last=>2, :offset=>0, :from=>1, :to=>20, :prev=>nil, :next=>2, :vars=>{:page=>1, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}}, :series=>["1", 2], :prev_url=>nil, :next_url=>"/foo?page=2"})
    end

    it 'returns the serialized object for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      frontend.pagy_serialized(pagy).must_equal({:count=>1000, :page=>3, :items=>20, :pages=>50, :last=>50, :offset=>40, :from=>41, :to=>60, :prev=>2, :next=>4, :vars=>{:page=>3, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}, :count=>1000}, :series=>[1, 2, "3", 4, 5, 6, 7, :gap, 50], :prev_url=>"/foo?page=2", :next_url=>"/foo?page=4"})
      frontend.pagy_serialized(pagy_countless).must_equal({:count=>nil, :page=>3, :items=>20, :pages=>4, :last=>4, :offset=>40, :from=>41, :to=>60, :prev=>2, :next=>4, :vars=>{:page=>3, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}}, :series=>[1, 2, "3", 4], :prev_url=>"/foo?page=2", :next_url=>"/foo?page=4"})
    end

    it 'returns the serialized object for page 6' do
      pagy = Pagy.new count: 1000, page: 6
      pagy_countless = Pagy::Countless.new(page: 6).finalize(21)
      frontend.pagy_serialized(pagy).must_equal({:count=>1000, :page=>6, :items=>20, :pages=>50, :last=>50, :offset=>100, :from=>101, :to=>120, :prev=>5, :next=>7, :vars=>{:page=>6, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}, :count=>1000}, :series=>[1, 2, 3, 4, 5, "6", 7, 8, 9, 10, :gap, 50], :prev_url=>"/foo?page=5", :next_url=>"/foo?page=7"})
      frontend.pagy_serialized(pagy_countless).must_equal({:count=>nil, :page=>6, :items=>20, :pages=>7, :last=>7, :offset=>100, :from=>101, :to=>120, :prev=>5, :next=>7, :vars=>{:page=>6, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}}, :series=>[1, 2, 3, 4, 5, "6", 7], :prev_url=>"/foo?page=5", :next_url=>"/foo?page=7"})
    end

    it 'returns the serialized object for last page' do
      pagy = Pagy.new count: 1000, page: 50
      pagy_countless = Pagy::Countless.new(page: 50).finalize(20)
      frontend.pagy_serialized(pagy).must_equal({:count=>1000, :page=>50, :items=>20, :pages=>50, :last=>50, :offset=>980, :from=>981, :to=>1000, :prev=>49, :next=>nil, :vars=>{:page=>50, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}, :count=>1000}, :series=>[1, :gap, 46, 47, 48, 49, "50"], :prev_url=>"/foo?page=49", :next_url=>nil})
      frontend.pagy_serialized(pagy_countless).must_equal({:count=>nil, :page=>50, :items=>20, :pages=>50, :last=>50, :offset=>980, :from=>981, :to=>1000, :prev=>49, :next=>nil, :vars=>{:page=>50, :items=>20, :outset=>0, :size=>[1, 4, 4, 1], :page_param=>:page, :params=>{}, :anchor=>"", :link_extra=>"", :item_path=>"pagy.info.item_name", :cycle=>false, :breakpoints=>{0=>[1, 4, 4, 1]}}, :series=>[1, :gap, 46, 47, 48, 49, "50"], :prev_url=>"/foo?page=49", :next_url=>nil})
    end

  end

  describe "#pagy_apply_init_tag" do

    it 'renders the default apply-init tag for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      frontend.pagy_apply_init_tag(pagy, :testFunction).must_equal "<script type=\"application/json\" class=\"pagy-json\">[\"applyInit\",\"testFunction\",{\"count\":1000,\"page\":3,\"items\":20,\"pages\":50,\"last\":50,\"offset\":40,\"from\":41,\"to\":60,\"prev\":2,\"next\":4,\"vars\":{\"page\":3,\"items\":20,\"outset\":0,\"size\":[1,4,4,1],\"page_param\":\"page\",\"params\":{},\"anchor\":\"\",\"link_extra\":\"\",\"item_path\":\"pagy.info.item_name\",\"cycle\":false,\"breakpoints\":{\"0\":[1,4,4,1]},\"count\":1000},\"series\":[1,2,\"3\",4,5,6,7,\"gap\",50],\"prev_url\":\"/foo?page=2\",\"next_url\":\"/foo?page=4\"}]</script>"
      frontend.pagy_apply_init_tag(pagy_countless, :testFunction).must_equal "<script type=\"application/json\" class=\"pagy-json\">[\"applyInit\",\"testFunction\",{\"count\":null,\"page\":3,\"items\":20,\"pages\":4,\"last\":4,\"offset\":40,\"from\":41,\"to\":60,\"prev\":2,\"next\":4,\"vars\":{\"page\":3,\"items\":20,\"outset\":0,\"size\":[1,4,4,1],\"page_param\":\"page\",\"params\":{},\"anchor\":\"\",\"link_extra\":\"\",\"item_path\":\"pagy.info.item_name\",\"cycle\":false,\"breakpoints\":{\"0\":[1,4,4,1]}},\"series\":[1,2,\"3\",4],\"prev_url\":\"/foo?page=2\",\"next_url\":\"/foo?page=4\"}]</script>"
    end

    it 'renders the apply-init tag for page 3' do
      pagy = Pagy.new count: 1000, page: 3
      pagy_countless = Pagy::Countless.new(page: 3).finalize(21)
      frontend.pagy_apply_init_tag(pagy, :testFunction, {a: 1}).must_equal "<script type=\"application/json\" class=\"pagy-json\">[\"applyInit\",\"testFunction\",{\"a\":1}]</script>"
      frontend.pagy_apply_init_tag(pagy_countless, :testFunction, {a: 1}).must_equal "<script type=\"application/json\" class=\"pagy-json\">[\"applyInit\",\"testFunction\",{\"a\":1}]</script>"
    end

  end

end

