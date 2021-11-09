# MessagePack Encoder
## Prerequisites
This needs to have git and docker installed.
## Installation 
Clone/git pull the repo into any local directory
```
 git clone https://github.com/intersystems-community/msgpack.git
```
Open the terminal in this directory and run:
```
$ docker-compose build
```
Run the IRIS container with your project:
```
$ docker-compose up -d
```
## How to start coding
This repository is ready to code in VSCode with ObjectScript plugin.   
Install [VSCode](https://code.visualstudio.com/) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.   
Open /src/cls/MessagePack/??.cls class 
### Null Formatter
Serialize null to MessagePack binary data.
```
set data = ##class(MessagePack.NullFormatter).Encode()
>zw data
data = $lb(192)
```
### Boolean Formatter
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
### String Formatter
Serialize string to MessagePack binary data.
```
set data = ##class(MessagePack.StringFormatter).Encode("2017")
>zw data
data = $lb(164, 50, 48, 49, 55)
```
### Binary Formatter
Serialize binary to MessagePack binary data.
```
set data = ##class(MessagePack.BinaryFormatter).Encode($lb(2, 0, 1, 7))
>zw data
data = $lb(196, 4, 2, 0, 1, 7)
```
### Int Formatter
Serialize int ([int](https://github.com/msgpack/msgpack/blob/master/spec.md#int-format-family)) to MessagePack binary data.
```
set data = ##class(MessagePack.IntFormatter).Encode(2017)
>zw data
data = $lb(205, 7, 225)
```
### Float Formatter
Serialize float ([float](https://github.com/msgpack/msgpack/blob/master/spec.md#float-format-family)) to MessagePack binary data.
```
set data = ##class(MessagePack.FloatFormatter).EncodeFloat(20.17)
>zw data
data = $lb(202, 65, 161, 92, 40)
```
# How to Test it
Open IRIS terminal:
```
$ docker-compose exec iris iris session iris
USER>zwrite ##class(MessagePack.NullFormatter).Encode()    
$lb(192)

USER>set data=1 zwrite ##class(MessagePack.BooleanFormatter).Encode(''data)
$lb(195)

USER>set data=1 zwrite ##class(MessagePack.BooleanFormatter).Encode('data)
$lb(194)

USER>zwrite ##class(MessagePack.StringFormatter).Encode("2017")
$lb(164, 50, 48, 49, 55)

USER>zwrite ##class(MessagePack.BinaryFormatter).Encode($lb(2, 0, 1, 7))
$lb(196, 4, 2, 0, 1, 7)

USER>zwrite ##class(MessagePack.IntFormatter).Encode(2017)
$lb(205, 7, 225)

USER>zwrite ##class(MessagePack.FloatFormatter).EncodeFloat(20.17)
$lb(202, 65, 161, 92, 40)
```
