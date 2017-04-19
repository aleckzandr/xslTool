<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" exclude-result-prefixes="ma xsl"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ma="http://aleckzandr.com"
	extension-element-prefixes="ma">

	<ma:printpdf>0</ma:printpdf>
	<ma:showvalidatorlink>1</ma:showvalidatorlink>
	<ma:resumelink>sample.xml</ma:resumelink>
	<ma:xsllink>https://github.com/aleckzandr/xslTool/blob/master/resume.xsl</ma:xsllink>
	<ma:codelink>https://github.com/aleckzandr/xslTool/blob/master/xsl.cs</ma:codelink>

	<ma:name monInt= "1">Jan.</ma:name>
	<ma:name monInt= "2">Feb.</ma:name>
	<ma:name monInt= "3">Mar.</ma:name>
	<ma:name monInt= "4">Apr.</ma:name>
	<ma:name monInt= "5">May</ma:name>
	<ma:name monInt= "6">June</ma:name>
	<ma:name monInt= "7">Jul.</ma:name>
	<ma:name monInt= "8">Aug.</ma:name>
	<ma:name monInt= "9">Sep.</ma:name>
	<ma:name monInt="10">Oct.</ma:name>
	<ma:name monInt="11">Nov.</ma:name>
	<ma:name monInt="12">Dec.</ma:name>
	
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes"
		encoding="utf-8"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		doctype-public="-//W3C//DTD XHTML 1.1//EN"
		doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" />

	<xsl:template match="/resume">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<xsl:call-template name="head" />
			<body>
				<div class="main">
					<xsl:apply-templates select="personal" />
					<xsl:apply-templates select="objective" />
					<xsl:apply-templates select="employment_history" />
					<xsl:apply-templates select="education" />
					<xsl:apply-templates select="organizations" />
					<xsl:apply-templates select="hobbies" />
					<xsl:apply-templates select="github" />
					<xsl:apply-templates select="references" />
					<xsl:if test="document('')/*/ma:printpdf = '0'">
						<p class="idn">(<a><xsl:attribute name="href">javascript:onClick=displayDiv("ref");</xsl:attribute>view/hide References</a>, <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
							<xsl:if test="document('')/*/ma:resumelink != ''">
								<a><xsl:attribute name="href"><xsl:value-of select="document('')/*/ma:resumelink"/></xsl:attribute>view XML</a>, <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
							</xsl:if>
							<a><xsl:attribute name="href"><xsl:value-of select="document('')/*/ma:xsllink"/></xsl:attribute>view XSL</a>, <xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
							<a><xsl:attribute name="href"><xsl:value-of select="document('')/*/ma:codelink"/></xsl:attribute>view C# Code to do XSL transform</a>)</p>
							<xsl:if test="document('')/*/ma:showvalidatorlink = '1'">
								<div>
									<a href="https://validator.w3.org/#validate_by_upload">
										<img src="http://www.w3.org/Icons/valid-xhtml11" alt="Valid XHTML 1.1" height="31" width="88" />
									</a>
								</div>
								<!--http://validator.w3.org/check?uri=referer-->
							</xsl:if>
					</xsl:if>
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="makeUpperCase">
		<xsl:param name="str" />
		<xsl:value-of select="translate($str,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
	</xsl:template>

	<xsl:template name="displayTabularData">
		<xsl:param name="str" />
		<div class="div-cont" xmlns="http://www.w3.org/1999/xhtml">
			<div class="div-row">
				<div class="div-cel date">
					<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
				</div>
				<div class="div-cel cont">
					<xsl:value-of select="$str" />
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="head">
		<head xmlns="http://www.w3.org/1999/xhtml">
			<title>R<xsl:text disable-output-escaping="yes">&amp;</xsl:text>#233;sum<xsl:text disable-output-escaping="yes">&amp;</xsl:text>#233; of <xsl:value-of select="personal/name" /></title>
			<meta>
				<xsl:attribute name="http-equiv">Content-Type</xsl:attribute>
				<xsl:attribute name="content">text/html; charset=utf-8</xsl:attribute>
			</meta>
			<script>
				<xsl:attribute name="type">text/javascript</xsl:attribute>
				<xsl:comment><![CDATA[
				var divDisplayState = false;

				function displayDiv(T)
				{
					var divElement = document.getElementById(T);
					if (!divDisplayState)
					{
						divElement.style.display = "block";
						divDisplayState = true;
					}
					else
					{
						divElement.style.display = "none";
						divDisplayState = false;
					}
				}
				//]]></xsl:comment>
			</script>
			<style>
				<xsl:attribute name="type">text/css</xsl:attribute>
				<xsl:comment><xsl:value-of select="document('css.xml')/style" />//</xsl:comment>
			</style>
		</head>
	</xsl:template>
	
	<xsl:template match="personal">
		<p class="s" xmlns="http://www.w3.org/1999/xhtml">
			<b>
				<xsl:value-of select="name" /><br />
				<xsl:value-of select="address" /><br />
				<xsl:value-of select="city" />,
				<xsl:value-of select="st_ab" /><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
				<xsl:value-of select="postal_code" /><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
				<xsl:value-of select="country" /><br />
				<xsl:value-of select="cell" />
				<!--xsl:value-of select="telephone" /--><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
				<a>
					<xsl:attribute name="href">mailto:<xsl:value-of select="email" /></xsl:attribute>
					<xsl:value-of select="email" />
				</a>
			</b>
		</p>
		<hr xmlns="http://www.w3.org/1999/xhtml" />
	</xsl:template>

	<xsl:template match="objective">
		<h4 xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="@display" />
		</h4>
		<xsl:call-template name="displayTabularData">
			<xsl:with-param name="str" select="." />
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="employment_history">
		<h4 xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="@display" />
		</h4>
		<div class="div-cont" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates select="employment">
				<xsl:sort select="date/start_year" order="descending" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="employment">
		<div class="div-row" xmlns="http://www.w3.org/1999/xhtml">
			<div class="div-cel date">
				<div>
					<b>
						<xsl:value-of select="document('')/*/ma:name[@monInt=current()/date/start_month]" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="date/start_year" />
						<xsl:text> </xsl:text>
						-
					</b>
				</div>
				<div>
					<b>
						<xsl:value-of select="document('')/*/ma:name[@monInt=current()/date/end_month]" />
						<xsl:text> </xsl:text>
						<xsl:value-of select="date/end_year" />
					</b>
				</div>
			</div>
			<div class="div-cel cont">
				<b>
					<xsl:choose>
						<xsl:when test="url!=''">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="url" />
								</xsl:attribute>
								<xsl:call-template name="makeUpperCase">
									<xsl:with-param name="str" select="employer" />
								</xsl:call-template>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="makeUpperCase">
								<xsl:with-param name="str" select="employer" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose> -
				</b><xsl:call-template name="makeUpperCase">
					<xsl:with-param name="str" select="title" />
				</xsl:call-template><br />
				<xsl:value-of select="duties" />
				Programming languages used extensively: <xsl:value-of select="programming_languages/extensive" />
				Other programming languages used: <xsl:value-of select="programming_languages/other" />
				Software/applications/OS used: <xsl:value-of select="software_apps_os" />
			</div>
		</div>		
	</xsl:template>

	<xsl:template match="education">
		<h4 xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="@display" />
		</h4>
		<div class="div-cont" xmlns="http://www.w3.org/1999/xhtml">
			<xsl:apply-templates select="degree">
				<xsl:sort select="date/start_year" order="descending" />
			</xsl:apply-templates>
		</div>
	</xsl:template>

	<xsl:template match="degree">
		<div class="div-row" xmlns="http://www.w3.org/1999/xhtml">
			<div class="div-cel date">
				<b>
					<xsl:value-of select="date/start_year" /> - <xsl:value-of select="date/end_year" />
				</b>
			</div>
			<div class="div-cel cont">
				<b>
					<xsl:choose>
						<xsl:when test="university/url!=''">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of select="university/url" />
								</xsl:attribute>
								<xsl:call-template name="makeUpperCase">
									<xsl:with-param name="str" select="university/name" />
								</xsl:call-template>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="makeUpperCase">
								<xsl:with-param name="str" select="university/name" />
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose> -
					<xsl:call-template name="makeUpperCase">
						<xsl:with-param name="str" select="university/location" />
					</xsl:call-template>
				</b>
				<xsl:text> </xsl:text>
				<xsl:call-template name="makeUpperCase">
					<xsl:with-param name="str" select="@value" />
				</xsl:call-template>
				<br />
				<xsl:value-of select="study" />
			</div>
		</div>
	</xsl:template>

	<xsl:template match="organizations">
		<h4 xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="@display" />
		</h4>
		<xsl:call-template name="displayTabularData">
			<xsl:with-param name="str" select="." />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="github">
		<h4 xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="@display" />
		</h4>
		<div class="div-cont" xmlns="http://www.w3.org/1999/xhtml">
			<div class="div-row">
				<div class="div-cel date">
					<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
				</div>
				<div class="div-cel cont">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="." />
						</xsl:attribute>
						<xsl:attribute name="style">font-weight: normal;</xsl:attribute>
						<xsl:value-of select="." />
					</a>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="hobbies">
		<h4 xmlns="http://www.w3.org/1999/xhtml">
			<xsl:value-of select="@display" />
		</h4>
		<xsl:call-template name="displayTabularData">
			<xsl:with-param name="str" select="." />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="references">
		<div xmlns="http://www.w3.org/1999/xhtml">
			<xsl:attribute name="id">ref</xsl:attribute>
			<xsl:attribute name="style">display:none;</xsl:attribute>
			<h4>
				<xsl:value-of select="@display" />
			</h4>
			<div class="div-cont">
				<xsl:apply-templates select="reference">
					<xsl:sort select="order" order="ascending" />
				</xsl:apply-templates>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="reference">
		<div class="div-row" xmlns="http://www.w3.org/1999/xhtml">
			<div class="div-cel date">
				<xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
			</div>
			<div class="div-cel cont">
				<b>
					<xsl:value-of select="name" />
				</b>
				<br /><xsl:value-of select="business" />
				<br /><xsl:value-of select="address" />
				<br /><xsl:value-of select="city" />, <xsl:value-of select="st_ab" /><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;<xsl:value-of select="postal_code" />
				<br /><xsl:value-of select="telephone" />
				<br /><xsl:value-of select="email" />
				<br /><xsl:text disable-output-escaping="yes">&amp;</xsl:text>nbsp;
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
