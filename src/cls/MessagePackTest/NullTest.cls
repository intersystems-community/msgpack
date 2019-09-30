Include %outUnitTest

Class MessagePackTest.NullTest Extends %UnitTest.TestCase
{

Method TestEncode()
{
  set expectedData = ..GetData()

  set actualData = ##class(MessagePack.NullFormatter).Encode()

  do $$$AssertEquals(expectedData, actualData, "Null encodes correctly.")
}

Method TestDecode() {
  set expectedValue = $$$NULLOREF

  set actualValue = ##class(MessagePack.NullFormatter).Decode(..GetData())

  do $$$AssertEquals(expectedValue, actualValue, "Null decodes correctly.")
}

Method TestDecodeThrowsExceptionWhenNotSuitableCode() {
  try {
    do ##class(MessagePack.NullFormatter).Decode($lb(0))

    do $$$AssertFailure("Null decodes unsuitable code without a problem.")
  } catch e {
    do $$$AssertSuccess("Null decodes unsuitable code correctly.")
  }
}

ClassMethod GetData() {
  return $listbuild(192)
}

}

