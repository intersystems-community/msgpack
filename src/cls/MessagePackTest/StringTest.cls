Class MessagePackTest.StringTest Extends %UnitTest.TestCase
{

Parameter FIXSTRING As %Integer = 31;

Parameter STRING8 As %Integer = 255;

Parameter STRING16 As %Integer = 65535;

Parameter STRING32 As %Integer = 1048576;

Parameter CODESTRING8 As %Integer = 217;

Parameter CODESTRING16 As %Integer = 218;

Parameter CODESTRING32 As %Integer = 219;

Method TestEncodeFixString()
{
  do ..EncodeStringTest(..#FIXSTRING, ..GetFixString(), ..GetDataFixString())
}

Method TestEncodeString8()
{
  do ..EncodeStringTest(..#STRING8)
}

Method TestEncodeString16()
{
  do ..EncodeStringTest(..#STRING16)
}

Method TestEncodeString32()
{
  do ..EncodeStringTest(..#STRING32)
}

Method EncodeStringTest(length As %Integer, value As %String = "", expectedData As %Binary = "") [ Private ]
{
  set value = $select(value = "": ..GetString(length), 1: value)

  set expectedData = $select(expectedData = "": ..GetDataString(length), 1: expectedData)

  set actualData = ##class(MessagePack.StringFormatter).Encode(value)

  do $$$AssertEquals(expectedData, actualData, ..GetStringTypeName(value)_" encodes correctly.")
}

Method TestDecodeFixString()
{
  do ..DecodeStringTest(..#FIXSTRING, ..GetDataFixString(), ..GetFixString())
}

Method TestDecodeString8()
{
  do ..DecodeStringTest(..#STRING8)
}

Method TestDecodeString16()
{
  do ..DecodeStringTest(..#STRING16)
}

Method TestDecodeString32()
{
  do ..DecodeStringTest(..#STRING32)
}

Method DecodeStringTest(length As %Integer, data As %Binary = "", expectedValue As %String = "") [ Private ]
{
  set data = $select(data = "": ..GetDataString(length), 1: data)

  set expectedValue = $select(expectedValue = "": ..GetString(length), 1: expectedValue)

  set actualValue = ##class(MessagePack.StringFormatter).Decode(data)

  do $$$AssertEquals(expectedValue, actualValue, ..GetStringTypeName(expectedValue)_" decodes correctly.")
}

ClassMethod GetFixString() [ Private ]
{
  return "MessagePack"
}

ClassMethod GetString(length As %Integer) [ Private ]
{
  set value = ""

  for i=1:1:length {
    set value = value _ " "
  }

  return value
}

ClassMethod GetDataFixString() [ Private ]
{
  return $listbuild(171, 77, 101, 115, 115, 97, 103, 101, 80, 97, 99, 107)
}

ClassMethod GetDataString(length As %Integer) [ Private ]
{
  if (length <= ..#STRING8) {
    set data = $listbuild(..#CODESTRING8, length)
  }
  elseif (length <= ..#STRING16) {
    set data = $listbuild(..#CODESTRING16, length \ 256, length # 256)
  }
  else {
    set data = $listbuild(..#CODESTRING32,
      length \ (256 ** 2) \ 256,
      length \ (256 ** 2) # 256,
      length # (256 ** 2) \ 256,
      length # (256 ** 2) # 256)
  }

  for i=1:1:length {
    set data = data _ $listbuild($ascii(" "))
  }

  return data
}

ClassMethod GetStringTypeName(value As %String) [ Private ]
{
  set length = $length(value)

  if (length <= ..#FIXSTRING) {
    return "fix string"
  }
  elseif (length <= ..#STRING8) {
    return "string8"
  }
  elseif (length <= ..#STRING16) {
    return "string16"
  }

  return "string32"
}

}

