require_relative '../../test_helper'
require 'pagy/extras/responsive'

SingleCov.covered!

describe Pagy::Frontend do

  let(:frontend) { TestView.new }

  describe "#pagy_nav_responsive" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1' do
      pagy, _  = @array.pagy(1)
      html, id = frontend.pagy_nav_responsive(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<span class=\\\"page prev disabled\\\">&lsaquo;&nbsp;Prev</span> \",\"1\":\"<span class=\\\"page active\\\">1</span> \",\"2\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" >2</a></span> \",\"3\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=3\\\"   >3</a></span> \",\"4\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=4\\\"   >4</a></span> \",\"5\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=5\\\"   >5</a></span> \",\"6\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=6\\\"   >6</a></span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},  [0], {\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3' do
      pagy, _  = @array.pagy(3)
      html, id = frontend.pagy_nav_responsive(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"1\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=1\\\"   >1</a></span> \",\"2\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" >2</a></span> \",\"3\":\"<span class=\\\"page active\\\">3</span> \",\"4\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" >4</a></span> \",\"5\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=5\\\"   >5</a></span> \",\"6\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=6\\\"   >6</a></span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},  [0], {\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6' do
      pagy, _ = @array.pagy(6)
      html, id = frontend.pagy_nav_responsive(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"1\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=1\\\"   >1</a></span> \",\"2\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=2\\\"   >2</a></span> \",\"3\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=3\\\"   >3</a></span> \",\"4\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=4\\\"   >4</a></span> \",\"5\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" >5</a></span> \",\"6\":\"<span class=\\\"page active\\\">6</span> \",\"after\":\"<span class=\\\"page next disabled\\\">Next&nbsp;&rsaquo;</span>\"},  [0], {\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html, id = frontend.pagy_nav_responsive(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<span class=\\\"page prev\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></span> \",\"1\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=1\\\"   >1</a></span> \",\"gap\":\"<span class=\\\"page gap\\\">&hellip;</span> \",\"6\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=6\\\"   >6</a></span> \",\"7\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=7\\\"   >7</a></span> \",\"8\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=8\\\"   >8</a></span> \",\"9\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" >9</a></span> \",\"10\":\"<span class=\\\"page active\\\">10</span> \",\"11\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" >11</a></span> \",\"12\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=12\\\"   >12</a></span> \",\"13\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=13\\\"   >13</a></span> \",\"14\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=14\\\"   >14</a></span> \",\"50\":\"<span class=\\\"page\\\"><a href=\\\"/foo?page=50\\\"   >50</a></span> \",\"after\":\"<span class=\\\"page next\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></span>\"},  [0], {\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

  describe "#pagy_nav_responsive_bootstrap" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for bootstrap' do
      pagy, _  = @array.pagy(1)
      html, id = frontend.pagy_nav_responsive_bootstrap(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-bootstrap pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"2\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" >2</a></li>\",\"3\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=3\\\"  class=\\\"page-link\\\" >3</a></li>\",\"4\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" >4</a></li>\",\"5\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" >5</a></li>\",\"6\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},  [0], {\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3 for bootstrap' do
      pagy, _  = @array.pagy(3)
      html, id = frontend.pagy_nav_responsive_bootstrap(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-bootstrap pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"2\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" >2</a></li>\",\"3\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=3\\\"  class=\\\"page-link\\\" >3</a></li>\",\"4\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" >4</a></li>\",\"5\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" >5</a></li>\",\"6\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},  [0], {\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6 for bootstrap' do
      pagy, _  = @array.pagy(6)
      html, id = frontend.pagy_nav_responsive_bootstrap(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-bootstrap pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"2\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=2\\\"  class=\\\"page-link\\\" >2</a></li>\",\"3\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=3\\\"  class=\\\"page-link\\\" >3</a></li>\",\"4\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=4\\\"  class=\\\"page-link\\\" >4</a></li>\",\"5\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=5\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" >5</a></li>\",\"6\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"after\":\"<li class=\\\"page-item next disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},  [0], {\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10 for bootstrap' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html, id = frontend.pagy_nav_responsive_bootstrap(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-bootstrap pagination\" role=\"navigation\" aria-label=\"pager\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"page-item prev\\\"><a href=\\\"/foo?page=9\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=1\\\"  class=\\\"page-link\\\" >1</a></li>\",\"gap\":\"<li class=\\\"page-item gap disabled\\\"><a href=\\\"#\\\" class=\\\"page-link\\\">&hellip;</a></li>\",\"6\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=6\\\"  class=\\\"page-link\\\" >6</a></li>\",\"7\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=7\\\"  class=\\\"page-link\\\" >7</a></li>\",\"8\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=8\\\"  class=\\\"page-link\\\" >8</a></li>\",\"9\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=9\\\"  class=\\\"page-link\\\" rel=\\\"prev\\\" >9</a></li>\",\"10\":\"<li class=\\\"page-item active\\\"><a href=\\\"/foo?page=10\\\"  class=\\\"page-link\\\" >10</a></li>\",\"11\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=11\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" >11</a></li>\",\"12\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=12\\\"  class=\\\"page-link\\\" >12</a></li>\",\"13\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=13\\\"  class=\\\"page-link\\\" >13</a></li>\",\"14\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=14\\\"  class=\\\"page-link\\\" >14</a></li>\",\"50\":\"<li class=\\\"page-item\\\"><a href=\\\"/foo?page=50\\\"  class=\\\"page-link\\\" >50</a></li>\",\"after\":\"<li class=\\\"page-item next\\\"><a href=\\\"/foo?page=11\\\"  class=\\\"page-link\\\" rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},  [0], {\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

  describe "#pagy_nav_responsive_bulma" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for bulma' do
      pagy, _  = @array.pagy(1)
      html, id = frontend.pagy_nav_responsive_bulma(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-bulma pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<a class=\\\"pagination-previous\\\" disabled>&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 1\\\">1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 2\\\">2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 3\\\">3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 4\\\">4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 5\\\">5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 6\\\">6</a></li>\",\"after\":\"</ul>\"},  [0], {\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3 for bulma' do
      pagy, _  = @array.pagy(3)
      html, id = frontend.pagy_nav_responsive_bulma(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-bulma pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 1\\\">1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 2\\\">2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 3\\\">3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 4\\\">4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 5\\\">5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 6\\\">6</a></li>\",\"after\":\"</ul>\"},  [0], {\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6 for bulma' do
      pagy, _  = @array.pagy(6)
      html, id = frontend.pagy_nav_responsive_bulma(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-bulma pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a class=\\\"pagination-next\\\" disabled>Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 1\\\">1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 2\\\">2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 3\\\">3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 4\\\">4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 5\\\">5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 6\\\">6</a></li>\",\"after\":\"</ul>\"},  [0], {\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10 for bulma' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html, id = frontend.pagy_nav_responsive_bulma(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-bulma pagination is-centered\" role=\"navigation\" aria-label=\"pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" class=\\\"pagination-previous\\\" aria-label=\\\"previous page\\\">&lsaquo;&nbsp;Prev</a><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" class=\\\"pagination-next\\\" aria-label=\\\"next page\\\">Next&nbsp;&rsaquo;</a><ul class=\\\"pagination-list\\\">\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 1\\\">1</a></li>\",\"gap\":\"<li><span class=\\\"pagination-ellipsis\\\">&hellip;</span></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 6\\\">6</a></li>\",\"7\":\"<li><a href=\\\"/foo?page=7\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 7\\\">7</a></li>\",\"8\":\"<li><a href=\\\"/foo?page=8\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 8\\\">8</a></li>\",\"9\":\"<li><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 9\\\">9</a></li>\",\"10\":\"<li><a href=\\\"/foo?page=10\\\"   class=\\\"pagination-link is-current\\\" aria-current=\\\"page\\\" aria-label=\\\"page 10\\\">10</a></li>\",\"11\":\"<li><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" class=\\\"pagination-link\\\" aria-label=\\\"goto page 11\\\">11</a></li>\",\"12\":\"<li><a href=\\\"/foo?page=12\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 12\\\">12</a></li>\",\"13\":\"<li><a href=\\\"/foo?page=13\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 13\\\">13</a></li>\",\"14\":\"<li><a href=\\\"/foo?page=14\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 14\\\">14</a></li>\",\"50\":\"<li><a href=\\\"/foo?page=50\\\"   class=\\\"pagination-link\\\" aria-label=\\\"goto page 50\\\">50</a></li>\",\"after\":\"</ul>\"},  [0], {\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

  describe "#pagy_nav_responsive_foundation" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for foundation' do
      pagy, _  = @array.pagy(1)
      html, id = frontend.pagy_nav_responsive_foundation(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-foundation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"disabled\\\">&lsaquo;&nbsp;Prev</li>\",\"1\":\"<li class=\\\"current\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" >2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   >4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   >5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},  [0], {\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3 for foundation' do
      pagy, _  = @array.pagy(3)
      html, id = frontend.pagy_nav_responsive_foundation(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-foundation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" >2</a></li>\",\"3\":\"<li class=\\\"current\\\"><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" >4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   >5</a></li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},  [0], {\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6 for foundation' do
      pagy, _  = @array.pagy(6)
      html, id = frontend.pagy_nav_responsive_foundation(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-foundation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li><a href=\\\"/foo?page=2\\\"   >2</a></li>\",\"3\":\"<li><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li><a href=\\\"/foo?page=4\\\"   >4</a></li>\",\"5\":\"<li><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" >5</a></li>\",\"6\":\"<li class=\\\"current\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li class=\\\"disabled\\\">Next&nbsp;&rsaquo;</li></ul>\"},  [0], {\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10 for foundation' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html, id = frontend.pagy_nav_responsive_foundation(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<nav id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-foundation\" aria-label=\"Pagination\"></nav><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\">&lsaquo;&nbsp;Prev</a></li>\",\"1\":\"<li><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"gap\":\"<li class=\\\"gap disabled\\\">&hellip;</li>\",\"6\":\"<li><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"7\":\"<li><a href=\\\"/foo?page=7\\\"   >7</a></li>\",\"8\":\"<li><a href=\\\"/foo?page=8\\\"   >8</a></li>\",\"9\":\"<li><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" >9</a></li>\",\"10\":\"<li class=\\\"current\\\"><a href=\\\"/foo?page=10\\\"   >10</a></li>\",\"11\":\"<li><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" >11</a></li>\",\"12\":\"<li><a href=\\\"/foo?page=12\\\"   >12</a></li>\",\"13\":\"<li><a href=\\\"/foo?page=13\\\"   >13</a></li>\",\"14\":\"<li><a href=\\\"/foo?page=14\\\"   >14</a></li>\",\"50\":\"<li><a href=\\\"/foo?page=50\\\"   >50</a></li>\",\"after\":\"<li><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\">Next&nbsp;&rsaquo;</a></li></ul>\"},  [0], {\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

  describe "#pagy_nav_responsive_materialize" do

    before do
      @array = (1..103).to_a.extend(Pagy::Array::PageMethod)
    end

    it 'renders page 1 for materialize' do
      pagy, _  = @array.pagy(1)
      html, id = frontend.pagy_nav_responsive_materialize(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<div id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-materialize pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"prev disabled\\\"><a href=\\\"#\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" >2</a></li>\",\"3\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=4\\\"   >4</a></li>\",\"5\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=5\\\"   >5</a></li>\",\"6\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},  [0], {\"0\":[\"1\",2,3,4,5,6]}]</script>"
    end

    it 'renders page 3 for materialize' do
      pagy, _  = @array.pagy(3)
      html, id = frontend.pagy_nav_responsive_materialize(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<div id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-materialize pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=2\\\"   rel=\\\"prev\\\" >2</a></li>\",\"3\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" >4</a></li>\",\"5\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=5\\\"   >5</a></li>\",\"6\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=4\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},  [0], {\"0\":[1,2,\"3\",4,5,6]}]</script>"
    end

    it 'renders page 6 for materialize' do
      pagy, _  = @array.pagy(6)
      html, id = frontend.pagy_nav_responsive_materialize(pagy), caller(0,1)[0].hash
      html.must_equal \
        "<div id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-materialize pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"2\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=2\\\"   >2</a></li>\",\"3\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=3\\\"   >3</a></li>\",\"4\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=4\\\"   >4</a></li>\",\"5\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=5\\\"   rel=\\\"prev\\\" >5</a></li>\",\"6\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"after\":\"<li class=\\\"next disabled\\\"><a href=\\\"#\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},  [0], {\"0\":[1,2,3,4,5,\"6\"]}]</script>"
    end

    it 'renders page 10 for materialize' do
      @array   = (1..1000).to_a.extend(Pagy::Array::PageMethod)
      pagy, _  = @array.pagy(10)
      html, id = frontend.pagy_nav_responsive_materialize(pagy), caller(0,1)[0].hash
      html.must_equal \
         "<div id=\"pagy-nav-#{id}\" class=\"pagy-nav-responsive-materialize pagination\" role=\"navigation\" aria-label=\"pager\"></div><script type=\"application/json\" class=\"pagy-responsive-json\">[\"#{id}\", {\"before\":\"<ul class=\\\"pagination\\\"><li class=\\\"waves-effect prev\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" aria-label=\\\"previous\\\"><i class=\\\"material-icons\\\">chevron_left</i></a></li>\",\"1\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=1\\\"   >1</a></li>\",\"gap\":\"<li class=\\\"gap disabled\\\"><a href=\\\"#\\\">&hellip;</a></li>\",\"6\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=6\\\"   >6</a></li>\",\"7\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=7\\\"   >7</a></li>\",\"8\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=8\\\"   >8</a></li>\",\"9\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=9\\\"   rel=\\\"prev\\\" >9</a></li>\",\"10\":\"<li class=\\\"active\\\"><a href=\\\"/foo?page=10\\\"   >10</a></li>\",\"11\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" >11</a></li>\",\"12\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=12\\\"   >12</a></li>\",\"13\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=13\\\"   >13</a></li>\",\"14\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=14\\\"   >14</a></li>\",\"50\":\"<li class=\\\"waves-effect\\\"><a href=\\\"/foo?page=50\\\"   >50</a></li>\",\"after\":\"<li class=\\\"waves-effect next\\\"><a href=\\\"/foo?page=11\\\"   rel=\\\"next\\\" aria-label=\\\"next\\\"><i class=\\\"material-icons\\\">chevron_right</i></a></li></ul>\"},  [0], {\"0\":[1,\"gap\",6,7,8,9,\"10\",11,12,13,14,\"gap\",50]}]</script>"
    end

  end

end
