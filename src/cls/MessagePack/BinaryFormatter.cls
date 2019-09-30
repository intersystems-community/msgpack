/// Formatter for %Binary lists.
/// Encodes/Decodes to/from MessagePack format.
Class MessagePack.BinaryFormatter
{

/// Upper bound of bin8 length.
Parameter BINARY8 As %Integer = 256;

/// Upper bound of bin16 length.
Parameter BINARY16 As %Integer = 65536;

/// Upper bound of bin32 length.
Parameter BINARY32 As %Integer = 4294967296;

/// Code for bin8 in 
/// MessagePack specification.
Parameter CODEBINARY8 As %Integer = 196;

/// Code for bin16 in 
/// MessagePack specification.
Parameter CODEBINARY16 As %Integer = 197;

/// Code for bin32 in 
/// MessagePack specification.
Parameter CODEBINARY32 As %Integer = 198;

/// Encodes %Binary list to MessagePack format.
/// Throws MessagePack.Encoding exception if
/// list length is not supported.
ClassMethod Encode(value As %Binary) As %Binary
{
  set length = $listlength(value)

  if (length < ..#BINARY8) {
    set data = $listbuild(..#CODEBINARY8) _ ..EncodeLength(length)
  }
  elseif (length < ..#BINARY16) {
    set data = $listbuild(..#CODEBINARY16) _ ..EncodeLength(length)
  }
  elseif (length < ..#BINARY32) {
    set data = $listbuild(..#CODEBINARY32) _ ..EncodeLength(length)
  }
  else {
    throw ##class(%Exception.General).%New("MessagePack.Encoding",,,"Cannot be encoded.")
  }

  set data = data _ value

  return data
}

/// Encodes list length to MessagePack 
/// representation.
ClassMethod EncodeLength(length As %Integer) [ Private ]
{
  set lengthBytesCount = ..GetLengthBytes(length)

  set data = ""

  for i=1:1:lengthBytesCount {
    set $list(data, lengthBytesCount - i + 1) = length # 256

    set length = length \ 256
  }

  return data
}

/// Decodes MessagePack to %Binary list.
/// Throws MessagePack.Decoding exception 
/// if decoding is failed.
ClassMethod Decode(data As %Binary)
{
  set firstByte = $listget(data)

  do ..CheckByte(firstByte)

  if (firstByte = ..#CODEBINARY8) {
    set lengthBytesCount = ..GetLengthBytes(..#BINARY8 - 1)
  }
  elseif (firstByte = ..#CODEBINARY16) {
    set lengthBytesCount = ..GetLengthBytes(..#BINARY16 - 1)
  }
  elseif (firstByte = ..#CODEBINARY32) {
    set lengthBytesCount = ..GetLengthBytes(..#BINARY32 - 1)
  }
  else {
    throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Cannot be decoded.")
  }

  set length = ..DecodeLength(data, lengthBytesCount)

  set offset = lengthBytesCount + 2

  return $list(data, offset, length + offset)
}

/// Decodes list length from MessagePack
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

/// Returns number of bytes which
/// represents 'length'.
ClassMethod GetLengthBytes(length As %Integer) [ Private ]
{
  if (length < ..#BINARY8) {
    return 1
  }
  elseif (length < ..#BINARY16) {
    return 2
  }

  return 4
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

