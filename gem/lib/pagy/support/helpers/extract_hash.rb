# frozen_string_literal: true

class Pagy
  class_eval do
    # Return the pagy hash
    def extract_hash(pluck_keys: nil, **)
      url_template = page_url(PAGE_TOKEN, **)
      keys  = pluck_keys || @options[:pluck_keys] ||
              %i[url_template first_url previous_url page_url next_url last_url
                 count page limit pages last in from to previous next options series sequels]
      keys -= %i[count limit] if calendar?
      {}.tap do |data|
        keys.each do |key|
          data[key] = case key
                      when :url_template then url_template
                      when :first_url    then page_url(nil, **)
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
end
