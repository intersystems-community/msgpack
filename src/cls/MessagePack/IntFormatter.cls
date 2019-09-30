/// Formatter for %Integer.
/// Encodes/Decodes to/from MessagePack format.
Class MessagePack.IntFormatter
{

/// Value of positive fixnum.
Parameter FIXPOSITIVE As %Integer = 127;

/// Value of negaitve fixnum.
Parameter FIXNEGATIVE As %Integer = -32;

/// Upper bound of 8-bit uint.
Parameter UINT8 As %Integer = 256;

/// Upper bound of 16-bit uint.
Parameter UINT16 As %Integer = 65536;

/// Upper bound of 24-bit uint.
Parameter UINT24 As %Integer = 16777216;

/// Upper bound of 32-bit uint.
Parameter UINT32 As %Integer = 4294967296;

/// Lower bound of 8-bit int.
Parameter INT8 As %Integer = -127;

/// Lower bound of 16-bit int.
Parameter INT16 As %Integer = -32767;

/// Lower bound of 32-bit int.
Parameter INT32 As %Integer = -2147483647;

/// Code for 8-bit uint
/// in MessagePack specification.
Parameter CODEUINT8 As %Integer = 204;

/// Code for 16-bit uint
/// in MessagePack specification.
Parameter CODEUINT16 As %Integer = 205;

/// Code for 32-bit uint
/// in MessagePack specification.
Parameter CODEUINT32 As %Integer = 206;

/// Code for 64-bit uint
/// in MessagePack specification.
Parameter CODEUINT64 As %Integer = 207;

/// Code for 8-bit int
/// in MessagePack specification.
Parameter CODEINT8 As %Integer = 208;

/// Code for 16-bit int
/// in MessagePack specification.
Parameter CODEINT16 As %Integer = 209;

/// Code for 32-bit int
/// in MessagePack specification.
Parameter CODEINT32 As %Integer = 210;

/// Code for 64-bit int
/// in MessagePack specification.
Parameter CODEINT64 As %Integer = 211;

/// Encodes %Integer to MessagePack
/// format. Throws MessagePack.Encoding
/// exception if 'value' size if
/// not supported.
ClassMethod Encode(value As %Integer) As %Binary
{
  if (0 <= value) {
    if (value <= ..#FIXPOSITIVE) {
      return $listbuild(value)
    }

    if (value < ..#UINT8) {
      return ..EncodeUINT(value, ..#CODEUINT8, 1)
    }

    if (value < ..#UINT16) {
      return ..EncodeUINT(value, ..#CODEUINT16, 2)
    }

    if (value < ..#UINT32) {
      return ..EncodeUINT(value, ..#CODEUINT32, 4)
    }

    return ..EncodeUINT(value, ..#CODEUINT64, 8)
  }
  else {
    if (value >= ..#FIXNEGATIVE) {
      return $listbuild(..#UINT8 + value)
    }

    if (value >= ..#INT8) {
      return ..EncodeINT(value, ..#CODEINT8, 1)
    }

    if (value >= ..#INT16) {
      return ..EncodeINT(value, ..#CODEINT16, 2)
    }

    if (value >= ..#INT32) {
      return ..EncodeINT(value, ..#CODEINT32, 4)
    }

    return ..EncodeINT(value, ..#CODEINT64, 8)
  }

  throw ##class(%Exception.General).%New("MessagePack.Encoding",,,"Сannot be encoded.")
}

/// Encodes %Integer to MessagePack
/// format as unsigned.
ClassMethod EncodeUINT(value As %Integer, code As %Integer, bytesCount As %Integer) As %Binary [ Private ]
{
  for i=1:1:bytesCount {
    set $list(data, bytesCount - i + 2) = value # ..#UINT8

    set value = value \ ..#UINT8
  }

  set $list(data, 1) = code

  return data
}

/// Encodes %Integer to MessagePack
/// format as signed.
ClassMethod EncodeINT(value As %Integer, code As %Integer, bytesCount As %Integer) As %Binary [ Private ]
{
  set bits = $factor(value)

  set bitsCount = bytesCount * 8

  for i = 1:1:bitsCount {
    set $bit(bits, i) = $case($bit(bits, i), 0:1, 1:0)
  }

  set rest = 1

  for i = 1:1:bitsCount {
    set bit = $bit(bits, i) + rest

    set rest = bit \ 2

    set $bit(bits, i) = bit # 2
  }

  for byteIndex = 1:1:bytesCount {
    set value = 0

    for bitId = 0:1:7 {
      set bit = $bit(bits, bitId + (8 * (byteIndex - 1)) + 1)

      set value = value + ((2 ** bitId) * bit)
    }

    set $list(data, bytesCount - byteIndex + 2) = value
  }

  set $list(data, 1) = code

  return data
}

/// Decodes MessagePack to %Integer.
/// Throws MessagePack.Decoding exception
/// if decoding is failed.
ClassMethod Decode(data As %Binary)
{
  set firstByte = $listget(data)

  set firstByteBits = $factor(firstByte)

  if (firstByte = ..#CODEUINT8) {
    return ..DecodeUINT(data, 1)
  }

  if (firstByte = ..#CODEUINT16) {
    return ..DecodeUINT(data, 2)
  }

  if (firstByte = ..#CODEUINT32) {
    return ..DecodeUINT(data, 4)
  }

  if (firstByte = ..#CODEUINT64) {
    return ..DecodeUINT(data, 8)
  }

  if (firstByte = ..#CODEINT8) {
    return ..DecodeINT(data, 1)
  }

  if (firstByte = ..#CODEINT16) {
    return ..DecodeINT(data, 2)
  }

  if (firstByte = ..#CODEINT32) {
    return ..DecodeINT(data, 4)
  }

  if (firstByte = ..#CODEINT64) {
    return ..DecodeINT(data, 8)
  }

  if ($bit(firstByteBits, 8) = 0) {
    return firstByte
  }

  if (($bit(firstByteBits, 8) = 1) && ($bit(firstByteBits, 7) = 1) && ($bit(firstByteBits, 6) = 1)) {
    return (firstByte - 256)
  }

  throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Cannot be decoded.")
}

/// Decodes unsigned $Integer
/// from MessagePack. Throws 
/// MessagePack.Decoding exception
/// if decoding is failed.
ClassMethod DecodeUINT(data As %Binary, bytesCount As %Integer) [ Private ]
{
  set value = 0

  for i=1:1:bytesCount {
    set byte = $listget(data, 1 + i)

    if (byte = $$$NULLOREF) {
      throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Cannot be decoded.")
    }

    set value = value + (byte * (2 ** (8 * (bytesCount - i))))
  }

  return value
}

/// Decodes signed $Integer from 
/// MessagePack. Throws MessagePack.Decoding 
/// exception if decoding is failed.
ClassMethod DecodeINT(data As %Binary, bytesCount As %Integer) [ Private ]
{
  set bitsCount = 8 * bytesCount

  for byteIndex=1:1:bytesCount {
    set byte = $listget(data, byteIndex + 1)

    if (byte = $$$NULLOREF) {
      throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Cannot be decoded.")
    }

    set byteBits = $factor(byte)

    for bitId=1:1:8 {
      set $bit(bits, (bytesCount - byteIndex + 1) * 8 - bitId + 1) = $bit(byteBits, 8 - bitId + 1)
    }
  }

  set rest = 1

  for i=0:1:(bitsCount - 1) {
    if (rest '= 0) {
      set bit = $bit(bits, i + 1)

      set $bit(bits, i + 1) = $case(bit, 0:1, 1:0)

      set rest = $case(bit, 0:1, 1:0)
    }
  }

  for i=0:1:(bitsCount - 1) {
    set $bit(bits, i + 1) = $case($bit(bits, i + 1), 0:1, 1:0)
  }

  set value = 0

  for i=0:1:(bitsCount - 1) {
    set value = value + ($bit(bits, i + 1) * (2 ** i))
  }

  return (-value)
}

}

