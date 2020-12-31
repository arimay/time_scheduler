#
# OrderSet implements a Set that guarantees that its elements are
# yielded in sorted order (according to the return values of their
# #<=> methods) when iterating over them.
#
# All elements that are added to a OrderSet must respond to the <=>
# method for comparison.
#
# Also, all elements must be <em>mutually comparable</em>: <tt>el1 <=>
# el2</tt> must not return <tt>nil</tt> for any elements <tt>el1</tt>
# and <tt>el2</tt>, else an ArgumentError will be raised when
# iterating over the OrderSet.
#
# == Example
#
#   require "set"
#
#   set = OrderSet.new([2, 1, 5, 6, 4, 5, 3, 3, 3])
#   ary = []
#
#   set.each do |obj|
#     ary << obj
#   end
#
#   p ary # => [1, 2, 3, 4, 5, 6]
#
#   set2 = OrderSet.new([1, 2, "3"])
#   set2.each { |obj| } # => raises ArgumentError: comparison of Fixnum with String failed
#

require "set"

class TimeScheduler
  class OrderSet < Set

    class << self
      def [](*ary)        # :nodoc:
        new(ary)
      end
    end

    def initialize(*args)
      @keys = nil
      super
    end

    def clear
      @keys = nil
      super
    end

    def replace(enum)
      @keys = nil
      super
    end

    def add(o)
      o.respond_to?(:<=>) or raise ArgumentError, "value must respond to <=>"
      @keys = nil
      super
    end
    alias << add

    def delete(o)
      @keys = nil
      @hash.delete(o)
      self
    end

    def delete_if
      block_given? or return enum_for(__method__) { size }
      n = @hash.size
      super
      @keys = nil if @hash.size != n
      self
    end

    def keep_if
      block_given? or return enum_for(__method__) { size }
      n = @hash.size
      super
      @keys = nil if @hash.size != n
      self
    end

    def merge(enum)
      @keys = nil
      super
    end

    def each(&block)
      block or return enum_for(__method__) { size }
      to_a.each(&block)
      self
    end

    def to_a
      (@keys = @hash.keys).sort! unless @keys
      @keys
    end

    def freeze
      to_a
      super
    end

    def rehash
      @keys = nil
      super
    end

  end
end

