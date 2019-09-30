Include %outUnitTest

Class MessagePackTest.BooleanTest Extends %UnitTest.TestCase
{

Parameter TYPENAME As %String = "Boolean";

Method TestEncodeBooleanTrue()
{
  do ..EncodeBooleanTest($$$YES)
}

Method TestEncodeBooleanFalse()
{
  do ..EncodeBooleanTest($$$NO)
}

Method EncodeBooleanTest(value As %Boolean) [ Private ]
{
  set expectedData = ..GetData(value)

  set actualData = ##class(MessagePack.BooleanFormatter).Encode(value)

  do $$$AssertEquals(expectedData, actualData, ..GetBooleanTypeName(value) _ " encodes correctly.")
}

Method TestDecodeBooleanTrue()
{
  do ..DecodeBooleanTest($$$YES)
}

Method TestDecodeBooleanFalse()
{
  do ..DecodeBooleanTest($$$NO)
}

Method DecodeBooleanTest(value As %Boolean) [ Private ]
{
  set expectedValue = value

  set actualValue = ##class(MessagePack.BooleanFormatter).Decode(..GetData(value))

  do $$$AssertEquals(expectedValue, actualValue, ..GetBooleanTypeName(value) _ " decodes correctly.")
}

Method TestDecodeThrowsExceptionWhenNotSuitableCode()
{
  try {
    do ##class(MessagePack.NullFormatter).Decode($listbuild(0))

    do $$$AssertFailure(..#TYPENAME_" decodes unsuitable code without a problem.")
  } catch e {
    do $$$AssertSuccess(..#TYPENAME_" decodes unsuitable code correctly.")
  }
}

ClassMethod GetBooleanTypeName(value As %Boolean) [ Private ]
{
  return ..#TYPENAME_" ("_$case(value, $$$NO:"false", :"true")_")"
}

ClassMethod GetData(value As %Boolean) [ Private ]
{
  return $listbuild($case(value, $$$NO:194, :195))
}

}

