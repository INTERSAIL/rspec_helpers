module Helpers
  module Object
    RSpec::Matchers.define :have_an_alias do |original_name, alias_name|
      match do |actual|
        expect(actual.method(original_name)).to be == actual.method(alias_name)
      end
    end

    RSpec::Matchers.define :inherit_from do |klass|
      match do |actual|
        expect(actual < (klass)).to be true
      end
    end

    RSpec::Matchers.define :includes do |klass|
      match do |actual|
        expect(actual.is_a? klass).to be true
      end
    end


    RSpec::Matchers.define :extends do |klass|
      match do |actual|
        expect(actual.class.is_a? klass).to be true
      end
    end

    RSpec::Matchers.define :delegate_with_prefix do |method, klass, prefix|
      match do |actual|
        receiver = double("manager").as_null_object
        actual.send("#{klass}=", receiver)
        actual.send("#{prefix.to_s}_#{method.to_s}", {})
      end
    end

    RSpec::Matchers.define :delegates do |method, klass|
      match do |actual|
        receiver = double("manager").as_null_object
        actual.send("#{klass}=", receiver)
        actual.send("#{method.to_s}", {})
      end
    end

    RSpec::Matchers.define :delegate_methods_with_prefix do |methods, klass, prefix|
      match do |actual|
        methods.each do |method|
          expect(actual).to delegate_with_prefix(method, klass, prefix)
        end
      end
    end
  end
end