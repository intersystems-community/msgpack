/// Formatter for %String.
/// Encodes/Decodes to/from MessagePack format.
Class MessagePack.StringFormatter
{

/// Max length of fixstr.
Parameter FIXSTRING As %Integer = 31;

/// Upper bound of 
/// str8 length.
Parameter STRING8 As %Integer = 256;

/// Upper bound of 
/// str16 length.
Parameter STRING16 As %Integer = 65536;

/// Upper bound of 
/// str32 length.
Parameter STRING32 As %Integer = 4294967296;

/// Code for fixstr
/// in MessagePack specification.
Parameter CODEFIXSTRING As %Integer = 160;

/// Code for str-8
/// in MessagePack specification.
Parameter CODESTRING8 As %Integer = 217;

/// Code for str-16
/// in MessagePack specification.
Parameter CODESTRING16 As %Integer = 218;

/// Code for str-32
/// in MessagePack specification.
Parameter CODESTRING32 As %Integer = 219;

/// Encodes %String to MessagePack format.
/// Throws MessagePack.Encoding exception if
/// string length is not supported.
ClassMethod Encode(value As %String) As %Binary
{
  set length = $length(value)

  if (length <= ..#FIXSTRING) {
    set data = $listbuild(..#CODEFIXSTRING + length)
  }
  elseif (length < ..#STRING8) {
    set data = $listbuild(..#CODESTRING8) _ ..EncodeLength(length, 1)
  }
  elseif (length < ..#STRING16) {
    set data = $listbuild(..#CODESTRING16) _ ..EncodeLength(length, 2)
  }
  elseif (length < ..#STRING32) {
    set data = $listbuild(..#CODESTRING32) _ ..EncodeLength(length, 4)
  }
  else {
    throw ##class(%Exception.General).%New("MessagePack.Encoding",,,"Cannot be encoded.")
  }

  for i=1:1:length {
    set data = data _ $listbuild($ascii($extract(value, i)))
  }

  return data
}

/// Encodes string length to MessagePack 
/// representation.
ClassMethod EncodeLength(length As %Integer, lengthBytesCount As %Integer) [ Private ]
{
  set data = ""

  for i=1:1:lengthBytesCount {
    set $list(data, lengthBytesCount - i + 1) = length # 256

    set length = length \ 256
  }

  return data
}

/// Decodes MessagePack to %String.
/// Throws MessagePack.Decoding exception 
/// if decoding is failed.
ClassMethod Decode(data As %Binary)
{
  set firstByte = $listget(data)

  do ..CheckByte(firstByte)

  if ((..#CODEFIXSTRING <= firstByte) && (firstByte <= (..#CODEFIXSTRING + ..#FIXSTRING))) {
    set length = firstByte - ..#CODEFIXSTRING

    set offset = 1
  }
  elseif (firstByte = ..#CODESTRING8) {
    set length = ..DecodeLength(data, 1)

    set offset = 2
  }
  elseif (firstByte = ..#CODESTRING16) {
    set length = ..DecodeLength(data, 2)

    set offset = 3
  }
  elseif (firstByte = ..#CODESTRING32) {
    set length = ..DecodeLength(data, 4)

    set offset = 5
  } else {
    throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Cannot be decoded.")
  }

  set value = ""

  set byteId = 1

  set bytePointer = 0

  while $listnext(data, bytePointer, byte) {
    do ..CheckByte(byte)

    if (byteId > offset) {
      set value = value _ $char(byte)
    }

    set byteId = byteId + 1
  }

  return value
}

/// Decodes string length from MessagePack
/// representation.
ClassMethod DecodeLength(data As %Binary, lengthBytesCount As %Integer) [ Private ]
{
  set length = 0

  for i=1:1:lengthBytesCount {
    set lengthByte = $listget(data, i + 1)

    do ..CheckByte(lengthByte)

    set length = length + (lengthByte * (256 ** (lengthBytesCount - i)))
  }

  return length
}

/// Throws MessagePack.Decoding exception 
/// if byte is empty.
ClassMethod CheckByte(byte As %Integer) [ Private ]
{
  if (byte = "") {
    throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Cannot be decoded.")
  }
}

}

