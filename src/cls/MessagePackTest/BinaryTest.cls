Class MessagePackTest.BinaryTest Extends %UnitTest.TestCase
{

Parameter BINARY8 As %Integer = 255;

Parameter BINARY16 As %Integer = 65535;

Parameter BINARY32 As %Integer = 1048576;

Parameter CODEBINARY8 As %Integer = 196;

Parameter CODEBINARY16 As %Integer = 197;

Parameter CODEBINARY32 As %Integer = 198;

Method TestEncodeBinary8()
{
  do ..EncodeBinaryTest(..#BINARY8)
}

Method TestEncodeBinary16()
{
  do ..EncodeBinaryTest(..#BINARY16)
}

Method TestEncodeBinary32()
{
  do ..EncodeBinaryTest(..#BINARY32)
}

Method EncodeBinaryTest(length As %Integer) [ Private ]
{
  set value = ..GetBinary(length)

  set expectedData = ..GetDataBinary(length)

  set actualData = ##class(MessagePack.BinaryFormatter).Encode(value)

  do $$$AssertEquals(expectedData, actualData, ..GetBinaryTypeName(value)_" encodes correctly.")
}

Method TestDecodeBinary8()
{
  do ..DecodeBinaryTest(..#BINARY8)
}

Method TestDecodeBinary16()
{
  do ..DecodeBinaryTest(..#BINARY16)
}

Method TestDecodeBinary32()
{
  do ..DecodeBinaryTest(..#BINARY32)
}

Method DecodeBinaryTest(length As %Integer) [ Private ]
{
  set data = ..GetDataBinary(length)

  set expectedValue = ..GetBinary(length)

  set actualValue = ##class(MessagePack.BinaryFormatter).Decode(data)

  do $$$AssertEquals(expectedValue, actualValue, ..GetBinaryTypeName(expectedValue)_" decodes correctly.")
}

ClassMethod GetBinary(length As %Integer) [ Private ]
{
  set value = ""

  for i=1:1:length {
    set value = value _ $listbuild(0)
  }

  return value
}

ClassMethod GetDataBinary(length As %Integer) [ Private ]
{
  if (length <= ..#BINARY8) {
    set data = $listbuild(..#CODEBINARY8, length)
  }
  elseif (length <= ..#BINARY16) {
    set data = $listbuild(..#CODEBINARY16, length \ 256, length # 256)
  }
  else {
    set data = $listbuild(..#CODEBINARY32,
      length \ (256 ** 2) \ 256,
      length \ (256 ** 2) # 256,
      length # (256 ** 2) \ 256,
      length # (256 ** 2) # 256)
  }

  return data _ ..GetBinary(length)
}

ClassMethod GetBinaryTypeName(value As %Binary) [ Private ]
{
  set length = $listlength(value)

  if (length <= ..#BINARY8) {
    return "binary8"
  }
  elseif (length <= ..#BINARY16) {
    return "binary16"
  }

  return "binary32"
}

}

