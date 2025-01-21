# frozen_string_literal: true

class Pagy
  METADATA = %i[url_template first_url prev_url page_url next_url last_url
                count page limit pages last in from to prev next vars series sequels].freeze

  # Add a specialized backend method for pagination metadata
  Backend.module_eval do
    private

    # Return the metadata hash
    def pagy_metadata(pagy, absolute: nil)
      url_template = pagy_page_url(pagy, PAGE_TOKEN, absolute:)
      keys  = pagy.vars[:metadata] || METADATA
      keys -= %i[count limit] if pagy.calendar?
      {}.tap do |metadata|
        keys.each do |key|
          metadata[key] = case key
                          when :url_template then url_template
                          when :first_url    then pagy_page_url(pagy, nil, absolute:)
                          when :prev_url     then url_template.sub(PAGE_TOKEN, pagy.prev.to_s)
                          when :page_url     then url_template.sub(PAGE_TOKEN, pagy.page.to_s)
                          when :next_url     then url_template.sub(PAGE_TOKEN, pagy.next.to_s)
                          when :last_url     then url_template.sub(PAGE_TOKEN, pagy.last.to_s)
                          else pagy.send(key)
                          end
        rescue NoMethodError
          raise VariableError.new(pagy, :metadata, 'to contain known keys', key)
        end
      end
    end
  end
end
