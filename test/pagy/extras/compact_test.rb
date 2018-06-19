require_relative '../../test_helper'
require 'pagy/extras/compact'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_nav_compact" do
    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    def test_pagy_nav_compact_page_1
      pagy, _  = @array.pagy(1)
      html, id = frontend.pagy_nav_compact(pagy), caller(0,1)[0].hash

      assert_equal(
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact pagination" role="navigation" aria-label="pager">) +
        %(<a href="/foo?page=#{Pagy::Frontend::MARKER}"   style="display: none;" ></a>) +
        %(<span class="page prev disabled">&lsaquo;&nbsp;Prev</span> ) +
        %(<span class="pagy-compact-input" style="margin: 0 0.6rem;">Page <input type="number" min="1" max="6" value="1" style="padding: 0; text-align: center; width: 2rem;"> of 6</span> ) +
        %(<span class="page next"><a href="/foo?page=2"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>) +
      %(</nav>) +
      %(<script>PagyCompact('#{id}', '#{Pagy::Frontend::MARKER}', '1');</script>),
      html
      )
    end

    def test_pagy_nav_compact_page_3
      pagy, _  = @array.pagy(3)
      html, id = frontend.pagy_nav_compact(pagy), caller(0,1)[0].hash

      assert_equal(
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact pagination" role="navigation" aria-label="pager">) +
        %(<a href="/foo?page=#{Pagy::Frontend::MARKER}"   style="display: none;" ></a>) +
        %(<span class="page prev"><a href="/foo?page=2"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ) +
        %(<span class="pagy-compact-input" style="margin: 0 0.6rem;">Page <input type="number" min="1" max="6" value="3" style="padding: 0; text-align: center; width: 2rem;"> of 6</span> ) +
        %(<span class="page next"><a href="/foo?page=4"   rel="next" aria-label="next">Next&nbsp;&rsaquo;</a></span>) +
      %(</nav>) +
      %(<script>PagyCompact('#{id}', '#{Pagy::Frontend::MARKER}', '3');</script>),
      html
      )
    end

    def test_pagy_nav_compact_page_6
      pagy, _  = @array.pagy(6)
      html, id = frontend.pagy_nav_compact(pagy), caller(0,1)[0].hash

      assert_equal(
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-compact pagination" role="navigation" aria-label="pager">) +
        %(<a href="/foo?page=#{Pagy::Frontend::MARKER}"   style="display: none;" ></a>) +
        %(<span class="page prev"><a href="/foo?page=5"   rel="prev" aria-label="previous">&lsaquo;&nbsp;Prev</a></span> ) +
        %(<span class="pagy-compact-input" style="margin: 0 0.6rem;">Page <input type="number" min="1" max="6" value="6" style="padding: 0; text-align: center; width: 2rem;"> of 6</span> ) +
        %(<span class="page next disabled">Next&nbsp;&rsaquo;</span>) +
      %(</nav>) +
      %(<script>PagyCompact('#{id}', '#{Pagy::Frontend::MARKER}', '6');</script>),
      html
      )
    end

  end

  describe "#pagy_nav_bootstrap_compact" do
    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    def test_pagy_nav_bootstrap_compact_page_1
      pagy, _  = @array.pagy(1)
      html, id = frontend.pagy_nav_bootstrap_compact(pagy), caller(0,1)[0].hash

      assert_equal(
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-bootstrap-compact pagination" role="navigation" aria-label="pager">) +
        %(<a href="/foo?page=#{Pagy::Frontend::MARKER}"   style="display: none;" ></a>) +
        %(<div class="btn-group" role="group">) +
          %(<a class="prev btn btn-primary disabled" href="#">&lsaquo;&nbsp;Prev</a>) +
          %(<div class="pagy-compact-input btn btn-primary disabled">) +
            %(Page ) +
            %(<input type="number" min="1" max="6" value="1" style="padding: 0; border: none; text-align: center; width: 2rem;">) +
            %( of 6) +
          %(</div>) +
          %(<a href="/foo?page=2"   rel="next" aria-label="next" class="next btn btn-primary">Next&nbsp;&rsaquo;</a>) +
        %(</div>) +
      %(</nav>) +
      %(<script>PagyCompact('#{id}', '#{Pagy::Frontend::MARKER}', '1');</script>),
      html
      )
    end

    def test_pagy_nav_bootstrap_compact_page_3
      pagy, _  = @array.pagy(3)
      html, id = frontend.pagy_nav_bootstrap_compact(pagy), caller(0,1)[0].hash

      assert_equal(
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-bootstrap-compact pagination" role="navigation" aria-label="pager">) +
        %(<a href="/foo?page=#{Pagy::Frontend::MARKER}"   style="display: none;" ></a>) +
        %(<div class="btn-group" role="group">) +
          %(<a href="/foo?page=2"   rel="prev" aria-label="previous" class="prev btn btn-primary">&lsaquo;&nbsp;Prev</a>) +
          %(<div class="pagy-compact-input btn btn-primary disabled">) +
            %(Page ) +
            %(<input type="number" min="1" max="6" value="3" style="padding: 0; border: none; text-align: center; width: 2rem;">) +
            %( of 6) +
          %(</div>) +
          %(<a href="/foo?page=4"   rel="next" aria-label="next" class="next btn btn-primary">Next&nbsp;&rsaquo;</a>) +
        %(</div>) +
      %(</nav>) +
      %(<script>PagyCompact('#{id}', '#{Pagy::Frontend::MARKER}', '3');</script>),
      html
      )
    end

    def test_pagy_nav_bootstrap_compact_page_6
      pagy, _  = @array.pagy(6)
      html, id = frontend.pagy_nav_bootstrap_compact(pagy), caller(0,1)[0].hash

      assert_equal(
      %(<nav id="pagy-nav-#{id}" class="pagy-nav-bootstrap-compact pagination" role="navigation" aria-label="pager">) +
        %(<a href="/foo?page=#{Pagy::Frontend::MARKER}"   style="display: none;" ></a>) +
        %(<div class="btn-group" role="group">) +
          %(<a href="/foo?page=5"   rel="prev" aria-label="previous" class="prev btn btn-primary">&lsaquo;&nbsp;Prev</a>) +
          %(<div class="pagy-compact-input btn btn-primary disabled">) +
            %(Page ) +
            %(<input type="number" min="1" max="6" value="6" style="padding: 0; border: none; text-align: center; width: 2rem;">) +
            %( of 6) +
          %(</div>) +
          %(<a class="next btn btn-primary disabled" href="#">Next&nbsp;&rsaquo;</a>) +
        %(</div>) +
      %(</nav>) +
      %(<script>PagyCompact('#{id}', '#{Pagy::Frontend::MARKER}', '6');</script>),
      html
      )
    end

  end
end
