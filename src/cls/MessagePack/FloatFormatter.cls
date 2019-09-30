/// Formatter for %Numeric values.
/// Encodes/Decodes to/from MessagePack format.
Class MessagePack.FloatFormatter
{

/// Size of float32 in bits.
Parameter BITSFLOAT As %Integer = 32;

/// Size of float64 in bits.
Parameter BITSDOUBLE As %Integer = 64;

/// Size of float32 exponent in bits. 
Parameter EXPONENTBITSFLOAT As %Integer = 8;

/// Size of float64 exponent in bits. 
Parameter EXPONENTBITSDOUBLE As %Integer = 11;

/// Exponent normalizer for
/// float32.
Parameter EXPONENTNORMALIZERFLOAT As %Integer = 127;

/// Exponent normalizer for
/// float64.
Parameter EXPONENTNORMALIZERDOUBLE As %Integer = 1023;

/// Code for float32
/// in MessagePack specification.
Parameter CODEFLOAT As %Integer = 202;

/// Code for float64
/// in MessagePack specification.
Parameter CODEDOUBLE As %Integer = 203;

/// Encodes float32 as %Numeric to 
/// MessagePack format.
ClassMethod EncodeFloat(value As %Numeric) As %Binary
{
  return ..Encode(value, ..#CODEFLOAT)
}

/// Encodes float64 as %Numeric to 
/// MessagePack format.
ClassMethod EncodeDouble(value As %Numeric) As %Binary
{
  return ..Encode(value, ..#CODEDOUBLE)
}

/// Encodes 0 to MessagePack format.
ClassMethod EncodeZero(code As %Integer) [ Private ]
{
  set maxBitsCount = ..GetMaxBitsCount(code)

  set maxBytesCount = maxBitsCount / ##class(MessagePack.Bytes).#BITSINBYTE

  set data = $listbuild(code)

  for i=1:1:maxBytesCount {
    set data = data _ $listbuild(0)
  }

  return data
}

/// Encodes %Numeric to MessagePack format.
ClassMethod Encode(value As %Numeric, code As %Integer) [ Private ]
{
  if (value = 0) {
    return ..EncodeZero(code)
  }

  set maxBitsCount = ..GetMaxBitsCount(code)

  set entier = ##class(MessagePack.Floats).GetEntier(value)

  set entierBits = ##class(MessagePack.Bits).Get(entier, maxBitsCount)

  set entierBitsCount = $bitcount(entierBits)

  set floor = ##class(MessagePack.Floats).GetFloor(value)

  set floorBits = ##class(MessagePack.Bits).Get(floor, maxBitsCount - entierBitsCount)

  set floorBitsCount = $bitcount(floorBits)

  set bits = ##class(MessagePack.Bits).Join(entierBits, floorBits)

  if (entier > 0) {
    set exponentOffset = entierBitsCount - 1
  } else {
    set exponentOffset = 0

    set exponentBitId = $bitcount(bits)

    do {
      set exponentOffset = exponentOffset - 1

      set exponentBitId = exponentBitId - 1
    } while ((exponentBitId > 0) && ($bit(bits, exponentBitId) = 0))
  }

  set exponent = exponentOffset + ..GetExponentNormalizer(code)

  set maxExponentBitsCount = ..GetMaxExponentBitsCount(code)

  set exponentBits = ##class(MessagePack.Bits).Get(exponent, maxExponentBitsCount)

  for i=1:1:maxExponentBitsCount {
    set $bit(floatBits, maxBitsCount - i) = $bit(exponentBits, maxExponentBitsCount - i + 1)
  }

  set bitId = maxBitsCount

  set $bit(floatBits, bitId) = $select(value > 0:0, 1:1)

  set bitId = bitId - 1 - maxExponentBitsCount

  set bitsCount = entierBitsCount + floorBitsCount

  set bitsOffset = bitsCount - $select(exponentOffset > 0:0, 1:-exponentOffset) - 1

  for i=bitsOffset:-1:1 {
    if (bitId = 0) {
      quit
    }

    set $bit(floatBits, bitId) = $bit(bits, i)

    set bitId = bitId - 1
  }

  return $listbuild(code) _ ##class(MessagePack.Bytes).Get(floatBits)
}

/// Decodes %Numeric from MessagePack. 
/// Throws MessagePack.Decoding 
/// exception if decoding is failed.
ClassMethod Decode(data As %Binary)
{
  if (..IsZero(data)) {
    return 0
  }

  set codeByte = $listget(data)

  if ((codeByte '= ..#CODEFLOAT) && (codeByte '= ..#CODEDOUBLE)) {
    throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Unsuitable code.")
  }

  set code = codeByte

  set bytesCount = $listlength(data)

  set bitsCount = bytesCount * ##class(MessagePack.Bytes).#BITSINBYTE

  set bits = ""

  for byteIndex=2:1:bytesCount {
    set byte = $listget(data, byteIndex)

    set byteBits = ##class(MessagePack.Bits).Get(byte, ##class(MessagePack.Bytes).#BITSINBYTE)

    if ($bitcount(byteBits) < ##class(MessagePack.Bytes).#BITSINBYTE) {
      set $bit(byteBits, ##class(MessagePack.Bytes).#BITSINBYTE) = 0
    }

    set bits = ##class(MessagePack.Bits).Join(bits, byteBits)
  }

  set maxBitsCount = ..GetMaxBitsCount(code)

  set maxExponentBitsCount = ..GetMaxExponentBitsCount(code)

  set exponent = 0

  for i=1:1:maxExponentBitsCount {
    set bitId = maxBitsCount - i

    set bit = $bit(bits, bitId)

    set coefficient = 2 ** (maxExponentBitsCount - i)

    set exponent = exponent + (coefficient * bit)
  }

  set exponentOffset = exponent - ..GetExponentNormalizer(code)

  set mantissa = 0

  set mantissaBitsCount = maxBitsCount - maxExponentBitsCount - 1

  for i=1:1:mantissaBitsCount {
    set bitId = maxBitsCount - maxExponentBitsCount - i

    set bit = $bit(bits, bitId)

    set coefficient = 2 ** (-i)

    set mantissa = mantissa + (coefficient * bit)
  }

  set sign = (-1) ** $bit(bits, maxBitsCount)

  return (sign * (1 + mantissa) * (2 ** exponentOffset))
}

/// Returns $$$YES if data
/// contains 0, or $$$NO
/// otherwise.
ClassMethod IsZero(data As %Binary) [ Private ]
{
  for i=2:1:$listlength(data) {
    if ($listget(data, i) '= 0) {
      return $$$NO
    }
  }

  return $$$YES
}

/// Returns type size in bits.
ClassMethod GetMaxBitsCount(code As %Integer) [ Private ]
{
  return $case(code, ..#CODEFLOAT: ..#BITSFLOAT, ..#CODEDOUBLE: ..#BITSDOUBLE)
}

/// Returns type exponent size in bits.
ClassMethod GetMaxExponentBitsCount(code As %Integer) [ Private ]
{
  return $case(code, ..#CODEFLOAT: ..#EXPONENTBITSFLOAT, ..#CODEDOUBLE: ..#EXPONENTBITSDOUBLE)
}

/// Returns type exponent normalizer.
ClassMethod GetExponentNormalizer(code As %Integer) [ Private ]
{
  return $case(code, ..#CODEFLOAT: ..#EXPONENTNORMALIZERFLOAT, ..#CODEDOUBLE: ..#EXPONENTNORMALIZERDOUBLE)
}

}

