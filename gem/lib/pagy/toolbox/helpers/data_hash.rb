# frozen_string_literal: true

class Pagy
  # Generate a hash of the wanted internal data
  def data_hash(data_keys: @options[:data_keys] ||
    %i[url_template first_url previous_url page_url next_url last_url
       count page limit last in from to previous next options], **)
    data_keys   -= %i[count limit] if calendar?
    url_template = compose_page_url(PAGE_TOKEN, **)
    {}.tap do |data|
      data_keys.each do |key|
        data[key] = case key
                    when :url_template then url_template
                    when :first_url    then compose_page_url(nil, **)
                    when :previous_url then url_template.sub(PAGE_TOKEN, @previous.to_s)
                    when :page_url     then url_template.sub(PAGE_TOKEN, @page.to_s)
                    when :next_url     then url_template.sub(PAGE_TOKEN, @next.to_s)
                    when :last_url     then url_template.sub(PAGE_TOKEN, @last.to_s)
                    else send(key)
                    end
      rescue NoMethodError
        raise OptionError.new(self, :data, 'to contain known keys', key)
      end
    end
  end
end
