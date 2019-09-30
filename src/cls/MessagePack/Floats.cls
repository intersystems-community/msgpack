/// Extracting floor and entier parts
/// from float values.
/// Checking for floor part.
Class MessagePack.Floats
{

/// Code for entier part.
Parameter PARTENTIER As %Integer = 1;

/// Code for floor part.
Parameter PARTFLOOR As %Integer = 2;

/// Returns $$$NO if value has
/// a floor and $YES otherwise.
ClassMethod IsInteger(value As %Numeric)
{
  return ($find(value, ..GetSeparator()) = 0)
}

/// Returns entier part of value.
ClassMethod GetEntier(value As %Numeric)
{
  return $zabs(..ExtractPart(value, ..#PARTENTIER))
}

/// Returns floor part of value in fractional from.
ClassMethod GetFloor(value As %Numeric)
{
  return +("0" _ ..GetSeparator() _ ..ExtractPart(value, ..#PARTFLOOR))
}

/// Extracts a entier/floor part of decimal value.
ClassMethod ExtractPart(value As %Numeric, partId As %Integer) [ Private ]
{
  return $piece(value, ..GetSeparator(), partId)
}

/// Returns a separator for decimal numbers (".").
ClassMethod GetSeparator() As %String [ Private ]
{
  return ##class(%SYS.NLS.Format).GetFormatItem("DecimalSeparator")
}

}

