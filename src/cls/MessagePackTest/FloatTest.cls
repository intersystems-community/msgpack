Class MessagePackTest.FloatTest Extends %UnitTest.TestCase
{

Parameter PRECISION As %Numeric = "1e-5";

Parameter ZERO As %Numeric = 0;

Parameter SMALL As %Numeric = 0.2017;

Parameter MEDIUM As %Numeric = 20.17;

Parameter LARGE As %Numeric = 201.7;

Parameter CODEFLOAT As %Integer = 202;

Parameter CODEDOUBLE As %Integer = 203;

Method TestEncodeFloatZero()
{
  do ..EncodeFloatTest(..#ZERO, ..GetDataZero(..#CODEFLOAT))
}

Method TestEncodeFloatSmall()
{
  do ..EncodeFloatTest(..#SMALL, ..GetDataFloatSmall())
}

Method TestEncodeFloatSmallNegative()
{
  do ..EncodeFloatTest(-..#SMALL, ..GetDataFloatSmallNegative())
}

Method TestEncodeFloatMedium()
{
  do ..EncodeFloatTest(..#MEDIUM, ..GetDataFloatMedium())
}

Method TestEncodeFloatMediumNegative()
{
  do ..EncodeFloatTest(-..#MEDIUM, ..GetDataFloatMediumNegative())
}

Method TestEncodeFloatLarge()
{
  do ..EncodeFloatTest(..#LARGE, ..GetDataFloatLarge())
}

Method TestEncodeFloatLargeNegative()
{
  do ..EncodeFloatTest(-..#LARGE, ..GetDataFloatLargeNegative())
}

Method EncodeFloatTest(value As %Numeric, expectedData As %Binary) [ Private ]
{
  set actualData = ##class(MessagePack.FloatFormatter).EncodeFloat(value)

  do $$$AssertEquals(expectedData, actualData, value_" encodes correctly.")
}

Method TestEncodeDoubleZero()
{
  do ..EncodeDoubleTest(..#ZERO, ..GetDataZero(..#CODEDOUBLE))
}

Method TestEncodeDoubleSmall()
{
  do ..EncodeDoubleTest(..#SMALL, ..GetDataDoubleSmall())
}

Method TestEncodeDoubleSmallNegative()
{
  do ..EncodeDoubleTest(-..#SMALL, ..GetDataDoubleSmallNegative())
}

Method TestEncodeDoubleMedium()
{
  do ..EncodeDoubleTest(..#MEDIUM, ..GetDataDoubleMedium())
}

Method TestEncodeDoubleMediumNegative()
{
  do ..EncodeDoubleTest(-..#MEDIUM, ..GetDataDoubleMediumNegative())
}

Method TestEncodeDoubleLarge()
{
  do ..EncodeDoubleTest(..#LARGE, ..GetDataDoubleLarge())
}

Method TestEncodeDoubleLargeNegative()
{
  do ..EncodeDoubleTest(-..#LARGE, ..GetDataDoubleLargeNegative())
}

Method EncodeDoubleTest(value As %Numeric, expectedData As %Binary) [ Private ]
{
  set actualData = ##class(MessagePack.FloatFormatter).EncodeDouble(value)

  do $$$AssertEquals(expectedData, actualData, value_" encodes correctly.")
}

Method TestDecodeFloatZero()
{
  do ..DecodeFloatTest(..GetDataZero(..#CODEFLOAT), ..#ZERO)
}

Method TestDecodeFloatSmall()
{
  do ..DecodeFloatTest(..GetDataFloatSmall(), ..#SMALL)
}

Method TestDecodeFloatSmallNegative()
{
  do ..DecodeFloatTest(..GetDataFloatSmallNegative(), -..#SMALL)
}

Method TestDecodeFloatMedium()
{
  do ..DecodeFloatTest(..GetDataFloatMedium(), ..#MEDIUM)
}

Method TestDecodeFloatMediumNegative()
{
  do ..DecodeFloatTest(..GetDataFloatMediumNegative(), -..#MEDIUM)
}

Method TestDecodeFloatLarge()
{
  do ..DecodeFloatTest(..GetDataFloatLarge(), ..#LARGE)
}

Method TestDecodeFloatLargeNegative()
{
  do ..DecodeFloatTest(..GetDataFloatLargeNegative(), -..#LARGE)
}

Method DecodeFloatTest(data As %Binary, expectedValue As %Numeric) [ Private ]
{
  set actualValue = ##class(MessagePack.FloatFormatter).Decode(data)

  do $$$AssertTrue($zabs(expectedValue - actualValue) < ..#PRECISION, expectedValue_" encodes correctly.")
}

Method TestDecodeDoubleZero()
{
  do ..DecodeDoubleTest(..GetDataZero(..#CODEDOUBLE), ..#ZERO)
}

Method TestDecodeDoubleSmall()
{
  do ..DecodeDoubleTest(..GetDataDoubleSmall(), ..#SMALL)
}

Method TestDecodeDoubleSmallNegative()
{
  do ..DecodeDoubleTest(..GetDataDoubleSmallNegative(), -..#SMALL)
}

Method TestDecodeDoubleMedium()
{
  do ..DecodeDoubleTest(..GetDataDoubleMedium(), ..#MEDIUM)
}

Method TestDecodeDoubleMediumNegative()
{
  do ..DecodeDoubleTest(..GetDataDoubleMediumNegative(), -..#MEDIUM)
}

Method TestDecodeDoubleLarge()
{
  do ..DecodeDoubleTest(..GetDataDoubleLarge(), ..#LARGE)
}

Method TestDecodeDoubleLargeNegative()
{
  do ..DecodeDoubleTest(..GetDataDoubleLargeNegative(), -..#LARGE)
}

Method DecodeDoubleTest(data As %Binary, expectedValue As %Numeric) [ Private ]
{
  set actualValue = ##class(MessagePack.FloatFormatter).Decode(data)

  do $$$AssertTrue($zabs(expectedValue - actualValue) < ..#PRECISION, expectedValue_" encodes correctly.")
}

ClassMethod GetDataZero(code As %Integer) [ Private ]
{
  set bytesCount = $case(code, ..#CODEFLOAT: 4, ..#CODEDOUBLE: 8)

  set data = $listbuild(code)

  for i=1:1:bytesCount {
    set data = data _ $listbuild(0)
  }

  return data
}

ClassMethod GetDataFloatSmall() [ Private ]
{
  return $listbuild(..#CODEFLOAT, 62, 78, 138, 113)
}

ClassMethod GetDataFloatSmallNegative() [ Private ]
{
  return $listupdate(..GetDataFloatSmall(), 2, 190)
}

ClassMethod GetDataFloatMedium() [ Private ]
{
  return $listbuild(..#CODEFLOAT, 65, 161, 92, 40)
}

ClassMethod GetDataFloatMediumNegative() [ Private ]
{
  return $listupdate(..GetDataFloatMedium(), 2, 193)
}

ClassMethod GetDataFloatLarge() [ Private ]
{
  return $listbuild(..#CODEFLOAT, 67, 73, 179, 51)
}

ClassMethod GetDataFloatLargeNegative() [ Private ]
{
  return $listupdate(..GetDataFloatLarge(), 2, 195)
}

ClassMethod GetDataDoubleSmall() [ Private ]
{
  return $listbuild(..#CODEDOUBLE, 63, 201, 209, 78, 59, 205, 53, 168)
}

ClassMethod GetDataDoubleSmallNegative() [ Private ]
{
  return $listupdate(..GetDataDoubleSmall(), 2, 191)
}

ClassMethod GetDataDoubleMedium() [ Private ]
{
  return $listbuild(..#CODEDOUBLE, 64, 52, 43, 133, 30, 184, 81, 235)
}

ClassMethod GetDataDoubleMediumNegative() [ Private ]
{
  return $listupdate(..GetDataDoubleMedium(), 2, 192)
}

ClassMethod GetDataDoubleLarge() [ Private ]
{
  return $listbuild(..#CODEDOUBLE, 64, 105, 54, 102, 102, 102, 102, 102)
}

ClassMethod GetDataDoubleLargeNegative() [ Private ]
{
  return $listupdate(..GetDataDoubleLarge(), 2, 192)
}

}

