# encoding: utf-8
# frozen_string_literal: true

require_relative '../../test_helper'
require 'pagy/extras/uikit'

describe Pagy::Frontend do

  let(:view) { MockView.new }
  let(:pagy_test_id) { 'test-id' }

  describe "#pagy_uikit_nav" do

    it 'renders first page' do
      pagy = Pagy.new(count: 1000, page: 1)
      view.pagy_uikit_nav(pagy).must_equal \
        "<ul class=\"uk-pagination uk-flex-center\"><li class=\"uk-disabled\"><a href=\"#\"><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li class=\"uk-active\"><span>1</span></li><li><a href=\"/foo?page=2\"   rel=\"next\" >2</a></li><li><a href=\"/foo?page=3\"   >3</a></li><li><a href=\"/foo?page=4\"   >4</a></li><li><a href=\"/foo?page=5\"   >5</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=50\"   >50</a></li><li><a href=\"/foo?page=2\"   rel=\"next\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
    end

    it 'renders intermediate page' do
      pagy = Pagy.new(count: 1000, page: 20)
      view.pagy_uikit_nav(pagy).must_equal \
        "<ul class=\"uk-pagination uk-flex-center\"><li><a href=\"/foo?page=19\"   rel=\"prev\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li><a href=\"/foo?page=1\"   >1</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=16\"   >16</a></li><li><a href=\"/foo?page=17\"   >17</a></li><li><a href=\"/foo?page=18\"   >18</a></li><li><a href=\"/foo?page=19\"   rel=\"prev\" >19</a></li><li class=\"uk-active\"><span>20</span></li><li><a href=\"/foo?page=21\"   rel=\"next\" >21</a></li><li><a href=\"/foo?page=22\"   >22</a></li><li><a href=\"/foo?page=23\"   >23</a></li><li><a href=\"/foo?page=24\"   >24</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=50\"   >50</a></li><li><a href=\"/foo?page=21\"   rel=\"next\" ><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
    end

    it 'renders last page' do
      pagy = Pagy.new(count: 1000, page: 50)
      view.pagy_uikit_nav(pagy).must_equal \
        "<ul class=\"uk-pagination uk-flex-center\"><li><a href=\"/foo?page=49\"   rel=\"prev\" ><span uk-pagination-previous>&lsaquo;&nbsp;Prev</span></a></li><li><a href=\"/foo?page=1\"   >1</a></li><li class=\"uk-disabled\"><span>&hellip;</span></li><li><a href=\"/foo?page=46\"   >46</a></li><li><a href=\"/foo?page=47\"   >47</a></li><li><a href=\"/foo?page=48\"   >48</a></li><li><a href=\"/foo?page=49\"   rel=\"prev\" >49</a></li><li class=\"uk-active\"><span>50</span></li><li class=\"uk-disabled\"><a href=\"#\"><span uk-pagination-next>Next&nbsp;&rsaquo;</span></a></li></ul>"
    end

  end

end
