Class MessagePackTest.IntTest Extends %UnitTest.TestCase
{

Parameter TYPENAME As %String = "Int";

Parameter FIXPOSITIVE As %Integer = 127;

Parameter FIXNEGATIVE As %Integer = -32;

Parameter UINT8 As %Integer = 255;

Parameter UINT16 As %Integer = 65535;

Parameter UINT32 As %Integer = 4294967295;

Parameter UINT64 As %Integer = 4611686018427387904;

Parameter INT8 As %Integer = -127;

Parameter INT16 As %Integer = -32767;

Parameter INT32 As %Integer = -2147483647;

Parameter INT64 As %Integer = -4611686018427387903;

Parameter BYTE8 As %Integer = 256;

Parameter BYTE16 As %Integer = 65536;

Parameter BYTE32 As %Integer = 4294967296;

Parameter CODEUINT8 As %Integer = 204;

Parameter CODEUINT16 As %Integer = 205;

Parameter CODEUINT32 As %Integer = 206;

Parameter CODEUINT64 As %Integer = 207;

Parameter CODEINT8 As %Integer = 208;

Parameter CODEINT16 As %Integer = 209;

Parameter CODEINT32 As %Integer = 210;

Parameter CODEINT64 As %Integer = 211;

Method TestEncodeFixPositive()
{
  do ..EncodeInt(..#FIXPOSITIVE, ..GetDataFixPositive())
}

Method TestEncodeFixNegative()
{
  do ..EncodeInt(..#FIXNEGATIVE, ..GetDataFixNegative())
}

Method TestEncodeUINT8()
{
  do ..EncodeInt(..#UINT8, ..GetDataUINT8())
}

Method TestEncodeUINT16()
{
  do ..EncodeInt(..#UINT16, ..GetDataUINT16())
}

Method TestEncodeUINT32()
{
  do ..EncodeInt(..#UINT32, ..GetDataUINT32())
}

Method TestEncodeUINT64()
{
  do ..EncodeInt(..#UINT64, ..GetDataUINT64())
}

Method TestEncodeINT8()
{
  do ..EncodeInt(..#INT8, ..GetDataINT8())
}

Method TestEncodeINT16()
{
  do ..EncodeInt(..#INT16, ..GetDataINT16())
}

Method TestEncodeINT32()
{
  do ..EncodeInt(..#INT32, ..GetDataINT32())
}

Method TestEncodeINT64()
{
  do ..EncodeInt(..#INT64, ..GetDataINT64())
}

Method EncodeInt(value As %Integer, expectedData As %Binary) [ Private ]
{
  set actualData = ##class(MessagePack.IntFormatter).Encode(value)

  do $$$AssertEquals(expectedData, actualData, ..GetIntTypeName(value)_" encodes correctly.")
}

Method TestDecodeFixPositive()
{
  do ..DecodeInt(..GetDataFixPositive(), ..#FIXPOSITIVE)
}

Method TestDecodeFixNegative()
{
  do ..DecodeInt(..GetDataFixNegative(), ..#FIXNEGATIVE)
}

Method TestDecodeUINT8()
{
  do ..DecodeInt(..GetDataUINT8(), ..#UINT8)
}

Method TestDecodeUINT16()
{
  do ..DecodeInt(..GetDataUINT16(), ..#UINT16)
}

Method TestDecodeUINT32()
{
  do ..DecodeInt(..GetDataUINT32(), ..#UINT32)
}

Method TestDecodeUINT64()
{
  do ..DecodeInt(..GetDataUINT64(), ..#UINT64)
}

Method TestDecodeINT8()
{
  do ..DecodeInt(..GetDataINT8(), ..#INT8)
}

Method TestDecodeINT16()
{
  do ..DecodeInt(..GetDataINT16(), ..#INT16)
}

Method TestDecodeINT32()
{
  do ..DecodeInt(..GetDataINT32(), ..#INT32)
}

Method TestDecodeINT64()
{
  do ..DecodeInt(..GetDataINT64(), ..#INT64)
}

Method DecodeInt(data As %Binary, expectedValue As %Integer) [ Private ]
{
  set actualValue = ##class(MessagePack.IntFormatter).Decode(data)

  do $$$AssertEquals(expectedValue, actualValue, ..GetIntTypeName(expectedValue)_" decodes correctly.")
}

ClassMethod GetDataFixPositive() [ Private ]
{
  return $listbuild(..#FIXPOSITIVE)
}

ClassMethod GetDataFixNegative() [ Private ]
{
  return $listbuild(224)
}

ClassMethod GetDataUINT8() [ Private ]
{
  return $listbuild(..#CODEUINT8, ..#UINT8)
}

ClassMethod GetDataUINT16() [ Private ]
{
  return $listbuild(..#CODEUINT16,
    ..#UINT16 \ ..#BYTE8,
    ..#UINT16 # ..#BYTE8)
}

ClassMethod GetDataUINT32() [ Private ]
{
  return $listbuild(..#CODEUINT32,
    ..#UINT32 \ ..#BYTE16 \ ..#BYTE8,
    ..#UINT32 \ ..#BYTE16 # ..#BYTE8,
    ..#UINT32 # ..#BYTE16 \ ..#BYTE8,
    ..#UINT32 # ..#BYTE16 # ..#BYTE8)
}

ClassMethod GetDataUINT64() [ Private ]
{
  return $listbuild(..#CODEUINT64,
    ..#UINT64 \ ..#BYTE32 \ ..#BYTE16 \ ..#BYTE8,
    ..#UINT64 \ ..#BYTE32 \ ..#BYTE16 # ..#BYTE8,
    ..#UINT64 \ ..#BYTE32 # ..#BYTE16 \ ..#BYTE8,
    ..#UINT64 \ ..#BYTE32 # ..#BYTE16 # ..#BYTE8,
    ..#UINT64 # ..#BYTE32 \ ..#BYTE16 \ ..#BYTE8,
    ..#UINT64 # ..#BYTE32 \ ..#BYTE16 # ..#BYTE8,
    ..#UINT64 # ..#BYTE32 # ..#BYTE16 \ ..#BYTE8,
    ..#UINT64 # ..#BYTE32 # ..#BYTE16 # ..#BYTE8)
}

ClassMethod GetDataINT8() [ Private ]
{
  return $listbuild(..#CODEINT8, ..#BYTE8 + ..#INT8)
}

ClassMethod GetDataINT16() [ Private ]
{
  return $listbuild(..#CODEINT16, 128, 1)
}

ClassMethod GetDataINT32() [ Private ]
{
  return $listbuild(..#CODEINT32, 128, 0, 0, 1)
}

ClassMethod GetDataINT64() [ Private ]
{
  return $listbuild(..#CODEINT64, 192, 0, 0, 0, 0, 0, 0, 1)
}

ClassMethod GetIntTypeName(value As %Integer) [ Private ]
{
  if (0 <= value) {
    if (value <= ..#FIXPOSITIVE) {
      set subTypeName = "fix positive"
    }
    elseif (value <= ..#UINT8) {
      set subTypeName = "uint8"
    }
    elseif (value <= ..#UINT16) {
      set subTypeName = "uint16"
    }
    elseif (value <= ..#UINT32) {
      set subTypeName = "uint32"
    }
    else {
      set subTypeName = "uint64"
    }
  }
  else {
    if (value >= ..#FIXNEGATIVE) {
      set subTypeName = "fix negative"
    }
    elseif (value >= ..#INT8) {
      set subTypeName = "int8"
    }
    elseif (value >= ..#INT16) {
      set subTypeName = "int16"
    }
    elseif (value >= ..#INT32) {
      set subTypeName = "int32"
    }
    else {
      set subTypeName = "int64"
    }
  }

  return ..#TYPENAME_" ("_subTypeName_")"
}

}

