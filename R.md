# Null Formatter

Serialize null to MessagePack binary data.

```
set data = ##class(MessagePack.NullFormatter).Encode()

>zw data
data = $lb(192)
```

# Boolean Formatter

Serialize boolean (true) to MessagePack binary data.

```
set data = ##class(MessagePack.BooleanFormatter).Encode($$$YES)

>zw data
data = $lb(195)
```

Serialize boolean (false) to MessagePack binary data.

```
set data = ##class(MessagePack.BooleanFormatter).Encode($$$NO)

>zw data
data = $lb(194)
```

# String Formatter

Serialize string to MessagePack binary data.

```
set data = ##class(MessagePack.StringFormatter).Encode("2017")

>zw data
data = $lb(164, 50, 48, 49, 55)
```

# Binary Formatter

Serialize binary to MessagePack binary data.

```
set data = ##class(MessagePack.BinaryFormatter).Encode($lb(2, 0, 1, 7))

>zw data
data = $lb(196, 4, 2, 0, 1, 7)
```

# Int Formatter

Serialize int ([int](https://github.com/msgpack/msgpack/blob/master/spec.md#int-format-family)) to MessagePack binary data.

```
set data = ##class(MessagePack.IntFormatter).Encode(2017)

>zw data
data = $lb(205, 7, 225)
```

# Float Formatter

Serialize float ([float](https://github.com/msgpack/msgpack/blob/master/spec.md#float-format-family)) to MessagePack binary data.

```
set data = ##class(MessagePack.FloatFormatter).EncodeFloat(20.17)

>zw data
data = $lb(202, 65, 161, 92, 40)
```