# = Simple JSON parser & builder
#
# Author::  Chihiro Ito
# License:: Public domain (unlike other files)
# Support:: http://groups.google.com/group/webos-goodies/
#
# This file contains two simple JSON processing classes. WebAPI::JsonParser
# converts a JSON string to an array or a hash. WebAPI::JsonBuilder performs
# vice versa. These classes are standard compliant and are designed for
# stability and reliability. Especially WebAPI::JsonParser has UTF-8 validation
# functionality so you can avoid some kind of security attack.

require 'strscan'

module WebAPI

  # = Simple JSON parser
  #
  # This class converts a JSON string to an array or a hash. If *json_str*
  # contains a JSON form string, you can convert it like below.
  #
  #   ruby_obj = WebAPI::JsonParser.new.parse(json_str)
  #
  # If *json_str* has one or more invalid UTF-8 sequence, JsonParser throws
  # exception by default. You can change this behavior to replacing with an
  # arbitrary unicode character. See below for details.
  class JsonParser

    #:stopdoc:
    RUBY19             = RUBY_VERSION >= '1.9.0'
    Debug              = false
    Name               = 'WebAPI::JsonParser'
    ERR_IllegalSyntax  = "[#{Name}] Syntax error"
    ERR_IllegalUnicode = "[#{Name}] Illegal unicode sequence"

    StringRegex = /\s*"((?:\\.|[^"\\])*)"/n
    ValueRegex  = /\s*(?:
		(true)|(false)|(null)|            # 1:true, 2:false, 3:null
		(?:\"((?:\\.|[^\"\\])*)\")|       # 4:String
		([-+]?\d+\.\d+(?:[eE][-+]?\d+)?)| # 5:Float
		([-+]?\d+)|                       # 6:Integer
		(\{)|(\[))/xn                     # 7:Hash, 8:Array
    #:startdoc:

    # Create a new instance of JsonParser. *options* can contain these values.
    # [:validation]
    #     If set to false, UTF-8 validation is disabled. true by default.
    # [:surrogate]
    #     If set to false, surrogate pair support is disabled. true by default.
    # [:malformed_chr]
    #     An invalid sequence in JSON string will be replaced with this value.
    #     If set to nil, An exception will be thrown in this situation.
    #     nil by default.
    def initialize(options = {})
      @default_validation    = options.has_key?(:validation)    ? options[:validation]    : true
      @default_surrogate     = options.has_key?(:surrogate)     ? options[:surrogate]     : true
      @default_malformed_chr = options.has_key?(:malformed_chr) ? options[:malformed_chr] : nil
    end

    # Convert *str* to an array or hash.
    # [str]
    #     A JSON form string. This must be encoded using UTF-8.
    # [options]
    #     Same as new.
    def parse(str, options = {})
      @enable_validation = options.has_key?(:validation)    ? options[:validation]    : @default_validation
      @enable_surrogate  = options.has_key?(:surrogate)     ? options[:surrogate]     : @default_surrogate
      @malformed_chr     = options.has_key?(:malformed_chr) ? options[:malformed_chr] : @default_malformed_chr
      @malformed_chr = @malformed_chr[0].ord if String === @malformed_chr
      if RUBY19
        str = (str.encode('UTF-8') rescue str.dup)
        if @enable_validation && !@malformed_chr
          raise err_msg(ERR_IllegalUnicode) unless str.valid_encoding?
          @enable_validation = false
        end
        str.force_encoding('ASCII-8BIT')
      end
      @scanner = StringScanner.new(str)
      obj = case get_symbol[0]
            when ?{ then parse_hash
            when ?[ then parse_array
            else         raise err_msg(ERR_IllegalSyntax)
            end
      @scanner = nil
      obj
    end

    private #---------------------------------------------------------

    def validate_string(str, malformed_chr = nil)
      code  = 0
      rest  = 0
      range = nil
      ucs   = []
      str.each_byte do |c|
        if rest <= 0
          case c
          when 0x01..0x7f then rest = 0 ; ucs << c
          when 0xc0..0xdf then rest = 1 ; code = c & 0x1f ; range = 0x00080..0x0007ff
          when 0xe0..0xef then rest = 2 ; code = c & 0x0f ; range = 0x00800..0x00ffff
          when 0xf0..0xf7 then rest = 3 ; code = c & 0x07 ; range = 0x10000..0x10ffff
          else                 ucs << handle_malformed_chr(malformed_chr)
          end
        elsif (0x80..0xbf) === c
          code = (code << 6) | (c & 0x3f)
          if (rest -= 1) <= 0
            if !(range === code) || (0xd800..0xdfff) === code
              code = handle_malformed_chr(malformed_chr)
            end
            ucs << code
          end
        else
          ucs << handle_malformed_chr(malformed_chr)
          rest = 0
        end
      end
      ucs << handle_malformed_chr(malformed_chr) if rest > 0
      ucs.pack('U*')
    end

    def handle_malformed_chr(chr)
      raise err_msg(ERR_IllegalUnicode) unless chr
      chr
    end

    def err_msg(err)
      err + (Debug ? " #{@scanner.string[[0, @scanner.pos - 8].max,16].inspect}" : "")
    end

    def unescape_string(str)
      str = str.gsub(/\\(["\\\/bfnrt])/n) do
        $1.tr('"\\/bfnrt', "\"\\/\b\f\n\r\t")
      end.gsub(/(\\u[0-9a-fA-F]{4})+/n) do |matched|
        seq = matched.scan(/\\u([0-9a-fA-F]{4})/n).flatten.map { |c| c.hex }
        if @enable_surrogate
          seq.each_index do |index|
            if seq[index] && (0xd800..0xdbff) === seq[index]
              n = index + 1
              raise err_msg(ERR_IllegalUnicode) unless seq[n] && 0xdc00..0xdfff === seq[n]
              seq[index] = 0x10000 + ((seq[index] & 0x03ff) << 10) + (seq[n] & 0x03ff)
              seq[n] = nil
            end
          end.compact!
        end
        seq.pack('U*')
      end
      str = validate_string(str, @malformed_chr) if @enable_validation
      RUBY19 ? str.force_encoding('UTF-8') : str
    end

    def get_symbol
      raise err_msg(ERR_IllegalSyntax) unless @scanner.scan(/\s*(.)/n)
      @scanner[1]
    end

    def peek_symbol
      @scanner.match?(/\s*(.)/n) ? @scanner[1] : nil
    end

    def parse_string
      raise err_msg(ERR_IllegalSyntax) unless @scanner.scan(StringRegex)
      unescape_string(@scanner[1])
    end

    def parse_value
      raise err_msg(ERR_IllegalSyntax) unless @scanner.scan(ValueRegex)
      case
      when @scanner[1] then true
      when @scanner[2] then false
      when @scanner[3] then nil
      when @scanner[4] then unescape_string(@scanner[4])
      when @scanner[5] then @scanner[5].to_f
      when @scanner[6] then @scanner[6].to_i
      when @scanner[7] then parse_hash
      when @scanner[8] then parse_array
      else                  raise err_msg(ERR_IllegalSyntax)
      end
    end

    def parse_hash
      obj = {}
      if peek_symbol[0] == ?} then get_symbol ; return obj ; end
      while true
        index = parse_string
        raise err_msg(ERR_IllegalSyntax) unless get_symbol[0] == ?:
        value = parse_value
        obj[index] = value
        case get_symbol[0]
        when ?} then return obj
        when ?, then next
        else         raise err_msg(ERR_IllegalSyntax)
        end
      end
    end

    def parse_array
      obj = []
      if peek_symbol[0] == ?] then get_symbol ; return obj ; end
      while true
        obj << parse_value
        case get_symbol[0]
        when ?] then return obj
        when ?, then next
        else         raise err_msg(ERR_IllegalSyntax)
        end
      end
    end

  end

  # = Simple JSON builder
  #
  # This class converts an Ruby object to a JSON string. you can convert
  # *ruby_obj* like below.
  #
  #   json_str = WebAPI::JsonBuilder.new.build(ruby_obj)
  #
  # *ruby_obj* must satisfy these conditions.
  # - It must support to_s method, otherwise must be an array, a hash or nil.
  # - All keys of a hash must support to_s method.
  # - All values of an array or a hash must satisfy all conditions mentioned above.
  #
  # If the *ruby_obj* is not an array or a hash, it will be converted to an array
  # with a single element.
  class JsonBuilder

    #:stopdoc:
    RUBY19             = RUBY_VERSION >= '1.9.0'
    Name               = 'WebAPI::JsonBuilder'
    ERR_NestIsTooDeep  = "[#{Name}] Array / Hash nested too deep."
    ERR_NaN            = "[#{Name}] NaN and Infinite are not permitted in JSON."
    #:startdoc:

    # Create a new instance of JsonBuilder. *options* can contain these values.
    # [:max_nest]
    #     If Array / Hash is nested more than this value, an exception would be thrown.
    #     64 by default.
    # [:nan]
    #     NaN is replaced with this value. If nil or false, an exception will be thrown.
    #     nil by default.
    def initialize(options = {})
      @default_max_nest = options.has_key?(:max_nest) ? options[:max_nest] : 64
      @default_nan      = options.has_key?(:nan)      ? options[:nan]      : nil
    end

    # Convert *obj* to a JSON form string.
    # [obj]
    #     A ruby object. this object must satisfy all conditions mentioned above.
    # [options]
    #     Same as new.
    def build(obj, options = {})
      @max_nest = options.has_key?(:max_nest) ? options[:max_nest] : @default_max_nest
      @nan      = options.has_key?(:nan)      ? options[:nan]      : @default_nan
      case obj
      when Array then build_array(obj, 0)
      when Hash  then build_object(obj, 0)
      else            build_array([obj], 0)
      end
    end

    private #---------------------------------------------------------

    if RUBY19
      ESCAPE_CONVERSION = { '\x' => '\u00', '\a' => '\u0007', '\v' => '\u000B', '\e' => '\u001B', '/' => '\/' }
      def escape(str)
        str = str.to_s.encode('UTF-8').inspect
        str.gsub!(/\\[xave]|\//u){|s| ESCAPE_CONVERSION[s] }
        str
      end
    else
      ESCAPE_CONVERSION = ['\"', '\\\\', '\/', '\b', '\f', '\n', '\r', '\t']
      def escape(str)
        str = str.gsub(/[^\x20-\x21\x23-\x2e\x30-\x5b\x5d-\xff]/n) do |chr|
          if index = "\"\\/\b\f\n\r\t".index(chr[0])
            ESCAPE_CONVERSION[index]
          else
            sprintf("\\u%04X", chr[0])
          end
        end
        "\"#{str}\""
      end
    end

    def build_value(obj, level)
      case obj
      when Integer, TrueClass, FalseClass then obj.to_s
      when Float    then raise ERR_NaN unless obj.finite? || (obj = @nan) ; obj.to_s
      when NilClass then 'null'
      when Array    then build_array(obj, level + 1)
      when Hash     then build_object(obj, level + 1)
      else               escape(obj)
      end
    end

    def build_array(obj, level)
      raise ERR_NestIsTooDeep if level >= @max_nest
      '[' + obj.map { |item| build_value(item, level) }.join(',') + ']'
    end

    def build_object(obj, level)
      raise ERR_NestIsTooDeep if level >= @max_nest
      '{' + obj.map do |item|
        "#{build_value(item[0].to_s,level)}:#{build_value(item[1],level)}"
      end.join(',') + '}'
    end

  end

end
