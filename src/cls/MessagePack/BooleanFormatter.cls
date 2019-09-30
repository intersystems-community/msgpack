/// Formatter for %Boolean values.
/// Encodes/Decodes to/from MessagePack format.
Class MessagePack.BooleanFormatter
{

/// Code of true in MessagePack specification.
Parameter CODETRUE As %Integer = 195;

/// Code of false in MessagePack specification.
Parameter CODEFALSE As %Integer = 194;

/// Encodes %Boolean value to MessagePack format.
ClassMethod Encode(value As %Boolean) As %Binary
{
  return $listbuild($case(value, $$$NO:..#CODEFALSE, :..#CODETRUE))
}

/// Decodes MessagePack to %Boolean value.
/// Throws MessagePack.Decoding exception if decoding is failed.
ClassMethod Decode(data As %Binary)
{
  set firstByte = $listget(data)

  if ((firstByte = ..#CODEFALSE) || (firstByte = ..#CODETRUE)) {
    return $case(firstByte, ..#CODEFALSE:$$$NO, :$$$YES)
  }

  throw ##class(%Exception.General).%New("MessagePack.Decoding",,,"Unsuitable code.")
}

}
