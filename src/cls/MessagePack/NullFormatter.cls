/// Formatter for $$$NULLOREF.
/// Encodes/Decodes to/from MessagePack format.
Class MessagePack.NullFormatter
{

/// Code of null in MessagePack specification.
Parameter CODE As %Integer = 192;

/// Encodes $$$NULLOREF to MessagePack format.
ClassMethod Encode() As %Binary
{
  return $listbuild(..#CODE)
}

/// Decodes MessagePack to $$$NULLOREF.
/// Throws MessagePack.Decoding exception if decoding is failed.
ClassMethod Decode(data As %Binary)
{
  if ($listget(data) = ..#CODE) {
    return $$$NULLOREF
  }

  throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Unsuitable code.")
}

}
