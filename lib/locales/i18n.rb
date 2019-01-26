# See https://ddnexus.github.io/pagy/api/frontend#i18n
# frozen_string_literal: true

# this file returns the I18N hash used as default alternative to the i18n gem

# flatten the dictionary file nested keys
# convert each value to a simple ruby interpolation proc
flatten = lambda do |hash, key=''|
            hash.each.reduce({}) do |h, (k, v)|
              if v.is_a?(Hash)
                h.merge!(flatten.call(v, "#{key}#{k}."))
              else
                v_proc = eval %({"#{key}#{k}" => lambda{|vars|"#{v.gsub(/%{[^}]+?}/){|m| "\#{vars[:#{m[2..-2]}]||'#{m}'}" }}"}}) #rubocop:disable Security/Eval
                h.merge!(v_proc)
              end
            end
          end

{}.tap do |i18n|
  i18n.define_singleton_method(:load) do |*args|
    replace({})
    p11n = eval(Pagy.root.join('locales', 'p11n.rb').read) #rubocop:disable Security/Eval
    args.each do |arg|
      arg[:filepath]  ||= Pagy.root.join('locales', "#{arg[:locale]}.yml")
      arg[:pluralize] ||= p11n[arg[:locale]]
      hash = YAML.load(File.read(arg[:filepath], encoding: 'UTF-8')) #rubocop:disable Security/YAMLLoad
      hash.key?(arg[:locale]) or raise ArgumentError, %(I18N.load: :locale "#{arg[:locale]}" not found in :filepath "#{arg[:filepath]}")
      self[arg[:locale]] = [ flatten.call(hash[arg[:locale]]), arg[:pluralize] ]
    end
  end
  i18n.load(locale: 'en')
end
