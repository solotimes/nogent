class CurrentPasswordValidator < ActiveModel::EachValidator
  def initialize(options)
    options[:fields] ||= []

    super
  end

  def validate_each(record, attribute, value)
    if (record.changed & options[:fields].map(&:to_s)).any?
      if value.blank?
        record.errors.add(attribute, :blank)
      elsif BCrypt::Password.new(record.password_digest_was) != value
        record.errors.add(attribute, :current_password_no_match)
      end
    end
  end
end