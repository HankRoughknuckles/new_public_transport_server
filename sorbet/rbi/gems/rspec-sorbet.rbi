# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strong
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rspec-sorbet/all/rspec-sorbet.rbi
#
# rspec-sorbet-1.5.0

module RSpec
end
module RSpec::Sorbet
  extend RSpec::Sorbet::Doubles
end
module RSpec::Sorbet::Doubles
  def allow_doubles!; end
  def allow_instance_doubles!; end
  def call_validation_error_handler(_signature, opts); end
  def double_message_with_ellipsis?(message); end
  def inline_type_error_handler(error); end
  def typed_array_message?(message); end
end
