class Field
  # may either be some other Field in which the length is encoded or a Fixnum for
  # fixed length fields.
  attr_accessor :length
  attr_accessor :codec
 

  def parse raw

    len, raw = case length
               when Fixnum
                 [length, raw]
               when Field
                 length.parse(raw)
               else
                 raise ISO8583Exception.new("How did you manage to fuck up configuration this bad?")
               end

    raw_value  = raw[0,len]
    
    # make sure we have enough data ...
    if raw_value.length != len
      mes = "Field has incorrect length! field: #{raw_value} len/expected: #{raw_value.length}/#{len}"
      raise ISO8583ParseException.new(mes)
    end

    rest       = raw[len, raw.length]
    real_value = codec.decode(raw_value)
    return real_value, rest
  end

  def encode value

  end
end

#
#class Field
#  attr_accessor :value
#  
#  def initialize value=nil
#    @value = value
#  end
#  
#  def name
#    self.class._name
#  end
#  
#  def to_b
#    self.class.to_b @value
#  end
#
#  def to_s
#    "#{name} : #{value}"
#  end
#
#  class << self
#    def name name
#      @name = name
#    end
#    def _name
#      @name
#    end
#    def length len
#      @len = len
#    end
#
#    def _len
#      if (@len == nil) && (superclass.respond_to?(:_len))
#        return superclass.send(:_len)
#      end
#      @len
#    end
#
#    def min min
#      @min = min
#    end
#
#    def max max
#      @max = max
#    end
#    #def padding pad
#    #  @pad = pad
#    #end 
#    def codec codec
#      codec ||= Codec
#      @codec = codec
#      @codec = codec.new if codec.is_a? Class
#    end
#    
#    # tries to parse the 
#    def parse raw
#      l, rest = _get_len raw
#      #puts "len #{l}"
#      #puts "rest: #{rest}"
#      value = rest[0,l]
#
#      unless value.length == l
#        raise ISO8583ParseException.new "Wrong length for: #{value} (#{value.length}), expected #{l}" 
#      end
#
#      check(value)
#      
#
#      rest  = rest[l,rest.length] 
#      real_value = @codec.decode value
#      field = self.new real_value
#      return field, rest
#    end 
#
#    def to_b value
#      enc_value = @codec.encode(value)
#      enc_len   = 
#        case _len
#        when Fixnum
#          enc_value
#        when Field
#          _len.to_b(enc_value.length)
#
#    end
#
#    def check value
#      if @min && value.length < @min
#        raise ISO8583ParseException.new "Wrong length for: #{value}  (#{value.length}), min length #{@min}"
#      end
#      
#      if @max && value.length > @max
#        raise ISO8583ParseException.new "Wrong length for: #{value}  (#{value.length}), max length #{@max}"
#      end
#    end
#    
#    def _get_len raw
#      return _len, raw if _len.is_a? Fixnum
#      puts self.ancestors
#      puts _len
#      len_field, rest = _len.parse(raw)
#      return len_field.value, rest
#    end
#    
#
#  end
#end
#