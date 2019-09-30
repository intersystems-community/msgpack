/// Concatenation of bits.
/// Extracting first bits of decimal 
/// numbers.
Class MessagePack.Bits
{

/// Returns a result of concatenation 
/// 'bits2' and 'bits1' bits.
ClassMethod Join(bits1, bits2)
{
  set bitId = 1

  for i=1:1:$bitcount(bits2) {
    set $bit(bits, bitId) = $bit(bits2, i)

    set bitId = bitId + 1
  }

  for i=1:1:$bitcount(bits1) {
    set $bit(bits, bitId) = $bit(bits1, i)

    set bitId = bitId + 1
  }

  return bits
}

/// Returns first 'bitsCountMax' bits of value.
ClassMethod Get(value As %Numeric, bitsCountMax As %Integer)
{
  if (##class(MessagePack.Floats).IsInteger(value)) {
    return ..GetFromEntier(value, bitsCountMax)
  } else {
    return ..GetFromFloor(value, bitsCountMax)
  }
}

/// Returns first 'bitsCountMax' bits of entier
/// part of value.
ClassMethod GetFromEntier(value As %Numeric, bitsCountMax As %Integer) [ Private ]
{
  set bitId = 1

  do {
    set $bit(bits, bitId) = value # 2

    set value = value \ 2

    set bitId = bitId + 1
  } while ((value > 0) && (bitId <= bitsCountMax))

  return bits
}

/// Returns first 'bitsCountMax' bits 
/// of value with floor part.
ClassMethod GetFromFloor(value As %Numeric, bitsCountMax As %Integer) [ Private ]
{
  for bitId=1:1:bitsCountMax {
    set entier = ##class(MessagePack.Floats).GetEntier(value * 2)

    set value = ##class(MessagePack.Floats).GetFloor(value * 2)

    set $bit(bits, bitId) = $select(entier = "": 0, 1: entier)

    if (value = 0) {
      quit
    }
  }

  return ..Reverse(bits)
}

/// Reverses a bits sequence.
ClassMethod Reverse(bits) [ Private ]
{
  set bitsCount = $bitcount(bits)

  for bitId=1:1:(bitsCount/2) {
    set bit = $bit(bits, bitsCount - bitId + 1)

    set $bit(bits, bitsCount - bitId + 1) = $bit(bits, bitId)

    set $bit(bits, bitId) = bit
  }

  return bits
}

}

