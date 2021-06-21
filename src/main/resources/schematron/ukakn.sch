<?xml version="1.0" encoding="UTF-8" ?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:akn="http://docs.oasis-open.org/legaldocml/ns/akn/3.0"
	xmlns:uk="https://www.legislation.gov.uk/namespaces/UK-AKN">

<ns prefix="akn" uri="http://docs.oasis-open.org/legaldocml/ns/akn/3.0" />
<ns prefix="uk" uri="https://www.legislation.gov.uk/namespaces/UK-AKN" />

<xsl:key name="eId" match="*[exists(@eId)]" use="@eId" />
<xsl:key name="guid" match="*[exists(@GUID)]" use="@GUID" />

<pattern>
	<rule context="akn:FRBRdate[@date castable as xs:date] | akn:docDate[@date castable as xs:date]">
		<let name="date" value="xs:date(@date)" />
		<assert test="$date le current-date()">This date is in the future.</assert>
	</rule>
	<rule context="akn:FRBRdate[@date castable as xs:dateTime] | akn:docDate[@date castable as xs:dateTime]">
		<let name="date" value="xs:dateTime(@date)" />
		<assert test="$date lt current-dateTime()">This date is in the future.</assert>
	</rule>
</pattern>

<pattern>
	<rule context="*">
		<assert test="empty(@eId) or count(key('eId', @eId)) eq 1">The @eId "<value-of select="@eId"/>" is not unique</assert>
		<assert test="empty(@GUID) or count(key('guid', @GUID)) eq 1">The @GUID "<value-of select="@GUID"/>" is not unique</assert>
	</rule>
</pattern>

<pattern>
	<rule context="akn:ref[starts-with(@href, '#')]">
		<let name="id" value="substring(@href, 2)" />
		<assert test="exists(key('eId', $id))">No element with @eId "<value-of select="$id"/>" exists in this document</assert>
	</rule>
</pattern>

</schema>
