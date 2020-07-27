# frozen_string_literal: true

class Hash
  # Returns a hash with non +nil+ values.
  #   hash = { a: true, b: false, c: nil}
  #   hash.compact # => { a: true, b: false}
  #   hash # => { a: true, b: false, c: nil}
  #   { c: nil }.compact # => {}
  def compact
    select { |_, value| !value.nil? }
  end

  # Replaces current hash with non +nil+ values.
  #   hash = { a: true, b: false, c: nil}
  #   hash.compact! # => { a: true, b: false}
  #   hash # => { a: true, b: false}
  def compact!
    reject! { |_, value| value.nil? }
  end
end
