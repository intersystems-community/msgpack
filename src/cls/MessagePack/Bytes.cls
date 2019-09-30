/// Parsing values to bytes list.
Class MessagePack.Bytes
{

/// Number of bits per byte.
Parameter BITSINBYTE As %Integer = 8;

/// Parses value to bytes list.
ClassMethod Get(bits) As %Binary
{
  set bitsCount = $bitcount(bits)

  set bytesCount = bitsCount / ..#BITSINBYTE

  set bytes = ""

  for byteIndex=1:1:bytesCount {
    set bytePosition = ..#BITSINBYTE * (bytesCount - byteIndex + 1)

    set byte = ..GetOne(bits, bytePosition)

    set bytes = bytes _ $listbuild(byte)
  }

  return bytes
}

/// Returns a byte from bits set, 
/// starting at specified position.
ClassMethod GetOne(bits, position As %Integer) As %Integer [ Private ]
{
  set byte = 0

  for i=1:1:..#BITSINBYTE {
    set bit = $bit(bits, position - i + 1)

    set coefficient = 2 ** (..#BITSINBYTE - i)

    set byte = byte + (coefficient * bit)
  }

  return byte
}

}

