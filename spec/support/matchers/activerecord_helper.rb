module Helpers
  module ActiveRecord
    RSpec::Matchers.define :have_an_alias_attribute do |original_name, alias_name|
      match do |actual|
        first_value = 1
        second_value = 2

        # first value to second value
        actual.send("#{original_name}=", first_value)
        expect { actual.send("#{alias_name}=", second_value) }
        .to change { actual.send(original_name) }
            .from(first_value)
            .to(second_value)

        #second value to first value
        expect { actual.send("#{original_name}=", first_value) }
        .to change { actual.send(alias_name) }
            .from(second_value)
            .to(first_value)
      end
    end

    RSpec::Matchers.define :have_timestamps do
      match do |actual|
        expect(actual).to(have_db_column(:created_at).of_type(:datetime))
        expect(actual).to(have_db_column(:updated_at).of_type(:datetime))
      end
    end

    RSpec::Matchers.define :implement_sti do
      match do |actual|
        expect(actual).to(have_db_column(:type).of_type(:string))
      end
    end

    RSpec::Matchers.define :have_subattribute_validator do |attr_name|
      # Check for all the callback that have SubAttributeValidator on the given attribute attr_name
      match do |actual|
        validator = actual._validate_callbacks.select { |callback|
          callback.filter.attributes == [attr_name.to_sym] &&
              callback.filter.class == Intersail::Validators::SubAttributeValidator
        }
        expect(validator.size).to be > 0

        # Check for valid interface
        expect(actual).to respond_to :errors
        expect(actual.errors).to respond_to :full_messages
      end
    end

    RSpec::Matchers.define :be_buildable_from_hash do
      match do |actual|
        expect(actual.class.from_hash(actual.as_json).serializable_hash).to be == actual.as_json
      end
    end
  end
end
