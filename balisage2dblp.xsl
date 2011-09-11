<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">

	<xsl:output method="text"/>
	
	<xsl:variable name="eol" xml:space="preserve">&#10;</xsl:variable>
	<xsl:variable name="space" xml:space="preserve">&#32;</xsl:variable>

	<xsl:variable name="year">
		<xsl:value-of select="substring-after((//p[@class='title'])[1], 'Conference ')"/>			
	</xsl:variable>

	<xsl:template match="/html">
		<xsl:call-template name="publication-id"/>
		
		<xsl:value-of select="$eol"/>
		
		<xsl:call-template name="procedings-headers"/>
		
		<xsl:value-of select="$eol"/>
		
		<xsl:call-template name="element">
			<xsl:with-param name="tag">ul</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:apply-templates select="//p[@class='bibliomixed']"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template name="publication-id">
		<xsl:text>conf/balisage/balisage</xsl:text>
		<xsl:value-of select="$year"/>
		<xsl:value-of select="$eol"/>
	</xsl:template>
	
	<xsl:template name="procedings-headers">
		<!-- editors -->
		
		<!-- volume name -->
		<xsl:value-of select="(//p[@class='title'])[1]"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="(//p[@class='notice'])[6]"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="replace((//p[@class='notice'])[7], ' - ', '-')"/>
		<xsl:value-of select="$eol"/>
		
		<!-- conference name -->
		<xsl:text>Balisage</xsl:text>
		<xsl:value-of select="$eol"/>
		
		<!-- volume -->
		<xsl:value-of select="string-join(//div[@class='mast-box']//small/descendant-or-self::text(), '')"/>
		<xsl:value-of select="$eol"/>
		
		<!-- year -->
		<xsl:value-of select="$year"/>
		<xsl:value-of select="$eol"/>
		
		<!-- isbn (issn?) -->
		<xsl:value-of select="substring-after(//p[@class='notice' and starts-with(., 'ISBN')], 'ISBN-13 ')"/>
		<xsl:value-of select="$eol"/>
		
		<!-- publisher -->
		<xsl:value-of select="$eol"/>
	</xsl:template>
	
	<xsl:template match="p[@class='bibliomixed']">
		<xsl:value-of select="$eol"/>
		
		<xsl:call-template name="element">
			<xsl:with-param name="tag">li</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="article-authors"/>
				<xsl:value-of select="$eol"/>
				
				<xsl:call-template name="article-title"/>
				<xsl:value-of select="$eol"/>
				
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
		<xsl:variable name="raw-title" select="./a/text()"/>
		<xsl:value-of select="substring-after(substring-before($raw-title, '”'), '“')"/>
	</xsl:template>
	
	<xsl:template name="article-doi">
		<xsl:call-template name="element">
			<xsl:with-param name="tag">ee</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:text>http://dx.doi.org/</xsl:text>
				<xsl:value-of select="./span[@class='doi']"/>
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
