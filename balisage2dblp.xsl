<?xml version="1.0" encoding="UTF-8"?>
<!-- This is free software released into the public domain (CC0 license). -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:h="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="xs"
	version="2.0">

	<xsl:output method="text"/>

	<xsl:variable name="eol" xml:space="preserve">&#10;</xsl:variable>
	<xsl:variable name="space" xml:space="preserve">&#32;</xsl:variable>

	<xsl:variable name="long-title">
		<xsl:value-of select="normalize-space((//h:p[@class='title'])[1])"/>
	</xsl:variable>

	<xsl:variable name="symposium-title">
		<xsl:if test="contains($long-title, 'Symposium')">
			<xsl:text>symposium</xsl:text>
		</xsl:if>
	</xsl:variable>

	<xsl:variable name="conf-place">
		<xsl:value-of select="//h:p[@class='notice' and starts-with(., 'Montr')]"/>
	</xsl:variable>

	<xsl:variable name="conf-date">
		<xsl:value-of select="//h:p[@class='notice' and starts-with(., 'August')]"/>
	</xsl:variable>

	<xsl:variable name="year">
		<xsl:value-of select="substring-after($conf-date, ', ')"/>
	</xsl:variable>

	<xsl:template match="/h:html">
		<xsl:call-template name="publication-id"/>

		<xsl:value-of select="$eol"/>

		<xsl:call-template name="procedings-headers"/>

		<xsl:value-of select="$eol"/>

		<xsl:call-template name="element">
			<xsl:with-param name="tag">ul</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:apply-templates select="//h:p[@class='bibliomixed']"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="publication-id">
		<xsl:text>conf/balisage/balisage</xsl:text>
		<xsl:value-of select="$symposium-title"/>
		<xsl:value-of select="$year"/>
		<xsl:value-of select="$eol"/>
	</xsl:template>

	<xsl:template name="procedings-headers">
		<!-- editors -->

		<!-- volume name -->
		<xsl:value-of select="$long-title"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="$conf-place"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="replace($conf-date, ' - ', '-')"/>
		<xsl:value-of select="$eol"/>

		<!-- conference name -->
		<xsl:text>Balisage</xsl:text>
		<xsl:value-of select="$eol"/>

		<!-- volume -->
		<xsl:value-of select="string-join(//h:div[@class='mast-box']//h:small/descendant-or-self::text(), '')"/>
		<xsl:value-of select="$eol"/>

		<!-- year -->
		<xsl:value-of select="$year"/>
		<xsl:value-of select="$eol"/>

		<!-- isbn (issn?) -->
		<xsl:value-of select="substring-after(//h:p[@class='notice' and starts-with(., 'ISBN-13')], 'ISBN-13 ')"/>
		<xsl:value-of select="$eol"/>

		<!-- publisher -->
		<xsl:value-of select="$eol"/>
	</xsl:template>

	<xsl:template match="h:p[@class='bibliomixed']">
		<xsl:value-of select="$eol"/>

		<xsl:call-template name="element">
			<xsl:with-param name="tag">li</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="article-authors"/>
				<xsl:value-of select="$eol"/>

				<xsl:call-template name="article-title"/>
				<xsl:value-of select="$eol"/>

				<!-- page numbers, special null value for electronic-only publications -->
				<xsl:text>0-</xsl:text>
				<xsl:value-of select="$eol"/>

				<xsl:call-template name="article-doi"/>
				<xsl:value-of select="$eol"/>
			</xsl:with-param>
		</xsl:call-template>

		<xsl:value-of select="$eol"/>
	</xsl:template>
	
	<xsl:template name="article-authors">
		<xsl:variable name="raw-authors" select="normalize-space(./text()[1])"/>
		<xsl:variable name="raw-authors2" select="replace(replace($raw-authors, ', and', ','), ' and', ',')"/>
		<xsl:variable name="raw-authors3" select="replace($raw-authors2, '\.', '')"/>
		<xsl:variable name="raw-authors4" select="tokenize($raw-authors3, ', ')"/>

		<xsl:value-of select="$raw-authors4[2]"/>
		<xsl:value-of select="$space"/>
		<xsl:value-of select="$raw-authors4[1]"/>

		<xsl:for-each select="$raw-authors4[position() > 2]">
			<xsl:text>,</xsl:text>
			<xsl:value-of select="$eol"/>
			<xsl:value-of select="."/>
		</xsl:for-each>
		
		<xsl:text>:</xsl:text>
	</xsl:template>

	<xsl:template name="article-title">
		<xsl:variable name="raw-title" select="./h:a/text()"/>
		<xsl:variable name="clean-title" select="substring-after(substring-before($raw-title, '”'), '“')"/>
		<xsl:value-of select="normalize-space($clean-title)"/>
	</xsl:template>

	<xsl:template name="article-doi">
		<xsl:call-template name="element">
			<xsl:with-param name="tag">ee</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:text>http://dx.doi.org/</xsl:text>
				<xsl:value-of select="./h:span[@class='doi']"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="element">
		<xsl:param name="tag"/>
		<xsl:param name="value"/>

		<xsl:text>&lt;</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;</xsl:text>

		<xsl:value-of select="$value"/>

		<xsl:text>&lt;/</xsl:text>
		<xsl:value-of select="$tag"/>
		<xsl:text>&gt;</xsl:text>
	</xsl:template>
</xsl:stylesheet>
