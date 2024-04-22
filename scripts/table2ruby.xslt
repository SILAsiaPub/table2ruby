<?xml version="1.0" encoding="utf-8"?>
<!--
    #############################################################
    # Name:     	table2ruby.xslt
    # Purpose:  	Convert InDesign exported interlinear text into ruby.
    # Part of:  	Xrunner - https://github.com/SILAsiaPub/xrunner2
    # Author:   	Ian McQuay <ian_mcquay@sil.org>
    # Created:  	2024-04-19
    # Copyright:	(c) 2024 SIL International
    # Licence:  	<MIT>
    ################################################################ -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:f="myfunctions" exclude-result-prefixes="f">
    <xsl:output method="xml" version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
    <!-- <xsl:output method="text" encoding="utf-8" /> -->
    <xsl:include href="project.xslt"/>
    <xsl:include href="inc-copy-anything.xslt"/>
    <xsl:template match="*[local-name() = 'table']">
        <!-- Logic to determine table type -->
        <!-- <xsl:variable name="tblswitch" select="tokenize($tbltype,' ')"/> -->
        <xsl:apply-templates select="tbody"/>
    </xsl:template>
    <xsl:template match="tbody">
        <!-- <xsl:variable name="colcount" select="count(colgroup/col)"/> -->
        <xsl:variable name="trcount" select="count(tr)"/>
        <xsl:variable name="tdcount1" select="count(tr[1]/td)"/>
        <xsl:variable name="tdcount2" select="count(tr[2]/td)"/>
        <xsl:variable name="tdcount3" select="count(tr[3]/td)"/>
        <!-- <xsl:comment select="concat('$colcount = ',$colcount)"/> -->
         <!-- <xsl:comment select="concat('$trcount = ',$trcount)"/> -->
         <!-- <xsl:comment select="concat('$tdcount1 = ',$tdcount1)"/> -->
         <!-- <xsl:comment select="concat('$tdcount2 = ',$tdcount2)"/> -->
         <!-- <xsl:comment select="concat('$tdcount3 = ',$tdcount3)"/> -->
        <xsl:variable name="pattern">
            <xsl:choose>
                <xsl:when test="$trcount = 2">
                    <xsl:text>11</xsl:text>
                </xsl:when>
                <xsl:when test="$trcount = 3">
                    <xsl:choose>
                        <xsl:when test="matches(tr[1]/td[1]/b,'^\d+[a-j]?') or matches(tr[1]/td[1]/b,'^\d+$') or matches(tr[1]/td[1],'^\d+[a-j]?')">
                            <!-- This is a numbered sentence without translation -->
                            <xsl:text>011</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- This is an unnumbered sentence -->
                            <xsl:text>110</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$trcount = 4">
                    <!-- This is a numbered sentence with translation -->
                    <xsl:text>0110</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:comment select="'This table type is not handled by the transformation'"/>
                    <xsl:text>unknown</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:comment select="$pattern"/>
        <xsl:variable name="ruby2" select="tr[2]/td"/>
        <xsl:variable name="ruby3" select="tr[3]/td"/>
        <xsl:choose>
            <xsl:when test="$pattern = '11'">
                <xsl:element name="ruby">
                    <xsl:for-each select="tr[1]/td">
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:element name="rb">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                        <xsl:element name="rt">
                            <xsl:value-of select="normalize-space($ruby2[number($pos)])"/>
                        </xsl:element>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$pattern = '110'">
                <xsl:element name="ruby">
                    <xsl:for-each select="tr[1]/td">
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:element name="rb">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                        <xsl:element name="rt">
                            <xsl:value-of select="normalize-space($ruby2[number($pos)])"/>
                        </xsl:element>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:element>
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>free-translation</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="tr[last()]/td" mode="free"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$pattern = '011'">
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>vernexample</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="tr[1]/td" mode="sentpart"/>
                </xsl:element>
                <xsl:element name="ruby">
                    <xsl:for-each select="tr[2]/td">
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:element name="rb">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                        <xsl:element name="rt">
                            <xsl:value-of select="normalize-space($ruby3[number($pos)])"/>
                        </xsl:element>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$pattern = '0110'">
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>vernexample</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="tr[1]/td" mode="sentpart"/>
                </xsl:element>
                <xsl:element name="ruby">
                    <xsl:for-each select="tr[2]/td">
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:element name="rb">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:element>
                        <xsl:element name="rt">
                            <xsl:value-of select="normalize-space($ruby3[number($pos)])"/>
                        </xsl:element>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:element>
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:text>free-translation</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="tr[last()]/td" mode="free"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="parent::*"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="td" mode="free">
        <xsl:apply-templates select="node()"/>
    </xsl:template>
    <xsl:template match="td" mode="sentpart">
        <xsl:choose>
            <xsl:when test="position() = 1">
                <xsl:element name="div">
                    <xsl:attribute name="class">
                        <xsl:text>sentNo</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="node()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="colgroup|col"/>
</xsl:stylesheet>
