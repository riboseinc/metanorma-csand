<?xml version="1.0" encoding="UTF-8"?><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:csa="https://www.metanorma.org/ns/csa" xmlns:mathml="http://www.w3.org/1998/Math/MathML" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fox="http://xmlgraphics.apache.org/fop/extensions" xmlns:java="http://xml.apache.org/xalan/java" exclude-result-prefixes="java" version="1.0">

	<xsl:output version="1.0" method="xml" encoding="UTF-8" indent="yes"/>

	<xsl:param name="svg_images"/>
	<xsl:param name="external_index"/><!-- path to index xml, generated on 1st pass, based on FOP Intermediate Format -->
	<xsl:variable name="images" select="document($svg_images)"/>
	<xsl:param name="basepath"/>
	
	<xsl:variable name="pageWidth" select="215.9"/>
	<xsl:variable name="pageHeight" select="279.4"/>
	<xsl:variable name="marginLeftRight1" select="25"/>
	<xsl:variable name="marginLeftRight2" select="25"/>
	<xsl:variable name="marginTop" select="25"/>
	<xsl:variable name="marginBottom" select="21"/>


	

	<xsl:variable name="debug">false</xsl:variable>
	
	<xsl:variable name="copyright">
		<xsl:text>© Copyright </xsl:text>
		<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:copyright/csa:from"/>
		<xsl:text>, Cloud Security Alliance. All rights reserved.</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="color-header-document">rgb(79, 201, 204)</xsl:variable>
	
	<xsl:variable name="contents">
		<contents>		
			<xsl:call-template name="processPrefaceSectionsDefault_Contents"/>
			<xsl:call-template name="processMainSectionsDefault_Contents"/>
		</contents>
	</xsl:variable>
	
	<xsl:variable name="lang">
		<xsl:call-template name="getLang"/>
	</xsl:variable>
	
	<xsl:template match="/">
		<xsl:call-template name="namespaceCheck"/>
		<fo:root font-family="Azo Sans, STIX Two Math" font-size="10pt" xml:lang="{$lang}">
			<fo:layout-master-set>
				<!-- Cover page -->
				<fo:simple-page-master master-name="cover-page" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="21mm" margin-bottom="21mm" margin-left="25mm" margin-right="25mm"/>
					<fo:region-before region-name="cover-page-header" extent="21mm" precedence="true"/>
					<fo:region-after region-name="footer" extent="21mm"/>
				</fo:simple-page-master>
				
				<fo:simple-page-master master-name="document" page-width="{$pageWidth}mm" page-height="{$pageHeight}mm">
					<fo:region-body margin-top="{$marginTop}mm" margin-bottom="{$marginBottom}mm" margin-left="{$marginLeftRight1}mm" margin-right="{$marginLeftRight2}mm"/>
					<fo:region-before region-name="header" extent="{$marginTop}mm" precedence="true"/> 
					<fo:region-after region-name="footer" extent="{$marginBottom}mm"/>
					<fo:region-start region-name="left-region" extent="{$marginLeftRight1}mm"/>
					<fo:region-end region-name="right-region" extent="{$marginLeftRight2}mm"/>
				</fo:simple-page-master>
				
			</fo:layout-master-set>
			
			<fo:declarations>
				<xsl:call-template name="addPDFUAmeta"/>
			</fo:declarations>
			
			<xsl:call-template name="addBookmarks">
				<xsl:with-param name="contents" select="$contents"/>
			</xsl:call-template>
			
			<!-- Cover Page -->
			<fo:page-sequence master-reference="cover-page" force-page-count="no-force">				
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<fo:static-content flow-name="cover-page-header">
					<fo:block-container height="2.5mm" background-color="rgb(55, 243, 244)">
						<fo:block font-size="1pt"> </fo:block>
					</fo:block-container>
					<fo:block-container position="absolute" top="2.5mm" height="{279.4 - 2.5}mm" width="100%" background-color="rgb(80, 203, 205)">
						<fo:block> </fo:block>
					</fo:block-container>
				</fo:static-content>
				
				<fo:flow flow-name="xsl-region-body">
					
					<fo:block-container width="136mm" margin-bottom="12pt">
						<fo:block font-size="36pt" font-weight="bold" color="rgb(54, 59, 74)">
							<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:title[@language = 'en']"/>
						</fo:block>
					</fo:block-container>
					
					<fo:block font-size="26pt" color="rgb(55, 60, 75)">
						<xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:title[@language = 'en' and @type = 'subtitle']"/>
					</fo:block>
					
					<fo:block-container absolute-position="fixed" left="11mm" top="245mm">
						<fo:block>
							<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Logo))}" width="42mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}"/>
						</fo:block>
					</fo:block-container>
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Cover Page -->
			
			
			<!-- Copyright, Content, Foreword, etc. pages -->
			<fo:page-sequence master-reference="document" initial-page-number="2" format="1" force-page-count="no-force">
				<fo:static-content flow-name="xsl-footnote-separator">
					<fo:block>
						<fo:leader leader-pattern="rule" leader-length="30%"/>
					</fo:block>
				</fo:static-content>
				<xsl:call-template name="insertHeaderFooter"/>
				<fo:flow flow-name="xsl-region-body">
				
					<xsl:if test="$debug = 'true'">
						<xsl:text disable-output-escaping="yes">&lt;!--</xsl:text>
							DEBUG
							contents=<xsl:copy-of select="xalan:nodeset($contents)"/> 
						<xsl:text disable-output-escaping="yes">--&gt;</xsl:text>
					</xsl:if>
					
					<fo:block>
						<fo:block>The permanent and official location for Cloud Security Alliance DevSecOps is</fo:block>
						<fo:block color="rgb(33, 94, 159)" text-decoration="underline">https://cloudsecurityalliance.org/group/DevSecOps/</fo:block>
					</fo:block>

					<fo:block-container absolute-position="fixed" left="25mm" top="152mm" width="165mm" height="100mm" display-align="after" color="rgb(165, 169, 172)" line-height="145%">
						<fo:block>© <xsl:value-of select="/csa:csa-standard/csa:bibdata/csa:copyright/csa:from"/> Cloud Security Alliance – All Rights Reserved. You may download, store, display on your
						computer, view, print, and link to the Cloud Security Alliance at <fo:inline text-decoration="underline">https://cloudsecurityalliance.org</fo:inline>
						subject to the following: (a) the draft may be used solely for your personal, informational, noncommercial
						use; (b) the draft may not be modified or altered in any way; (c) the draft may not be
						redistributed; and (d) the trademark, copyright or other notices may not be removed. You may quote
						portions of the draft as permitted by the Fair Use provisions of the United States Copyright Act,
						provided that you attribute the portions to the Cloud Security Alliance.</fo:block>
					</fo:block-container>
					
					<fo:block break-after="page"/>
					
					<xsl:variable name="title-acknowledgements">
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-acknowledgements'"/>
						</xsl:call-template>
					</xsl:variable>
					<fo:block font-size="26pt" margin-bottom="18pt"><xsl:value-of select="$title-acknowledgements"/></fo:block>

					<xsl:variable name="persons">
						<xsl:for-each select="/csa:csa-standard/csa:bibdata/csa:contributor[csa:person]">
							<contributor>
								<xsl:attribute name="type">
									<xsl:choose>
										<xsl:when test="csa:role/@type='author'">
											<xsl:value-of select="csa:role/csa:description"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="csa:role/@type"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="csa:person/csa:name/csa:completename"/>
							</contributor>
						</xsl:for-each>
					</xsl:variable>
					
					<xsl:variable name="contributors">
						<contributor title="Author" pluraltitle="Authors">full-author</contributor>
						<contributor title="Contributor" pluraltitle="Contributors">contributor</contributor>
						<contributor title="Staff" pluraltitle="Staff">staff</contributor>
						<contributor title="Reviewer" pluraltitle="Reviewers">reviewer</contributor>
						<contributor title="Editor" pluraltitle="Editors">editor</contributor>
					</xsl:variable>
					
					<!-- The sequence of author types is: full-author (omitted), Contributor, Staff, Reviewer -->
						
					<xsl:for-each select="xalan:nodeset($contributors)/*">
						<xsl:variable name="type" select="."/>
						<xsl:variable name="title" select="@title"/>
						<xsl:variable name="pluraltitle" select="@pluraltitle"/>
						<xsl:for-each select="xalan:nodeset($persons)/contributor[@type = $type]">
							<xsl:if test="position() = 1">
								<fo:block font-size="18pt" font-weight="bold" margin-top="16pt" margin-bottom="12pt" color="rgb(3, 115, 200)">									
									<xsl:choose>
										<xsl:when test="following-sibling::contributor[@type = $type]">
											<xsl:value-of select="$pluraltitle"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$title"/>
										</xsl:otherwise>
									</xsl:choose>									
									<xsl:text>:</xsl:text>
								</fo:block>
							</xsl:if>
							<fo:block><xsl:value-of select="."/></fo:block>
						</xsl:for-each>
					</xsl:for-each>
					

					<fo:block break-after="page"/>

					<fo:block-container font-size="12pt" line-height="170%" color="rgb(7, 72, 156)">
						<xsl:variable name="title-toc">
							<xsl:call-template name="getTitle">
								<xsl:with-param name="name" select="'title-toc'"/>
							</xsl:call-template>
						</xsl:variable>
						<fo:block font-size="26pt" color="black" margin-top="2pt" margin-bottom="30pt"><xsl:value-of select="$title-toc"/></fo:block>
						
						<fo:block margin-left="-3mm">
							<xsl:for-each select="xalan:nodeset($contents)//item[@display = 'true']">
								<fo:block>
									<fo:list-block>
										<xsl:attribute name="provisional-distance-between-starts">
											<xsl:choose>
												<xsl:when test="@level = 2">10mm</xsl:when>
												<xsl:otherwise>3mm</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<fo:list-item>
											<fo:list-item-label end-indent="label-end()">
												<fo:block font-size="1pt"> </fo:block>
											</fo:list-item-label>
											<fo:list-item-body start-indent="body-start()">
												<fo:block text-align-last="justify" margin-left="12mm" text-indent="-12mm">
													<fo:basic-link internal-destination="{@id}" fox:alt-text="{title}">
														<fo:inline padding-right="2mm"><xsl:value-of select="@section"/></fo:inline>
														<xsl:apply-templates select="title"/>
														<fo:inline keep-together.within-line="always">
															<fo:leader leader-pattern="dots"/>
															<fo:inline><fo:page-number-citation ref-id="{@id}"/></fo:inline>
														</fo:inline>
													</fo:basic-link>
												</fo:block>
											</fo:list-item-body>
										</fo:list-item>
									</fo:list-block>
								</fo:block>
							</xsl:for-each>
						</fo:block>
					</fo:block-container>
					
					<fo:block break-after="page"/>
					
					<fo:block line-height="145%">
						<xsl:call-template name="processPrefaceSectionsDefault"/>					
						<xsl:call-template name="processMainSectionsDefault"/>
					</fo:block>
					
					
				</fo:flow>
			</fo:page-sequence>
			<!-- End Document Pages -->
			
		</fo:root>
	</xsl:template> 

	<xsl:template match="node()">		
		<xsl:apply-templates/>			
	</xsl:template>
	
	<!-- ============================= -->
	<!-- CONTENTS                                       -->
	<!-- ============================= -->
	<xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template>

	<!-- element with title -->
	<xsl:template match="*[csa:title]" mode="contents">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="csa:title/@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		
		<xsl:variable name="display">
			<xsl:choose>				
				<xsl:when test="$level &gt;= 3">false</xsl:when>				
				<xsl:otherwise>true</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="skip">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::csa:bibitem">true</xsl:when>
				<xsl:when test="ancestor-or-self::csa:term">true</xsl:when>
				<xsl:otherwise>false</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$skip = 'false'">
			<xsl:variable name="section">
				<xsl:call-template name="getSection"/>
			</xsl:variable>
			
			<xsl:variable name="title">
				<xsl:call-template name="getName"/>
			</xsl:variable>
			
			<item id="{@id}" level="{$level}" section="{$section}" display="{$display}">
				<title>
					<xsl:apply-templates select="xalan:nodeset($title)" mode="contents_item"/>
				</title>
				<xsl:apply-templates mode="contents"/>
			</item>
		</xsl:if>
	</xsl:template>


	<!-- ============================= -->
	<!-- ============================= -->
		
	
	<xsl:template match="csa:license-statement//csa:title">
		<fo:block text-align="center" font-weight="bold" margin-top="4pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:license-statement//csa:p">
		<fo:block font-size="8pt" margin-top="14pt" line-height="115%">
			<xsl:if test="following-sibling::csa:p">
				<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:feedback-statement">
		<fo:block margin-top="12pt" margin-bottom="12pt">
			<xsl:apply-templates select="csa:clause[1]"/>
		</fo:block>
	</xsl:template>
		
	<xsl:template match="csa:copyright-statement//csa:title">
		<fo:block font-weight="bold" text-align="center">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	<xsl:template match="csa:copyright-statement//csa:p">
		<fo:block margin-bottom="12pt">
			<xsl:if test="not(following-sibling::p)">
				<xsl:attribute name="margin-bottom">10pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:legal-statement">
		<fo:block-container border="0.5pt solid black" margin-bottom="12pt" margin-left="-2mm" margin-right="-2mm">
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:block margin-left="2mm" margin-right="2mm">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
	<xsl:template match="csa:legal-statement//csa:title">
		<fo:block text-align="center" font-weight="bold" padding-top="2mm" margin-bottom="6pt">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="csa:legal-statement//csa:p">
		<fo:block margin-bottom="6pt">
			<xsl:if test="not(following-sibling::csa:p)">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	
	
	<!-- ====== -->
	<!-- title      -->
	<!-- ====== -->	
	<xsl:template match="csa:annex/csa:title">
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">rgb(3, 115, 200)</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="12pt" text-align="center" margin-bottom="12pt" keep-with-next="always" color="{$color}">
			<xsl:apply-templates/>
		</fo:block>		
	</xsl:template>
	
	<xsl:template match="csa:title">

		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="ancestor::csa:preface and $level &gt;= 2">12pt</xsl:when>
				<xsl:when test="ancestor::csa:preface">13pt</xsl:when>
				<xsl:when test="$level = 1">26pt</xsl:when>
				<xsl:when test="$level = 2 and ancestor::csa:terms">11pt</xsl:when>
				<xsl:when test="$level = 2">14pt</xsl:when>
				<xsl:when test="$level &gt;= 3">11pt</xsl:when>
				<xsl:otherwise>16pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="font-weight">
			<xsl:choose>
				<xsl:when test="$level = 1">normal</xsl:when>
				<xsl:otherwise>bold</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="../@inline-header = 'true'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">rgb(3, 115, 200)</xsl:when>
				<xsl:otherwise>black</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:element name="{$element-name}">			
			<xsl:attribute name="font-size"><xsl:value-of select="$font-size"/></xsl:attribute>
			<xsl:attribute name="font-weight"><xsl:value-of select="$font-weight"/></xsl:attribute>
			<xsl:attribute name="space-before">13.5pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>		
			<xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
			<xsl:attribute name="line-height">120%</xsl:attribute>
			
			<xsl:if test="$level = 2">
				<fo:inline padding-right="1mm">							
					<fo:external-graphic src="{concat('data:image/png;base64,', normalize-space($Image-Title))}" width="15mm" content-height="scale-to-fit" scaling="uniform" fox:alt-text="Image {@alt}" vertical-align="middle"/>
				</fo:inline>
			</xsl:if>
			
			<xsl:apply-templates/>
			
		</xsl:element>
		
	</xsl:template>
	<!-- ====== -->
	<!-- ====== -->
	
	<xsl:template match="csa:p">
		<xsl:param name="inline" select="'false'"/>
		<xsl:variable name="previous-element" select="local-name(preceding-sibling::*[1])"/>
		<xsl:variable name="element-name">
			<xsl:choose>
				<xsl:when test="$inline = 'true'">fo:inline</xsl:when>
				<xsl:when test="../@inline-header = 'true' and $previous-element = 'title'">fo:inline</xsl:when> <!-- first paragraph after inline title -->
				<xsl:when test="local-name(..) = 'admonition'">fo:inline</xsl:when>
				<xsl:otherwise>fo:block</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$element-name}">
			<xsl:attribute name="id">
				<xsl:value-of select="@id"/>
			</xsl:attribute>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<!-- <xsl:when test="ancestor::csa:preface">justify</xsl:when> -->
					<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
					<xsl:otherwise>left</xsl:otherwise><!-- justify -->
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="space-after">
				<xsl:choose>
					<xsl:when test="ancestor::csa:li">0pt</xsl:when>
					<xsl:otherwise>12pt</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="line-height">155%</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
		<xsl:if test="$element-name = 'fo:inline' and not($inline = 'true') and not(local-name(..) = 'admonition')">
			<fo:block margin-bottom="12pt">
				 <xsl:if test="ancestor::csa:annex">
					<xsl:attribute name="margin-bottom">0</xsl:attribute>
				 </xsl:if>
				<xsl:value-of select="$linebreak"/>
			</fo:block>
		</xsl:if>
		<xsl:if test="$inline = 'true'">
			<fo:block> </fo:block>
		</xsl:if>
	</xsl:template>
	
	<!--
	<fn reference="1">
			<p id="_8e5cf917-f75a-4a49-b0aa-1714cb6cf954">Formerly denoted as 15 % (m/m).</p>
		</fn>
	-->
	<xsl:template match="csa:title/csa:fn | csa:p/csa:fn[not(ancestor::csa:table)]" priority="2">
		<fo:footnote keep-with-previous.within-line="always">
			<xsl:variable name="number" select="@reference"/>
			
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super">
				<fo:basic-link internal-destination="footnote_{@reference}" fox:alt-text="footnote {@reference}">
					<xsl:value-of select="$number"/><!--  + count(//csa:bibitem/csa:note) -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-family="Azo Sans Lt" font-size="10pt" margin-bottom="12pt" font-weight="normal" text-indent="0" start-indent="0" color="rgb(168, 170, 173)" text-align="left">
					<fo:inline id="footnote_{@reference}" keep-with-next.within-line="always" font-size="60%" vertical-align="super">
						<xsl:value-of select="$number "/><!-- + count(//csa:bibitem/csa:note) -->
					</fo:inline>
					<xsl:for-each select="csa:p">
							<xsl:apply-templates/>
					</xsl:for-each>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>

	<xsl:template match="csa:fn/csa:p">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csa:bibitem">
		<fo:block id="{@id}" margin-bottom="12pt" start-indent="12mm" text-indent="-12mm" line-height="145%">
			<xsl:if test=".//csa:fn">
				<xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="csa:formattedref">
					<xsl:apply-templates select="csa:formattedref"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
						<xsl:apply-templates/>
						<xsl:if test="position() != last()">, </xsl:if>
						<xsl:if test="position() = last()">: </xsl:if>
					</xsl:for-each>
						<!-- csa:docidentifier -->
					<!-- <xsl:if test="csa:docidentifier">
						<xsl:value-of select="csa:docidentifier/@type"/><xsl:text> </xsl:text>
						<xsl:value-of select="csa:docidentifier"/>
					</xsl:if> -->
					<xsl:value-of select="csa:docidentifier"/>
					<xsl:apply-templates select="csa:note"/>
					<xsl:if test="csa:docidentifier">, </xsl:if>
					<fo:inline font-style="italic">
						<xsl:choose>
							<xsl:when test="csa:title[@type = 'main' and @language = 'en']">
								<xsl:value-of select="csa:title[@type = 'main' and @language = 'en']"/><xsl:text>. </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="csa:title"/><xsl:text>. </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</fo:inline>
					<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
						<xsl:apply-templates/>
						<xsl:if test="position() != last()">, </xsl:if>
					</xsl:for-each>
					<xsl:if test="csa:date[@type='published']/csa:on">
						<xsl:text>(</xsl:text><xsl:value-of select="csa:date[@type='published']/csa:on"/><xsl:text>)</xsl:text>
					</xsl:if>
			</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csa:bibitem/csa:note" priority="2">
		<fo:footnote>
			<xsl:variable name="number">
				<xsl:choose>
					<xsl:when test="ancestor::csa:references[preceding-sibling::csa:references]">
						<xsl:number level="any" count="csa:references[preceding-sibling::csa:references]//csa:bibitem/csa:note"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:number level="any" count="csa:bibitem/csa:note"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<fo:inline font-size="65%" keep-with-previous.within-line="always" vertical-align="super"> <!--  60% baseline-shift="35%"   -->
				<fo:basic-link internal-destination="{generate-id()}" fox:alt-text="footnote {$number}">
					<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
				</fo:basic-link>
			</fo:inline>
			<fo:footnote-body>
				<fo:block font-family="Azo Sans Lt" font-size="10pt" margin-bottom="12pt" start-indent="0pt" color="rgb(168, 170, 173)">
					<fo:inline id="{generate-id()}" keep-with-next.within-line="always" font-size="60%" vertical-align="super"><!-- baseline-shift="30%" padding-right="9mm"  alignment-baseline="hanging" -->
						<xsl:value-of select="$number"/><!-- <xsl:text>)</xsl:text> -->
					</fo:inline>
					<xsl:apply-templates/>
				</fo:block>
			</fo:footnote-body>
		</fo:footnote>
	</xsl:template>
	
	
	
	<xsl:template match="csa:ul | csa:ol" mode="ul_ol">
		<xsl:choose>
			<xsl:when test="not(ancestor::csa:ul) and not(ancestor::csa:ol)">
				<fo:block-container border-left="0.75mm solid {$color-header-document}" margin-left="1mm" margin-bottom="12pt">
					<fo:block-container margin-left="8mm">
						<fo:block margin-left="-8mm" padding-top="6pt">
							<xsl:call-template name="listProcessing"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block-container>
					<fo:block-container margin-left="7mm">
						<fo:block margin-left="-7mm">
							<xsl:call-template name="listProcessing"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template name="listProcessing">
		<fo:list-block provisional-distance-between-starts="6.5mm" line-height="145%">
			<xsl:if test="ancestor::csa:ul | ancestor::csa:ol">
				<!-- <xsl:attribute name="margin-bottom">0pt</xsl:attribute> -->
			</xsl:if>
			<xsl:if test="following-sibling::*[1][local-name() = 'ul' or local-name() = 'ol']">
				<!-- <xsl:attribute name="margin-bottom">0pt</xsl:attribute> -->
			</xsl:if>
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>
	
	<xsl:template match="csa:li">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:choose>
						<xsl:when test="local-name(..) = 'ul' and (../ancestor::csa:ul or ../ancestor::csa:ol)">-</xsl:when> <!-- &#x2014; dash -->
						<xsl:when test="local-name(..) = 'ul'">•</xsl:when> <!-- &#x2014; dash -->
						<xsl:otherwise> <!-- for ordered lists -->
							<xsl:choose>
								<xsl:when test="../@type = 'arabic'">
									<xsl:number format="a)" lang="en"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet'">
									<xsl:number format="1)"/>
								</xsl:when>
								<xsl:when test="../@type = 'alphabet_upper'">
									<xsl:number format="A)" lang="en"/>
								</xsl:when>
								
								<xsl:when test="../@type = 'roman'">
									<xsl:number format="i)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:number format="1)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()" line-height-shift-adjustment="disregard-shifts">
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	<xsl:template match="csa:ul/csa:note | csa:ol/csa:note" priority="2">
		<fo:list-item font-size="10pt">
			<fo:list-item-label><fo:block/></fo:list-item-label>
			<fo:list-item-body>
				<fo:block>
					<xsl:apply-templates select="csa:name" mode="presentation"/>
					<xsl:apply-templates/>
				</fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="csa:preferred">		
		<xsl:variable name="level">
			<xsl:call-template name="getLevel"/>
		</xsl:variable>
		<xsl:variable name="font-size">
			<xsl:choose>
				<xsl:when test="$level &gt;= 2">11pt</xsl:when>
				<xsl:otherwise>12pt</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:block font-size="{$font-size}">
			<fo:block font-weight="bold" keep-with-next="always">
				<xsl:apply-templates select="ancestor::csa:term/csa:name" mode="presentation"/>	
			</fo:block>
			<fo:block font-weight="bold" keep-with-next="always" line-height="1">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>

	

	<!-- [position() &gt; 1] -->
	<xsl:template match="csa:references[not(@normative='true')]">
		<fo:block break-after="page"/>
		<fo:block id="{@id}" line-height="145%">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>


	<!-- Example: [1] ISO 9:1995, Information and documentation – Transliteration of Cyrillic characters into Latin characters – Slavic and non-Slavic languages -->
	<!-- <xsl:template match="csa:references[@id = '_bibliography']/csa:bibitem"> [position() &gt; 1] -->
	<xsl:template match="csa:references[not(@normative='true')]/csa:bibitem">
		<fo:block margin-bottom="12pt" line-height="145%">
			<fo:inline id="{@id}">
				<xsl:number format="[1]"/>
			</fo:inline>
				
			<xsl:if test="not(csa:formattedref)">
				<xsl:choose>
					<xsl:when test="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:abbreviation">
						<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:abbreviation">
							<xsl:value-of select="."/>
							<xsl:if test="position() != last()">/</xsl:if>
						</xsl:for-each>
						<xsl:text>: </xsl:text>
					</xsl:when>
					<xsl:when test="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
						<xsl:value-of select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name"/>
						<xsl:text>: </xsl:text>
					</xsl:when>
				</xsl:choose>
				
			</xsl:if>
			
			<xsl:if test="csa:docidentifier">
				<xsl:choose>
					<xsl:when test="csa:docidentifier/@type = 'ISO' and csa:formattedref"/>
					<xsl:when test="csa:docidentifier/@type = 'OGC' and csa:formattedref"/>
					<xsl:otherwise><fo:inline>
						<!-- <xsl:if test="csa:docidentifier/@type = 'OGC'">OGC </xsl:if> -->
						<xsl:value-of select="csa:docidentifier"/><xsl:apply-templates select="csa:note"/>, </fo:inline></xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			
			<xsl:choose>
				<xsl:when test="csa:title[@type = 'main' and @language = 'en']">
					<xsl:apply-templates select="csa:title[@type = 'main' and @language = 'en']"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="csa:title"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
				<xsl:text>, </xsl:text>
				<xsl:for-each select="csa:contributor[csa:role/@type='publisher']/csa:organization/csa:name">
					<xsl:if test="position() != last()">and </xsl:if>
					<xsl:value-of select="."/>
				</xsl:for-each>
				
			</xsl:if>
			<xsl:if test="csa:place">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="csa:place"/>
			</xsl:if>
			<xsl:if test="csa:date[@type='published']/csa:on">
				<xsl:text> (</xsl:text><xsl:value-of select="csa:date[@type='published']/csa:on"/><xsl:text>).</xsl:text>
			</xsl:if>
			<xsl:apply-templates select="csa:formattedref"/>
					
			
		</fo:block>
	</xsl:template>
	
	<!-- <xsl:template match="csa:references[@id = '_bibliography']/csa:bibitem" mode="contents"/> [position() &gt; 1] -->
	<xsl:template match="csa:references[not(@normative='true')]/csa:bibitem" mode="contents"/>
	
	<!-- <xsl:template match="csa:references[@id = '_bibliography']/csa:bibitem/csa:title"> [position() &gt; 1]-->
	<xsl:template match="csa:references[not(@normative='true')]/csa:bibitem/csa:title">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>


	
	<xsl:template match="csa:admonition">
		<fo:block-container border="0.5pt solid rgb(79, 129, 189)" color="rgb(79, 129, 189)" margin-left="16mm" margin-right="16mm" margin-bottom="12pt">
			<fo:block-container margin-left="0mm" margin-right="0mm" padding="2mm" padding-top="3mm">
				<fo:block font-size="11pt" margin-bottom="6pt" font-weight="bold" font-style="italic" text-align="center">					
					<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(@type))"/>
				</fo:block>
				<fo:block font-style="italic">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>
	
		
	<xsl:template match="csa:formula/csa:stem">
		<fo:block margin-top="6pt" margin-bottom="12pt">
			<fo:table table-layout="fixed" width="100%">
				<fo:table-column column-width="95%"/>
				<fo:table-column column-width="5%"/>
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell display-align="center">
							<fo:block text-align="left" margin-left="5mm">
								<xsl:apply-templates/>
							</fo:block>
						</fo:table-cell>
						<fo:table-cell display-align="center">
							<fo:block text-align="right">
								<xsl:apply-templates select="../csa:name" mode="presentation"/>
							</fo:block>
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
			</fo:table>			
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="csa:pagebreak">
		<fo:block break-after="page"/>
		<fo:block> </fo:block>
		<fo:block break-after="page"/>
	</xsl:template>
		
	<xsl:template name="insertHeaderFooter">
		<fo:static-content flow-name="header">
			<fo:block-container height="2.5mm" background-color="{$color-header-document}">
				<fo:block font-size="1pt"> </fo:block>
			</fo:block-container>
		</fo:static-content>
		<fo:static-content flow-name="footer">
			<fo:block-container font-family="Azo Sans Lt" font-size="10.1pt" height="100%" display-align="after"> <!-- 11.5pt -->
				<fo:block padding-bottom="13mm" text-align="right" color="rgb(144, 144, 144)">
					<fo:inline padding-right="7mm"><xsl:value-of select="$copyright"/></fo:inline>
					<fo:page-number/>
				</fo:block>
			</fo:block-container>
		</fo:static-content>
	</xsl:template>

	<xsl:variable name="Image-Logo">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAA+AAAAFsCAYAAABMytP3AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3BpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDplYWRhN2RlNC04YzAyLTQ1N2UtYjUwNy0zNGYzY2RjNWE2ZGQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6NkU5NEE5NUY3NjVBMTFFQUFGNTc5RUZEMzQzODM4QzgiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6NkU5NEE5NUU3NjVBMTFFQUFGNTc5RUZEMzQzODM4QzgiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgSW5EZXNpZ24gMTQuMCAoTWFjaW50b3NoKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ1dWlkOmQ1MDMzN2Q0LTBkZmItYzI0MS1iZTY2LWI3M2VlMWI2NWE4MyIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmlkOmJhMmE0NmVkLTFmMjUtNDExNS1hOTkzLWJkN2Q0YmY4MDBlMSIvPiA8L3Jk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</xsl:text>
	</xsl:variable>
	
	<xsl:variable name="Image-Title">
		<xsl:text>iVBORw0KGgoAAAANSUhEUgAAASEAAAEhCAYAAAAwHRYbAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA3BpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNi1jMDE0IDc5LjE1Njc5NywgMjAxNC8wOC8yMC0wOTo1MzowMiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDplYWRhN2RlNC04YzAyLTQ1N2UtYjUwNy0zNGYzY2RjNWE2ZGQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MDUyNzBENDc3NjVCMTFFQTlDMDhGMEI2ODhENjUxQkIiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MDUyNzBENDY3NjVCMTFFQTlDMDhGMEI2ODhENjUxQkIiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgSW5EZXNpZ24gMTQuMCAoTWFjaW50b3NoKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ1dWlkOmZiZjFiODZmLTIzMjMtM2U0OS1hMDMzLTVlOGQxYThlNmI1YiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmlkOjFlMzVjZTE3LWU5NzAtNDQ1OS05ZjI0LTM1NzcwZWYzMjNjMiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PpxYC6QAADYxSURBVHja7F0J3FbT9l59SWUqMmTOlMoUGRJuma/pmq9ZoZCZ6JplzjXPXFO4hrjGuCLckChkCA1ErjFFEWWq/uf57/Xe3r6+r2/t8+59zt7nXc/vt39vPvtM++zz7LXX2Khxn9dIoVAo8kKNDoFCoVASUigUSkIKhUKhJKRQKJSEFAqFQklIoVAoCSkUCoWSkEKhUBJSKBQKJSGFQqEkpFAoFD6wkA6BQoDFkrZEWVskac24AY2TtnjSppUd83PSfk/a9KT9yO2HpP2iw6lQElKUv/9VkrZ60lbjtlzSVuDf5ZO2DJOMK/yWtElJ+7rsF+3TpH3C7aukzdHXoySkKA4gsbRL2jpJWy9pHfjfqzomGAkWTtrK3BZEVB8lbUzS3k/a6KR9yH+bpa9TSUgRNhozyWyatE24rR/Zu16YSRJtn7K/z0ja20kbkbQ3uE3QV64kpMifdDZMWjduW5HR2xQR0EVtwa0EbOmGlrWxOiXiQiNNahYlsJXZOWk7JW0bMkphxVxSei5pT/PvVB0SJSGFg/fE26s9krYLGb2OomHMThom+FNJe1i3bkpCCnvi2Sxp+3JbWYekYkDJ/RATkm7blIQU9WCtpB2StEPJWK8UfgAF9z1Juy9pk3U4lISqHXAGPCBp3WlepavCP/5I2jNJuytpg/i/FRlCrWP5Aqb0Y1jqCUW5/BMZZ8FvytoUmuvxPI3/PZv71vXRNk1a86Q1SVoLmutpvSQZ58eSQ+SySVuR++f5DezGDc/9j6Tdxv9WqCRUSCBeDwrmE5LWNad7QEgFHAE/SNo4MgrbksfydzncDwhpdZrrud2eCbp9TgsliPXxpF2TtFd1yioJFQXNebvVJ2lrZnjd72muY9+bZLyPQTgxhEVAkmpLxhoIp0tYCDci4y+UFfCBXJ60J1j6UygJRYeWSTue2zIZXA9SzVBur1HxzNJwzlyXjFNmV/5dLoPrjk/alWR0R7/rtFYSigGLsdRzMhm9iE9JB055UK6+mLQvqnCsERe3HRkfqm40N7rfF8lflLR/kiqxlYQCxaIs9ZyatFaergE9ziNMPHiBGtQ577a3GxPSXmQyAfgko3t0m6YkFAqgQO2RtAuT1trD+UuOdo+SUSgrGgaMAHB5QBDsnuTH4RPvpS8vCAolodyAVfcyMlHfLgHzOJzp7iajUFZUMNfJ6JCwUOzN22WXeCFpp5FxglQoCWUGeDdfn7QdHZ4TWytYYu5I2rO61fK2ZcZWrWfS/uTwvLA4ws/oTDK6OoVQXFXYAybii1kUd0VAyC54PplMh1ip/60E5A3wk7qXJSOY/28i43jpQto6iowlrZd+XyoJ+QI8a29gsnAB+O5cQUbRrNaW/LA4b9VOSVobR+ccyaT0jg6vSkIuAB8f6GeedERAkHS2JuOEN1AJKHdM5601ttiI4xvl4Jyb8iIDqbmpDrGSUCXApESO4wMdnAv6Hnj9Qpk9VIc2OGAxeDBpncgkjRtR4fngXAkd0btJ66LDqyRki1a8Tbo/aUs7Ih/EjakFJQ4MTlpnR2S0dtKGkbGiLqxDqyQkwfZJe4+MFaUS/CdpGyv5FIKM/kLGUTQtoLjuy4TWXodVSag+YO9+NZlQiBUqOA8cCqHERg7ot3RYCwHkG0LcWm8yuazToiMZndNxTExKQor/AakkhiftpArOMZUnKSbaUzqkhQN0RreQyYSArVXaYFbEt13P2/0W1TygSkJzsQdLLBulPB6OareTST1xC6m1q+iAX9HpZGq6PV/BefZkqaijklD1AtYL+Ok8RibtRhrA8rE5GQe1KTqkVQUkzIf+8K+UPhsjJPDXk3aEklD1AelGERrRJ+XxKFd8NhnF8wj9HqsaqOCB2ME7Ux7flCVpeG83URKqDiAHDTxat015PFzNNyDjiKZbLwUwjaUZSEYTU56jNy+Mrapl0KqVhHZmySVNmlUQzhlkMvpp7SpFXYCOaL0KpKKteYHsoCRUTBxJxtSapl47fERQkLA/aXCpYsH4iaUiBCOniahfnaXtrkUfqGoiIfhjIOHYrSmfGykaYDkbpd+XwgKPslT0YopjsVAOSdp+SkLxowmLxmenOBZpHw4mEw09Q78pRQrAarYDL4JzUsxdxLL1KergVAMJweoAh7AeKY5F0Coioe/T70hRIbB9P5dMHFqa2m5XsBpASSgyIPkYcv/uluLYfzEBfajfj8IhYPnaMOW2/m9Ju5EKFupRZBJqwfvprVMcex4Z57Of9ZtReMDnZKyrA1Mci7Lh8CdqrCQUPgEhANU2fwt0PrBmXEBxVChVxAvMNeSpSqOnPJxMqaFCEFERSahEQJtaHvcNr06P6vehyAhY6C5mqftXy2ORYG9AEbZmRSMh6ICeSEFA8P/ZnNT8rsgHCPmAl/U0y+Ngtb0pdiIqEgmh8iZSZ9g6dyF1BwrkTdRvQZEjXuF5+LnlcUeTKbygJJQzsDeGGd1WCT2YV6Dv9BtQBABYYqHH/MjyOCir+ykJ5YubyeRlsQG2bbuTOiAqwsIXLBG9b3kcLLpHKgnlA6wAvSyPQeJ6WMF+0zmvCBCTWa0wMoPFOHfEXvwQZXxvS0FAh5IGoNoAXufNF/CL6hGLWPwiPzN8uFC/XV0h6kcaS+8vZNLTDFcS8o9u/IJsEkApAc0PeO8i4TqCLBEw2aysNeVfX0Alkv145VfUT0RDyS7967dMXJ8pCfkDqmQiHeZSFscMYlFVCWguTkzaVTlvy19N2p+SNltfR71A9V9E4a9rccxoMrql6aE/XIw6oZZMKDYEhHidfZSA5sGWSbsmgDmAD2VnfR0LBCRFlI762OKY9VjyD96rOjYSquGBXdvimDfIFDBUJfS8ODmge1ESkhHRjmRX72zXpJ2vJOQW55BJhSAF/C1Q813N8HVLIKGgs74OET7h+f+jxTFnUbosEkpCdQCrwLkW/SfxMar0rHtLu1xA94PaXYvoaxEBpcSh27Qpuohg1zWUhCrDKrwNk94vzJRwRPxU52ydWDuw+4HeYmN9LWJASd3bctFBfqzmSkLpsBCZ9JY2imikOtA6YPWjXYD3pFsyO9yRtCst+ne07K8kVAbogTa36H9R0h7QORqVJKQklA7ItPiURf/evEMITsoIGTAj2yR9epLs9EYqCdWPmWQqjMDPZFbZL5Sis8t+fyDj9Vz6LaWjKP8dI7imkpA98D6QV+jNpLW1kKBgMf4qlIdYyNE5ViP7yF/JPvY+C2ltQtK6k4YBSCCZsCCOkxxdb4SAhJYno/v7r74eK2Bx2IvHeFFBf1R2vZuM0SYIB9FKtmMgnx5kqpAiBmhhx/d2DU9KCWbyi5imc7JBNLYgIVd4XbdkXvEB2QVxb0d2iu3gSKicfO4iY/pbmYwy2BV2YalGCuRTeU/noghtSBZvN15JKCpAD2qT3Owy3sFERUJ1kU85znQkDbVgXYQU2LIN0DkoRnthv7EOr4k4JonDaJYkhDisf5IJ8vyajD5xm8jf7akWizG2bigImntqWAkJNWqAfEpwJQ2hyNsKwr6fshSkkEOqwBzn8JpQoL4h6LeRh219XfMZ1UyRT/wg3vK3JuNVDLVCv4jfLZLlo4LHL8L+3UL4fiQkNIdJSOJxWak0hEHpaTGxMYl+VF6xQjvhOx/v+LoSvy2kDuno8dkRjf40L3T1bUmRofAaijd5PFLE2sQFXkrGKBD8dky6OlQiDWFS3GTRH/5AMeYhwbb2WDKJzSeSSWWBSdMso+tLfIRgoZrp+LrSd+VrS4ZEX++SLPbwRN6qxFrX65ak/VvYd/GkXR0DCQ1N2kvCvmmloT4W+gpMposjnBzQdyGRFxSI8IFalUxi86t4L981g3uQSELjPFxX6sHumoQW4rkyxHLFh/Q/MIPtoS8g3/QPwr5ILLd96CTkWxrCx3iOsO8fPEF+j2xSlGqibVnP/1+LyR5K+Zae7gHnXVbQb6yHa0P5K8n055KEVuHF88yU2yvkIR9EcQbXfkl2fl438HY4aBLyKQ1dYfGiL0naO5FNCIzFQ0JJpxfv6/fKaSvmSxKSSkOrCYmyIezFEnOXCs+zA5k0wi0iJKIBFtuytpRTjilbPyEf0hAkg30sPo5LIpsI0CsglcIuFsdg2/AImZLULpWG0sDVsZ7GIgt/IejWbubxcyVRbsGL8DIREhGKI0rzaZ3paAHwSkKupSGIyDaRvTAn/hrRBGjEH8R+KY9H3pgxLB25sNbkLQn5JqEOZFwBjvZw77DawZiwUmQk9LmF8AAldeaZGNN4TLuUhuDTIC1ngnxCL0Y2AS4n+5potVFy3oRCe60MJKHprE/wAfjmSHR5aUioJxPQuh7fJ0gc1sw1I5uH1/AWX4JeTOZBk5AraWhhi60VfIFOTXGvC/GquEoOLx7R/30cng/6JHgen0HpA48ljorjPY4JpNi3Bf02Ibl5HCSNfFOoP5eFAhlzaRiZRPKxAMQvjRXDuP89dBKylYaOXgDjrio8zwVkrCs25NODdRs3MxlmieOTdqGH8zZl4kbqBttMhHkErtYFiXJ6saStI+i3GZNa2u0uMj9AJ/mC5XFIjfsyXz8W4H4HCvvuQhmG0KQlIRtpCCt37bSSzUmeJwihGdenIJ/yEJPDM5SGUFzxOs/X2IA/5istVv82lH3gal2QOi3CUrN6Pf8P+rG+LJGkDcK8l0yYCLZXqPbxhOXxLZm8Yoo3O53kOtULQichG2kIcTlH1frbUfx3CTDZGirX01BwbZOMpKE9+fpZvbtTkvY+yRzNNhSeNwRJiPh9IkfUcJaaS7lyYL0ZTCYKPM229GdeKNB+4r9hfu3NxGQD3NMzSftLJCQ0MWnXCvtiTnXL4qYqrcA6lGS+L9/wqjaTRe0JJDMFDmdxec4CyOdglqoaim3DvhgKRV9Js5Cj5d9kV5Z6JBMJPKY3rfD6SFQFHdR3tSQGhCugzPNuwkUHUpbvtCgoU2xr7p7O24ndKH2lkNLW7aMFSFiQuo+1PC/iGJF65r4IiAg6NBRRXFrQ96UsiKjSHNNS6aJcGupFcl+Ev9VDQA1JPnXBpzSEHNhPWhIQJJhdeTuA40/iVToturMUsz+/1/35o0O4wu4kD1Yen8GH8HqKY2A+7lkBAV3H4/xRA88Pwrb1RYO+DWlBekdAQgjlkIY8QcDYKnRJiFg03lEoDa3NH9/Kgv4o3fznCiSfrKQh1MyC/8gSFsdM4BXmi1p/h6L+ljqe2xZThCtdXeJ6FomuzqTsYv8gGR5GJvzCBn15y5fm2S4NnIia8xyUOMI+zYtlsJKQrW7oZiEB1T5vGsknC2kIfjsvWBLQl0zaX9Tx/xBbtRMT7ZQK7mvplMeNzegjeCWj68Ai1DEFAQEwU8Oya5uHGVJUfwo7FQjUIlLFMyxlPn2vnJDQ6yy1SPBXYb9BfF5X5FOOw0muFF8Q4Dn7H8sPfgoT0IQG+kG30J5F/CzxdkbXeZUlYl+YzYvYNvWQvRS3Ju0Qsg+WhhrhJgo7FQhSlXxuIRUGTUI20pDUmnGJB/IBoGjbgbeGlQBK1aFJW9HiGDhcwhT8gQVhHcJbs88ymJRQrt6b0QcAkti/QmlvQZLm1mTCD2Y5OB889fch+/xKR/PWOlT8ZrFtPIA8hqu4IiEbaaghfMgSgEvyGcETsxuTRyVowVswm3vDBIYZ940U13uWxeFryG+JFqx2YzL8CD7grRJCUqY6OieMAxvwNswlnmS9yHTL43pS5fo9nxhAxlIpER6O9nUTLiuw9nN0ng6OyQc6ls4OyAdYhEnBxmUfovy+JHfurAvwZ4HzHqw7ox3PAaRFgfXsqhw+AkgtR7FkiQXi2pRSKlb1E5K2B83rouASiFvcPsX5Dw2YhGaS3G8IVm0vCd5ckpBLacgl+Qx2dM6FeUW0cdWfzVuqpx3dA/yKOpFJAFdJNoHvyaT03JDbkzm/r1lM0iex2I8t87/IJLBrCOP5ncC/Z04G8woStU0I0VoUNqC7kriGLMuLadAk5FIaCol8AFg64Ci3bQq9wEDHzwjJ6iLedthamaAMPpw/9FMozORwIKQhPOFX5metT/q4m0k5y+cYTfNHACwIkwMnIRQMvU3Y97gYSCgvacgX+ZRwLIv6NjjV4uWmAXL+dGWia6jiyBu85YJP013kPom9L3zDUh/8p45I2mMsMd3OW6MeNDf0Iis0JnkqYnIoBfvEjQIpEg6Ft/q4uAtnxdroTNlVwRjB0tdgz9eBsry9Rf+LLCdqpYCVDh7BtVPCjuH7eDSDrUq1ALo5qf4M4RHQH/4SwXMhBq62Eh3e1bCY/oPc6yK9khCR3Is6dPIprXx/WPSHbuKEnCYS0l8gp/LCrCuBFW+28oYztCFj1ZNmLoD+aGgkzwbrX8mpcxgTD1LkzvB9YV8k5EsaypJ8yvErySwD+ODXpWxN3YrsAFXDDsK+2IofGdGzQTWDwo8DSZ6F0dmFfcC1bsi3zqchvGwxnsjy10y/18LhUAsCgvWsb2TPN5tJ6MOsL1zj8dz9HJyj5MOSF/mUcK7FtgbK3yv1my0U4MdkU6UUVqRpOmz5k1Al0hDIBwnCkPnuyQDGCVtLm6jvY/j+FcUAHPqWEvaFBe9RHbIwSCiNNFROPo9TWBYdxCINs+h/B+WTYF/hFoj3O0DYF9akY3XIwiIhSEMSP4mQyaeEWTwZpXFOS5IJflxIp1m0QCI1myDU08jOm1qRAQkB50ROPuVAWojDLPpvQfl7kSvSA9kcpPmvSk6UigBJCDlqnoicfMqBZ7nRoj+qjWytUy06bG6xtYILRy9Sh9BgSQg4vwDkUw6EZLxrMcZIUra0Trdo0JSlGml2REi7H+mwhU1CkIa6FIB8SoAbPpJySRPTI5fv3RR2yk/FvNKrtBQyFqMrdMjCJyHgtYKJq8j6eLxFf1hZTtYpFzzWYRKSAMYKJC77Q4ctDhIqIhCRfr9FfyRA76TDFvT3gHALafIuZLt8U4etMqj5uHIglQaSaklrnyE2B4nEpkf0jM1ZQkAOI0SFo5AldFyt+LcxS7lIlgYXBlgRkcz/A/5IP4xEWoAienNh30/IeNIrKoSvANZqQyfebkqLH0J6OijwZ2rLW0jE7CFvUdMKzgUnPqRHRYVaWBdDTPS1CpPmYsL+yGf0vE593Y6FgreSdrpF/wPJzt8oKyBFBSq5ImMjkqYhXmqHCgkIQHGAPXmr8xUZ48Tugc2/GywIaIASkEpCQY5l0p5i6UECWNY2puwKDi4I+PgQdHkqb7GyAp4dVU7hwvB7js+PoGOpy8UkMpaz73XKqyQUGuawFCF121+U8k/7AZ0gErBNJFODqlXG129HRrn/Pm/78sLGFn1PVAJSEgoZKOYHXY807QcUvf1z/PBGkYkQb5XzuEH/BH0RMvstn8P1pdYw5LN+Uqe5klDoQGnoSyz6QxJZLeN3fjaZ4OL1Ahs7pBhFLuO9Mr6uNH/yYiztKpSEgkc/MvXWJYAuafuM7qslSxwXUrh10iGVIbfx5Rne43CSlw06kzwVAVQSUrgEPGlhAftB2L9FBvfUhqWfHSMZw1N5e7ZIBteCPk+ajhVR9fvpFHcHdVb0h2kW4/uV53tB8n2kx13R0fmg+4IJ/1v+969MpGjQ6cB6tKiD60BZjYohf7Yg9LRAwUWY3bcT9IVy+l6d4kpCoeNQ4YeIwoU+lZ1rOiAgkOTTfB74dDRkAcQWE3quLkwgu1Yg7SG/+HO8Zf3R8zs7R0hCcE7dg7e2v+lUrwzqJ+QPo1kCaQjwkznd0z0sz/qONimPh9/TzWRyhc+q4D4Q9gFlMwJ+N6tAUtk1g49+KBkPcQlgBZ1IpsQT6ryNZQkRv5P0E1ASyhNIWfKWoN9vTBA+UoLC/wilijZJST6Ii3rbw31tSyb1RccUx8Kn6HDP7w6S2zMOzvNDGSGNLSOoj1V60u1YFjhQ2O9h8peT+IYUBIRtF4I4H/c4Ni/wdqY3S4E2uqPDWLLzmUb1WZZq2lZ4Hmw/N+VWjlm1pKdyKepblYQUlWIp3m7cQTKnu63IroKHFEi49oDlMdBvHEzyRP4usFbSHrKUipBQDo6WH3i8L/huXZvD/JnGpPQyLyJfKAkpGpIi12fS6czNZvWEaN7Ow3215g90KYtj4Fx5DuVTtx4m+HuStrfFMSPJpNzwdb+tWCrM0x8IqV6g/H6xyB/RrCs31+2YBVZgotmMP4BOVJkPy/2e7vMySwJCFsH+OY7rDDJ+N7eRPLMAtjgIuL3O0z19R8ZHae8cxwXlhh7jharQZYRUEqobUOpuVCbhoK3s+BownU9wfE7cM5KISXNZ501A88xFMtH0NoUGV/O4fQTR4ePI26EX9eEvKKoUVNpSKExWxJKEg98NPY/NBx4ICLjSgoDuDIiAAHgt92Cy31LQH4rfv5E/94aRLG3dkDMRbVoNeo1qBCYwAhG3Z9JZJuPrP+HhnCi02E3YF6b33gG+l994a/aO8J2cyMTrK1MjfKTeIFNTrCsvVll/M4sV8QMsSUHVSkJYWWCCXj7He3jQwzlPEvZDiMVBFK6vChTCPYVE3YwJ4hKP9/MmzU1mj/S9yK8NPc3a/AtjRHuy08NVPQlVsyS0FE/u1jnew60kTx0hBfIj7ynsezEZM3DIQBjLoyRL6XFM0v5O2STSR/bHcdxqAxa1DmWk1JZJCqTVWL/RuqWgaiShnjkSEJzUYM3p6+HcBwon+pe8fYkB0PfsRg0XD0BMHOK9Bud8v7CovcKtHLj/NVlyas+/JSmqpUpC1UdCW2RMOpB4kD4DVhbEPvkyte4r7IcUrjMieVcIb0CYxpHC5x8c6HP8zpLnGJrfE/2f1HDVlcJ/o9VGQj7z9nzNhDOCSQexYz9n8EzYim0k6Adv3AGRva9rhSS0J/ebFdnzSZL7L1r0j7LaSMhVThood0cx6ZTaf3N6pj8L+92bESm6BIomvkQNR7UvSSZf96gCzscmRf8oq42E5qQ8Dj49I1nCgaTzNuVboqYcUj+ShyN9Zw+SLLXGnyIkIcl8LLwkVG3pXSUrD0R6RHpDfwLF6HJkFItQ/l7PZPR7QM8kKVsMP5pXI31nTzkchxjnY+EEhdpRGioJzQ+kK90ukudBZdT2gn5IfzE70ndWqmu/RgP92hd0PpakoZ+L+lGqJDQ/mkX0PFBKS8I0RkT+3iT3D7+cxgWcj0Ch9ULVRkKSlScmEpIG1Y6J/L1JSmVDKly2wJKQklAVSUJNI3qeFYT9Po/8vUmDfZcq4HxUSagKJaGYpCEpYU6O/L1Ja78vVdD5qJJQgSAtGRMLCS3u+LlDxS/CfqoTUhIKHlILUTNSKFQSUhJSSciZhLBk5O+tiePxUElISUglIUeYIuy3TOTvTWoF/KmgktAiRf4oVRKKm4SkdapWify9Se8/thI5Uklo4SJ/lCoJxU1C0tQgG0T+3joI+qBEzjSVhJSEVBLKFp8kbaag30aRvzdJHqiJET5X1UpC5fFjKgnFTUIItpVUIu1GcTlhlgMxYxKnzFERPptKQioJRU9CwDvCSfynSN/ZHsJ+wyN5ntb8TCi3dG+1SkLl0lC1RdEX0U8IaUd6CvodSibFbGzYL2ISaspb4fKadqumOE+hJaFqI6EiSkJDmFwbkmr3SdrxFJfyFh/tJoJ+Xwm3pb7Rpoxs8NvRkRRTWOsYpCGVhOInIVR5GEENJ/XCM6E2Wb+Inq2PsB/KA83J+N5QBWPjWqTjK4pfJaECYXoBSQi4j2SZBUFC10QiDXVk6U2ChzK4HxTL3JHHuXPS1qXsdKo/FfmjbFQ71WLBgTpPU4US00QyeXjGk8lnM45/JwX6XNiSNBf0vYG3ZaFjKMlyS39EpoaXr8yRCIpFhddTcly0UczgWZWEqksSwgq3Orddav2/H8oIqfQ7nltepZWnsTTQXdD32KQ9QGFbk3oJCQi4lvymrr08aSfnOBYoHTWkyB9ltUlC5FF3MKuW9FQuRX2bwXPBq/h9kqV7/YT1GVMDfD8oKgC3A0nkOO4fcWW+8i+vwZJWo5zG4kPeAn5R5A+y2iSh0v7aR2ndxjxp16hHUoH15mkyFTt+8jRhIQ1JTNqQ8O5P2q4UVsFAbCsHkTx1xVXkNwH8PjkQEBYsGBpQZeRuMjXuCo1qlIS+IVPGJy9gZd3G0+rWlslImtzrtqQdRdlblupCMybpbYT9kbIWNd1nerynl5O2lcfzo3QUatiVF9H8tNo+yGqUhN6k+fU8WWItlkJ8eDCPZ0nrJGH/XiwJQU+UZ0mgRXjl39rimNM9ExBSxXZxfM7PaG6ZcPyOqgZJRyWh+bFt0p4P4D4255XPNZZI2ntk55n7WNIOTtqMHMYBYQyPWH7wQ1hX4lOC68mSYlpgLN8ok3BAOl+TQiUhMmEOfZN2GeWncAQO9URC8Arvwc8p9WPZk0yF1gNIVl7HFbZM2kCSVw0BpjFB+N5CHmDZfywTTYl0RlNY+jaVhAIEvFyPIVPLfc0cCBmezsuTv5LS/ZJ2nuUxM3mbc1PS/vD47FA8X5y0E1IsBHuT8ZD2CUiRnwru7We+H5QGn6p0kg41VfzsWLXgV4PywXDyg5Jz96SdlrQ7kzaMicIXWiVtL4/nvyBpT1oeg3GA3827ZPRmriVFxED1TtrHSTsxxfkvyYCASlsxyb1hfJ9VAlJJyDegoIQPDixP7Zis8Lu6A+kJ1peuHu8drggvkiwItC7A7+g6Mqb/Hyq4D/jyHMEf94opzzGQt0i+t2EgyokspTaEv5BxKVAoCeWCJkxE7cpaiaBsqlt0ZMnDF5ZhIlq3gnPAE/w5XvWx9Xi7gW1kK34u6Hx2ZhKsRKrCh74PZeORfkjS7hFup1eg/LzklYQUC8TSSfuXUMrBCr+/5/sBEcGi5CrXNMz5iFWDrxNMzDNYgliWm0s/LGx59s3oY2/EC8J6gr5wlOyjU11JKGQge95jgn6zWHr62PP9tCBjCt82ojGEibw3ZWdlQi7rYcK+eGfjdJpXjhodAm8YRDKvaHg3X5DB/UCnsxMZZ8bQAcscgkaPpGzN3NKCAAitmKhTXEkodODjuUHYF9uxDTO4J+hxYBaHFXBKoOOG4Fp4k1+T0zuTAFvO/jrFlYRiwM0ksypBF3F6hvcFPQv0Ho8HNFazWUqD3iovHcGbFn0RGrOrTnElodAB7+UbhX23z/jeEMgLT2noiEbnPE7P8lYIUlqeWQRh+XvJov8AsvP2VigJ5QKpX0uLnO7vRd4KHkTZ1+56kbdeyBz4biDvCw6s0vS3cEVAat3GOs2VhEIFtjx/E/b9OMf7hC4Ekf2dWDJC5kVfeXrgXwPzdju+1iuBvTNEuve06N8taWfqVFcSChFYHe8guVf1PYHcN6STA8n4FiFB2l1Jm1ChJAjPa6RJRaoORM3DvyZk8zZcGW616N+PjGOmIgXUT8gfoLi8WtgXeYCgkP0l4OdpzZLSmtxWIhMWgmBU5AOC5Q0Wt8lkTNgTeIuFtCIxVotAHB10RFJP8y/4HX6vU19JKAS04dVfmqYUntUv67AFh3XI5ARqLuwPa+OeOmy6HQsBt1oQ0D+UgIIF8oKfaNEfXvLH6rApCeUNBEDuIOyL+Ku+OmRBA6EjD1v0v5LcxegpCSmsAWXu1Rb9j6PKUmQosgFycU8U9m1KJih50QI9P4wr6/o6uZKQWyDUoJWwL5JzPaZDFgWwUCCXkTTbJFK6XFcQ8ulBJnXtUPJTKktJyCEQHHqgxaRW3UFcQN7osy36H072eapDJB+4aKzBi+txSkLhAiuEjV/JqWTCJhRx4e9kV5L5Vqq7GGZM5FN73jr37FcScgPkPl5Z2Bdi7R06ZFECjpcwPEjLei+etAfJJHyLmXxKgDR0spJQeOhsIaYiC+GRFEbFU0U6TGIikmJjXqRiJp9ywAm3pZJQOMAKdzvJ8yf3I1MGWhE3nuOtmRQIU/lz5ORTQguSV/hVEsoAZ5DxqpXgnaRdoUNWGEBJPcKi/z0kt5yGSD7epCElofRAvTJp9DSi1OFr8ocOW2GAWDlYv34U9ocP2ck53Su+8/0dkI8XaSgEEkJQ5JGRTcAa3oZJFY7wH3pTv9vCAVVaj7fov3VO5IM4xgfIraXOmTSUFwktQaYE8yj+OJGLefmIJh8qQHSxmKjn6vdaSGAROtCif/OM7qs2+bT3cA1n0lDWJIS67zBPf00m7WkpuXuTiKQhpLC41KI/nmuGfq9OgVrxyN+NBGRIvvYeb42bZXgPyBeFrIo7WhwztgDk41wayoKEkGsG3sFQzEKRdzj/rTaOYjIKHeeQ8f+QYEDSns/pPlG+enMyIQRF0f1hwiM5GhKiHZ20VXguIYPlxWRyZXfL4D5gDUVg6z6Wx93q6X6yJh+n0lAWk7MxSw4NRRZjOxZDLpa/CPvNzmkbthxPRCQXG86rL7aEfXkbHCNQ0fYiMkGk8NptWk8/JFv7Dxl9XUuP94P0tIdZHoP7f8nxfeRFPk6loSxIaDpLBBKcFsEH0dpibAdStgnsd+Ctyf613i0khsuS9l/+XT0S8umQtJuYfM6yGMsjmHz39nBP/VKs/rc4XpBCIB9n0lBWmRUxSB8K+26XtBcC/jCQinUti/7v8TNN9nhPTXilleYmgsf2c7w4oAZZSDqrxXmb04NMJY5KgWyH8Gj/0tGqf7XlMSggcCi5qSQL8vkrE1r7gN4ZArLbkLxKSeaSEDDGglhCT/J1r2X/9ZP2KhmFtg9AqhlmOW7QaezIq+i3/Lu/5y2MhHxgJUVYxJ2OCAjYgxfAo0ju2V4XDk9BQIOYTCsloEb8HG87lnyQQ3tq3tJQljmmdyd5xc+NeMBDRDPe229qeRwSocNPxGVpH1TDQHpYV7oeOFMOJlMN9oMMxxQJwIYzYfsEygvBadS20se+ZAJRbRZt6KZ2SdrMCskH3815SevocBzeYWmqNc+fXKWhLK0mgyxe/nkBS0K/sO7lVcvjVuIPbT0H9wCL0G38YbhUNsOtH6WNkdy9S4ZjelYGBARsRaYCyFkkt8Qi5us+y29lJJPHzArvF1V5H3NIQCCfPXmRf4bkNfG8SkNZkhCsRdLYKbzADQMmoh+YiJ6zPG4ZXo03q+Da6zFJ9PT4fHCqu4fkNdMqxcEZvjtY1qA/eytpmwhI61Gycx2BshgJ7qY7uNchTBwuyQe7kTk8f6Qe1M8K+6WylGXtP4KJ/bWw74UUNqDM3Y0nqe2KAVF9mxTX7M0E1CGD51uDP0LfWJLkuZhcAmSObIlXU935oPHBPkV2Xs4TeHFyVXsMZHG+Y/IB4OktjXsEAZ1CsvQzqaShrEnoN5Ir97Cf7hw4EeF5YK0YkELSGMwSn/RDRVXQm6h+Hxkf2CKDa7RLedws3ib1p/SBwTX80UB6Kfd8bs8fn81WF9a37SwWWSmeSCEN1Uc+JfSyIH6kLIFi/yFf0lAenrRwt/9O2Lc/hQ98DLCc2CY2b8JSVENbkS48qfbK4dmyWATWtuz/O5N+Ox67M3jrPqKCe2jDiwIk9U68DVra4vgprL+Z6GF8bKShhsgHQCric4Tnw5i+yP++wEIa6hs6CaEksFQ31NVCWsgTeDknpthCYvxh8j+2nv8HBSoKI66S8r5g6kapFnisT46chL7kjwcKfngrf1xLD9OFV+GfK7gXZExEQPWKFsf8yFLUGI9j1JA0JCGfEmD5XE543dPL/m0jDZ1gQ+J5lYFejCeRZDCQiXAdXgFjQB9Kl7wMhFNKA7oCk9M2Ke8BSlH4xTxQ9jfoAfZg6WFHkqchWYvcuhXUxmN8Xw196K2E2y4Et8JDOYtMhjNZBzQsg2vtQfOXiHqHpaQnhFLKSvw9SQJ94YbSrdbfOjDhS/ytLqtFYkFJQiVpqL/FR9Cb4sGVvOeebXncxbz/3pknV1oCeoO3Jw/U+vtvvJIh9g1xetcGIg1JJKFxFnofRNbvxFLNFI/3/TtvkYdlNK/KpaExFpJPOS4leaaBusJMIA0NFB5/nFQayksSAprzCruCoO9U1gF8GxEZ7cfSTJaZASCBnSmUGrGqSRwSbyJ/NdLgAjBDMEYYx0NTnB8fwdXk3gVgNr/ff2U8p7Yl4+bxUIpFDhkVhgv7DmYirwsIEkZcXmNX0lCeKR5mktxMuCTZJRYPAQN5tZqZwbUm86Q5zWLbOpZkviybebzvNkKSHp/y/FNYItqJJSRX6JUDAQEIfXowBQEtxFtUKcEuyIkRgsM/XUpDeeeZwQonDc/onrQtIyOip/kD+NHzxNyAVy/b1fx1Qb+O5C8joDQGqlKlL8ZmXd6Czq7wXMgTfWdk8xBkIPVIRw7q9xroA2dPSTwc/K9ODZ2EMCH6WPS/hbLz4nUFKPi286CfwCSAMhuK0bS+KSMFfSB2d/I0Nm2F/cY7uBb0kLCewYr2fspz9COTLzwmQN1xgbAvLIsS871TaSiEjHvwHh4k7LsOuY13yQpQFiN49UtH50NeIESZX1Lhyi7VEWyeoyQ02xEJlQDfFyh0oXj9zeI4kM/5Ec496PSkmUAvs1jQnElDoaT9hIj7q7DvuSxaxwasvt3IuPZXgkd4izTcwT2NFPbzpReSWMY+s5gbUkBvdiFvYyXWLWy/Tolwzh1Ecj+7T8ikzpXCmTQUCglNIHmpXPi3DIhwW1Z6cd1SbgcQvQ9XBST8murofrBFlFSEzVMS8pkcfixLlKj8Up+SHnrLGEt3I02HjRf/8TzHbOBEGgopAfplJHeK6xTptgxAXqFteIsmBfwzkL/oFg/3I5GGoFdwnZQNifglFUnHeX4fIBeEEsEF5Fq+HrYkQ1mS6E5usiLmsQ1bStgX4UP/TrmoViwNhURCELlt/FHOI38KU9+ASR2xRpLE50jajpQToz3dS156IWng6tiM3slXZBTX7Zh0ocO7P0IJCEAso7RoxAyqLEd0xdJQaKVgnuMXLwH8S+AVvFikRIScRPCOfqqe/w+zPlKu9iK/OaDz0gtJY8bGkcIGbS23YbCwfl6hikEiDcHb+5UYSAhA8NskYV+EdFwT8YQBuUBxeDSTAVJjwvKF+lRQvg/M4B4wOSQOlXlJQkpCcjThRXxRYf9hZJ/9wVYaKg+ufToWEvqOP0opjmCJIVbMZtKBpAHP8FX5+T/P6PqIyRol6LcRuQ1BkUhCkAa/JoUU/S1UFDN52zbbwXXrkobEkf2hVuZ83GJbVtKbdNA5mBoSvRACH10mW5cGripkQDCtjRsBnBI/cnj9kjRkk1YkaBIqbcu+EvaF+An/mcV1LqZC1nohuFesKeg3Vl+NCNADDbDo/7IHNcbHPD9sI/uD9rXBtgyR08hyJ8lfAh3DHWTSrSrcS0IA9EKoDdaYCT/tbwvh3Buvr0a0AD9qsQBD73gw+XE7eCvtihQyEJyJ9BTS8tCoD4XI/Et0bloBEidCShrKKHggt6wwRl/NAoHF+W4y4UxSINnd5yE9RE0EA32WJcNeTHIfCYW9NJQlVBJqeK7vbdEfO4WHQnuIGEgIcT6wfv1gcQw09RvqHLXCyMDux3XgatEAb+4zLPojgd2JIT5ITSQDDqVXd4v+qFCKyPyVdK5GKwn5CFwtCrZkqUaKn1hi+jnEh6mJaOCRY9emBBD0G0hm1VLnrAjwFfojoPtRy1jdWIcXWJv6cz0oYHeHmshewNlk8g/ZvLCnWDJSLBiIoH47oPt5TV/JfEDBwmctF1YUXngk5IeKjYRgVoQJ/lOLY1BFFJU6G+scbhDPBXIfSKtxu76OebAME5BNTTS4twSfbaImwpeBHDgoEW2Ttxk1m+5RImoQ8AGamvM9IJ4OSlcN15gL+FUh1UZ7i2Ownd2XIkhDUhPpS4H/CCxmNnEv8G9BEu9GOqfrxTdM8JMyuBaUpLB4wj/pM94K3kgmIfsgfRXzEBAk1I0tjvk+abuSnUU5NywU8ct5hkweFJso4EN48iOT3hyd33UCuph2PFYbM2nPZsmzrt/pvNpKf2Gp+UOHWQToMhF5vqnFMXBpgSVsQiwPuVDkL+l6MnXaT7U45mjelvWmODPmZYFpPLaK/LdgXSyOmcOLx9CYHrSmAC+rLxl9jw16keqIFOECSughlgQEoGDEwNgetggkNIdJ5VnL46AjeoxM4nyFIhQsm7QXyaT0tQFytF8b4wPXFOTFoX4U8qmMsDxuNzK6pRY69xUBAJlCoZOzLWmFAghnxPrQNQV6gTDt7kj2MVCofIH8KhriocgTyMWD0JnVLY9D8r/jKGJDS03BXiRMkiiL/K7lcevzCrSOfguKHABzOiIBlk5BQMi5FbWBpaaALxREhHI6tgUGV+KVaGf9JhQZAilZERfZ3PK4J4tAQEUlIWAyb7Nst2ZLkHGUO02/DYVnIAB1AJnYLtvvEBLQXlQQF5OaAr/kybw1ezXFmPydjAm/mX4rCg9ozduv7imOva0oElA1kFBpa7YD2UXelwCnL+iJ1tBvRuEQXcmEqKSp44bogKOoYE62NVXw0mE12ylpD6c4FiVukFpW08UqKgXCX04n4wPUOsXx55LJjFi4cKOaKpkAyNC3H6UrcwIfIlQzuIrsEkkpFCXAAxp5rS5N8c0hzg5FCi8s6uDUVNFEwAoCt/ZTUh6PY6HoVjO+wgaQwkdTOqsrgn1hvr+ryANUU4WT4uqk7cPbNFusz9uzE0hTgigWDJjckZ8JQajLpTgeZXn+RPbhSEpCkQDpLpFx8b8pjsWW7Fre26+m35qiDiARPZTPx6Y8HgaRTSisdLtKQh6AmtnI0/JqyuO7kSmjgpxGGo2vABYjkwIFYUBrpzzHAJ5bk6pl0GqqfNLgRcOp8ZYKRO6rmcg20G+wqoGMlPDSPy7lVv13XtAOIxOQXTWo0bnz/y8cCc6Q1zhtXSYEH0JXBD8OjcivLmBLjhAKWL9WTXkO6H+2okhTcSgJucP9vA//MOXx2JIdT6ZqaHdSxXXRASn4XJ4vu1VwHtTGgz/aiGodSCWheYEE+tAT3VbBOZblff0bSdtah7SQ38whvNicT+lDeyCBoxwPTPffV/uAKuYFtmRHkikTNKWC83QiY0GDmK6+RcXAdrztRlxhJfmnsNh1JhOjWPUFF5SE6gfSK6zP4nIlgMISzmoPJm1NHdYo0Y1M8vghvHWqBPAd2oiqxPyuJFQ5vmZxGTmsK6nhBP0QwkbG8lZNySgu8kEAdNcKz4WqwbDEQm/4iw6tkpANIC7fzluqJyo8F5TX3VmfgIDaTXV4g/wmoGge5oh8UJsNVq91KV02ByUhxf+ASqHQEx1AplJpJYBkhNARWERe4i2bvot8AQVzTzIOqDC5b+HgnO/xeeD/M0OHWEnIFaDbgTcsnBRd5HVBfBCU1x+Tyei4tA5xpkC+qCt4kYFVtJ2Dc05n4oFx4nUd4gZW5MZ9XtNRSA+I2DcykbgC0o48lLQ7WUrSctXugfg/RKdD17cDufXpgr8ZKgJ/rcOsJJTZGPLWqj/Zl2tpCBOTdi8Zk/DHOtQVAzq4HmSMBEs5PvdwlmSH6zArCeUFVHJF+Me5HiY4AP0RlNmoGvuJDrcY2BLtS0aft7aH839EpvDgIzrUSkKhoCUZT1iYYhf1dI1RPOmRq+Zd3bLNgyZklMFwrdjbg3RaAuK9LknaHWSCTxVKQsFhadYNHOeRjIh1D3CohHIbKSSmVOFYtyHjgwPigVezzyBiWEZR9x2ZF9TfR0koKjI6mrKJsIeJeSi3YVS5O0GIgLMnEod147ZqBtdEAjzkGf9H0mbqtFYSihGLk4lJg+k2y7r3MD1Dn4SA2jfJ5LyJhZgaMcEgfGYTblAuL5nhPWC7e3nSBpJJOq9QEiqEzmJ/MnmqN87pHqawxIQ2joyi+1P+zWOVhx4NeXlW59Y+aR3IuEAsmsP9QMf2DJnqLEN0yioJFRlY2Y8hYzJuHsg9QUqCnmlS2S+q2SJ27kdu+HdJHwJP4PJMgHiOUmkkpDtdoqxhO4ryNyuQSXmyYtKWz1iyaYic4Z91C5OyQkmoagCTPnLU9KDKo7QV9lIPUq4MIOMC8asOiZJQtQP6DwS5It3scjoc3oBt6D3cvtDhUBJSzA9E3Hcj42i3F29jFJUBXuePsMTzlg6HkpDCjpAQn7YnmZgnrXcmB5KHPcXEM1qHQ0lI4QYIP9iJCQn+Mk11SP4HKM2fJ+NNDguXBpIqCSk8A3lwOtNcx73OVUZKU8kEjQ7lBslnlk6LeLCQDkH0+KXsAyQmoA1prmMffttSMUoQwVkQicLgeDmSG0ruzNZpoCSkCAcwMb9O8ybTgn8OHP/gALge/xsOga0DfQaQCgJE4Uw5monmff5vNaErCSkiBPQkr3IrB7yRyz2V2zAxwYFwOf5dwsP9wCnwWzIhJXCEhIl8IhmPbbTPqMpKISsJKaoVP7OE8f4C+jSlud7OJc/nlvz/mlDdYRU/sjQzi+Z6WE+juR7XGoOlUBJSWG3vJnNTKJxDE90rFAolIYVCoSSkUCgUSkIKhUJJSKFQKJSEFAqFkpBCoVAoCSkUCiUhhUKhUBJSKBRKQgqFQuEF/yfAACbVBNmSyrCxAAAAAElFTkSuQmCC</xsl:text>
	</xsl:variable>
	
<xsl:variable name="titles" select="xalan:nodeset($titles_)"/><xsl:variable name="titles_">
				
		<title-annex lang="en">Annex </title-annex>
		<title-annex lang="fr">Annexe </title-annex>
		
			<title-annex lang="zh">Annex </title-annex>
		
		
				
		<title-edition lang="en">
			
			
				<xsl:text>Version</xsl:text>
			
		</title-edition>
		
		<title-edition lang="fr">
			
				<xsl:text>Édition </xsl:text>
			
		</title-edition>
		

		<title-toc lang="en">
			
			
				<xsl:text>Table of Contents</xsl:text>
			
			
		</title-toc>
		<title-toc lang="fr">
			
				<xsl:text>Sommaire</xsl:text>
			
			
			</title-toc>
		
			<title-toc lang="zh">Contents</title-toc>
		
		
		
		<title-page lang="en">Page</title-page>
		<title-page lang="fr">Page</title-page>
		
		<title-key lang="en">Key</title-key>
		<title-key lang="fr">Légende</title-key>
			
		<title-where lang="en">where</title-where>
		<title-where lang="fr">où</title-where>
					
		<title-descriptors lang="en">Descriptors</title-descriptors>
		
		<title-part lang="en">
			
			
			
		</title-part>
		<title-part lang="fr">
			
			
			
		</title-part>		
		<title-part lang="zh">第 # 部分:</title-part>
		
		<title-subpart lang="en">			
			
		</title-subpart>
		<title-subpart lang="fr">		
			
		</title-subpart>
		
		<title-modified lang="en">modified</title-modified>
		<title-modified lang="fr">modifiée</title-modified>
		
			<title-modified lang="zh">modified</title-modified>
		
		
		
		<title-source lang="en">
			
				<xsl:text>SOURCE</xsl:text>
						
			 
		</title-source>
		
		<title-keywords lang="en">Keywords</title-keywords>
		
		<title-deprecated lang="en">DEPRECATED</title-deprecated>
		<title-deprecated lang="fr">DEPRECATED</title-deprecated>
				
		<title-list-tables lang="en">List of Tables</title-list-tables>
		
		<title-list-figures lang="en">List of Figures</title-list-figures>
		
		<title-list-recommendations lang="en">List of Recommendations</title-list-recommendations>
		
		<title-acknowledgements lang="en">Acknowledgements</title-acknowledgements>
		
		<title-abstract lang="en">Abstract</title-abstract>
		
		<title-summary lang="en">Summary</title-summary>
		
		<title-in lang="en">in </title-in>
		
		<title-partly-supercedes lang="en">Partly Supercedes </title-partly-supercedes>
		<title-partly-supercedes lang="zh">部分代替 </title-partly-supercedes>
		
		<title-completion-date lang="en">Completion date for this manuscript</title-completion-date>
		<title-completion-date lang="zh">本稿完成日期</title-completion-date>
		
		<title-issuance-date lang="en">Issuance Date: #</title-issuance-date>
		<title-issuance-date lang="zh"># 发布</title-issuance-date>
		
		<title-implementation-date lang="en">Implementation Date: #</title-implementation-date>
		<title-implementation-date lang="zh"># 实施</title-implementation-date>

		<title-obligation-normative lang="en">normative</title-obligation-normative>
		<title-obligation-normative lang="zh">规范性附录</title-obligation-normative>
		
		<title-caution lang="en">CAUTION</title-caution>
		<title-caution lang="zh">注意</title-caution>
			
		<title-warning lang="en">WARNING</title-warning>
		<title-warning lang="zh">警告</title-warning>
		
		<title-amendment lang="en">AMENDMENT</title-amendment>
		
		<title-continued lang="en">(continued)</title-continued>
		<title-continued lang="fr">(continué)</title-continued>
		
	</xsl:variable><xsl:variable name="bibdata">
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']"/>
		<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'localized-strings']"/>
	</xsl:variable><xsl:variable name="tab_zh">　</xsl:variable><xsl:template name="getTitle">
		<xsl:param name="name"/>
		<xsl:param name="lang"/>
		<xsl:variable name="lang_">
			<xsl:choose>
				<xsl:when test="$lang != ''">
					<xsl:value-of select="$lang"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="getLang"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="language" select="normalize-space($lang_)"/>
		<xsl:variable name="title_" select="$titles/*[local-name() = $name][@lang = $language]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($title_) != ''">
				<xsl:value-of select="$title_"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$titles/*[local-name() = $name][@lang = 'en']"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="lower">abcdefghijklmnopqrstuvwxyz</xsl:variable><xsl:variable name="upper">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable><xsl:variable name="en_chars" select="concat($lower,$upper,',.`1234567890-=~!@#$%^*()_+[]{}\|?/')"/><xsl:variable name="linebreak" select="'&#8232;'"/><xsl:attribute-set name="root-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="link-style">
		
		
		
		
		
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-style">
		<xsl:attribute name="white-space">pre</xsl:attribute>
		<xsl:attribute name="wrap-option">wrap</xsl:attribute>
		
		
			<xsl:attribute name="font-family">Source Code Pro</xsl:attribute>			
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
			<xsl:attribute name="line-height">113%</xsl:attribute>
		
		
		
		
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="permission-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="permission-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-name-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="requirement-subject-style">
	</xsl:attribute-set><xsl:attribute-set name="requirement-inherit-style">
	</xsl:attribute-set><xsl:attribute-set name="recommendation-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-name-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="recommendation-label-style">
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-style">
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		

	</xsl:attribute-set><xsl:attribute-set name="example-style">
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
		
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-body-style">
					
			<xsl:attribute name="margin-left">12.5mm</xsl:attribute>
			<xsl:attribute name="margin-right">12.5mm</xsl:attribute>			
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-name-style">
					
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="keep-with-next">always</xsl:attribute>
		
		
		
		
		
		
		
		
		
		
		
				
				
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="example-p-style">
		
			<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termexample-name-style">
		
			<xsl:attribute name="padding-right">10mm</xsl:attribute>
		
		
		
				
				
	</xsl:attribute-set><xsl:attribute-set name="table-name-style">
		<xsl:attribute name="keep-with-next">always</xsl:attribute>
			
		
		
		
		
				
		
		
		
				
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="table-footer-cell-style">
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="appendix-example-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="xref-style">
		
		
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="eref-style">
		
		
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-style">
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="line-height">115%</xsl:attribute>
		
		
		
				
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:variable name="note-body-indent">10mm</xsl:variable><xsl:variable name="note-body-indent-table">5mm</xsl:variable><xsl:attribute-set name="note-name-style">
		
		
			<xsl:attribute name="padding-right">4mm</xsl:attribute>
		
		
		
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="note-p-style">
		
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
				
		
		
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-style">
		
		
			<xsl:attribute name="font-size">10pt</xsl:attribute>			
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="termnote-name-style">		
		
				
		
		
	</xsl:attribute-set><xsl:attribute-set name="quote-style">		
		
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-left">13mm</xsl:attribute>
			<xsl:attribute name="margin-right">12mm</xsl:attribute>
		
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="quote-source-style">		
		
			<xsl:attribute name="text-align">right</xsl:attribute>
			<xsl:attribute name="margin-right">25mm</xsl:attribute>
		
				
				
	</xsl:attribute-set><xsl:attribute-set name="termsource-style">
		
		
			<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="origin-style">
		
			<xsl:attribute name="color">rgb(33, 94, 159)</xsl:attribute>
			<xsl:attribute name="text-decoration">underline</xsl:attribute>
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="term-style">
		
	</xsl:attribute-set><xsl:attribute-set name="figure-name-style">
		
		
		
			<xsl:attribute name="font-size">11pt</xsl:attribute>
			<xsl:attribute name="font-weight">bold</xsl:attribute>
			<xsl:attribute name="text-align">center</xsl:attribute>
			<xsl:attribute name="margin-top">12pt</xsl:attribute>
			<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
			<xsl:attribute name="keep-with-previous">always</xsl:attribute>
				
		
		
		
		
		
		
		
		
		
		
		
		

		
		
		
			
	</xsl:attribute-set><xsl:attribute-set name="formula-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-style">
		<xsl:attribute name="text-align">center</xsl:attribute>
		
		
		
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="figure-pseudocode-p-style">
		
	</xsl:attribute-set><xsl:attribute-set name="image-graphic-style">
		
		
			<xsl:attribute name="width">100%</xsl:attribute>
			<xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
			<xsl:attribute name="scaling">uniform</xsl:attribute>
		
		
		
				

	</xsl:attribute-set><xsl:attribute-set name="tt-style">
		
			<xsl:attribute name="font-family">Source Code Pro</xsl:attribute>			
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="sourcecode-name-style">
		<xsl:attribute name="font-size">11pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="margin-bottom">12pt</xsl:attribute>
		<xsl:attribute name="keep-with-previous">always</xsl:attribute>
		
	</xsl:attribute-set><xsl:attribute-set name="domain-style">
				
	</xsl:attribute-set><xsl:attribute-set name="admitted-style">
		
		
		
	</xsl:attribute-set><xsl:attribute-set name="deprecates-style">
		
		
	</xsl:attribute-set><xsl:attribute-set name="definition-style">
		
			<xsl:attribute name="space-after">6pt</xsl:attribute>
		
		
		
	</xsl:attribute-set><xsl:variable name="color-added-text">
		<xsl:text>rgb(0, 255, 0)</xsl:text>
	</xsl:variable><xsl:attribute-set name="add-style">
		<xsl:attribute name="color">red</xsl:attribute>
		<xsl:attribute name="text-decoration">underline</xsl:attribute>
		<!-- <xsl:attribute name="color">black</xsl:attribute>
		<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
		<xsl:attribute name="padding-top">1mm</xsl:attribute>
		<xsl:attribute name="padding-bottom">0.5mm</xsl:attribute> -->
	</xsl:attribute-set><xsl:variable name="color-deleted-text">
		<xsl:text>red</xsl:text>
	</xsl:variable><xsl:attribute-set name="del-style">
		<xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
		<xsl:attribute name="text-decoration">line-through</xsl:attribute>
	</xsl:attribute-set><xsl:attribute-set name="mathml-style">
		<xsl:attribute name="font-family">STIX Two Math</xsl:attribute>
		
		
	</xsl:attribute-set><xsl:attribute-set name="list-style">
		
	</xsl:attribute-set><xsl:variable name="border-block-added">2.5pt solid rgb(0, 176, 80)</xsl:variable><xsl:variable name="border-block-deleted">2.5pt solid rgb(255, 0, 0)</xsl:variable><xsl:template name="processPrefaceSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']" mode="contents"/>
	</xsl:template><xsl:template name="processMainSectionsDefault_Contents">
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']" mode="contents"/>			
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true'] |   /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][@normative='true']]" mode="contents"/>	
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]" mode="contents"/>		
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]" mode="contents"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']" mode="contents"/>		
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')] |       /*/*[local-name()='bibliography']/*[local-name()='clause'][*[local-name()='references'][not(@normative='true')]]" mode="contents"/>
		
	</xsl:template><xsl:template name="processPrefaceSectionsDefault">
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='abstract']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='foreword']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='introduction']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name() != 'abstract' and local-name() != 'foreword' and local-name() != 'introduction' and local-name() != 'acknowledgements']"/>
		<xsl:apply-templates select="/*/*[local-name()='preface']/*[local-name()='acknowledgements']"/>
	</xsl:template><xsl:template name="processMainSectionsDefault">			
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='clause'][@type='scope']"/>
		
		<!-- Normative references  -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][@normative='true']"/>
		<!-- Terms and definitions -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name()='terms'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='terms']] |                       /*/*[local-name()='sections']/*[local-name()='definitions'] |                        /*/*[local-name()='sections']/*[local-name()='clause'][.//*[local-name()='definitions']]"/>
		<!-- Another main sections -->
		<xsl:apply-templates select="/*/*[local-name()='sections']/*[local-name() != 'terms' and                                                local-name() != 'definitions' and                                                not(@type='scope') and                                               not(local-name() = 'clause' and .//*[local-name()='terms']) and                                               not(local-name() = 'clause' and .//*[local-name()='definitions'])]"/>
		<xsl:apply-templates select="/*/*[local-name()='annex']"/>
		<!-- Bibliography -->
		<xsl:apply-templates select="/*/*[local-name()='bibliography']/*[local-name()='references'][not(@normative='true')]"/>
	</xsl:template><xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name()='br']">
		<xsl:value-of select="$linebreak"/>
	</xsl:template><xsl:template match="*[local-name()='td']//text() | *[local-name()='th']//text() | *[local-name()='dt']//text() | *[local-name()='dd']//text()" priority="1">
		<!-- <xsl:call-template name="add-zero-spaces"/> -->
		<xsl:call-template name="add-zero-spaces-java"/>
	</xsl:template><xsl:template match="*[local-name()='table']" name="table">
	
		<xsl:variable name="table-preamble">
			
			
		</xsl:variable>
		
		<xsl:variable name="table">
	
			<xsl:variable name="simple-table">	
				<xsl:call-template name="getSimpleTable"/>
			</xsl:variable>
		
			<!-- <xsl:if test="$namespace = 'bipm'">
				<fo:block>&#xA0;</fo:block>
			</xsl:if> -->
			
			<!-- $namespace = 'iso' or  -->
			
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
					
			
				
			
			<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)/*/tr[1]/td)"/>
			
			<!-- <xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="*[local-name()='thead']">
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='thead']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="calculate-columns-numbers">
							<xsl:with-param name="table-row" select="*[local-name()='tbody']/*[local-name()='tr'][1]"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable> -->
			<!-- cols-count=<xsl:copy-of select="$cols-count"/> -->
			<!-- cols-count2=<xsl:copy-of select="$cols-count2"/> -->
			
			<xsl:variable name="colwidths">
				<xsl:if test="not(*[local-name()='colgroup']/*[local-name()='col'])">
					<xsl:call-template name="calculate-column-widths">
						<xsl:with-param name="cols-count" select="$cols-count"/>
						<xsl:with-param name="table" select="$simple-table"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:variable>
			<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
			
			<!-- <xsl:variable name="colwidths2">
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="$cols-count"/>
				</xsl:call-template>
			</xsl:variable> -->
			
			<!-- cols-count=<xsl:copy-of select="$cols-count"/>
			colwidthsNew=<xsl:copy-of select="$colwidths"/>
			colwidthsOld=<xsl:copy-of select="$colwidths2"/>z -->
			
			<xsl:variable name="margin-left">
				<xsl:choose>
					<xsl:when test="sum(xalan:nodeset($colwidths)//column) &gt; 75">15</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			
			<fo:block-container margin-left="-{$margin-left}mm" margin-right="-{$margin-left}mm">			
				
				
				
							
							
							
				
				
										
				
				
				
				
				
				
				
				
				<xsl:variable name="table_width">
					<!-- for centered table always 100% (@width will be set for middle/second cell of outer table) -->
					100%
							
					
				</xsl:variable>
				
				<xsl:variable name="table_attributes">
					<attribute name="table-layout">fixed</attribute>
					<attribute name="width"><xsl:value-of select="normalize-space($table_width)"/></attribute>
					<attribute name="margin-left"><xsl:value-of select="$margin-left"/>mm</attribute>
					<attribute name="margin-right"><xsl:value-of select="$margin-left"/>mm</attribute>
					
					
					
					
					
					
									
									
									
					
									
					
					
				</xsl:variable>
				
				
				<fo:table id="{@id}" table-omit-footer-at-break="true">
					
					<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">					
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:variable name="isNoteOrFnExist" select="./*[local-name()='note'] or .//*[local-name()='fn'][local-name(..) != 'name']"/>				
					<xsl:if test="$isNoteOrFnExist = 'true'">
						<xsl:attribute name="border-bottom">0pt solid black</xsl:attribute> <!-- set 0pt border, because there is a separete table below for footer  -->
					</xsl:if>
					
					<xsl:choose>
						<xsl:when test="*[local-name()='colgroup']/*[local-name()='col']">
							<xsl:for-each select="*[local-name()='colgroup']/*[local-name()='col']">
								<fo:table-column column-width="{@width}"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="xalan:nodeset($colwidths)//column">
								<xsl:choose>
									<xsl:when test=". = 1 or . = 0">
										<fo:table-column column-width="proportional-column-width(2)"/>
									</xsl:when>
									<xsl:otherwise>
										<fo:table-column column-width="proportional-column-width({.})"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					
					<xsl:choose>
						<xsl:when test="not(*[local-name()='tbody']) and *[local-name()='thead']">
							<xsl:apply-templates select="*[local-name()='thead']" mode="process_tbody"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:table>
				
				<xsl:variable name="colgroup" select="*[local-name()='colgroup']"/>				
				<xsl:for-each select="*[local-name()='tbody']"><!-- select context to tbody -->
					<xsl:call-template name="insertTableFooterInSeparateTable">
						<xsl:with-param name="table_attributes" select="$table_attributes"/>
						<xsl:with-param name="colwidths" select="$colwidths"/>				
						<xsl:with-param name="colgroup" select="$colgroup"/>				
					</xsl:call-template>
				</xsl:for-each>
				
				<!-- insert footer as table -->
				<!-- <fo:table>
					<xsl:for-each select="xalan::nodeset($table_attributes)/attribute">
						<xsl:attribute name="{@name}">
							<xsl:value-of select="."/>
						</xsl:attribute>
					</xsl:for-each>
					
					<xsl:for-each select="xalan:nodeset($colwidths)//column">
						<xsl:choose>
							<xsl:when test=". = 1 or . = 0">
								<fo:table-column column-width="proportional-column-width(2)"/>
							</xsl:when>
							<xsl:otherwise>
								<fo:table-column column-width="proportional-column-width({.})"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</fo:table>-->
				
				
				
				
				
			</fo:block-container>
		</xsl:variable>
		
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<xsl:choose>
			<xsl:when test="@width">
	
				<!-- centered table when table name is centered (see table-name-style) -->
				
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{@width}"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<xsl:copy-of select="$table-preamble"/>
									<fo:block>
										<xsl:call-template name="setTrackChangesStyles">
											<xsl:with-param name="isAdded" select="$isAdded"/>
											<xsl:with-param name="isDeleted" select="$isDeleted"/>
										</xsl:call-template>
										<xsl:copy-of select="$table"/>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				
				
				
				
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$isAdded = 'true' or $isDeleted = 'true'">
						<xsl:copy-of select="$table-preamble"/>
						<fo:block>
							<xsl:call-template name="setTrackChangesStyles">
								<xsl:with-param name="isAdded" select="$isAdded"/>
								<xsl:with-param name="isDeleted" select="$isDeleted"/>
							</xsl:call-template>
							<xsl:copy-of select="$table"/>
						</fo:block>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$table-preamble"/>
						<xsl:copy-of select="$table"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name() = 'name']"/><xsl:template match="*[local-name()='table']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="continued"/>
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="table-name-style">
				
				
				
				
				
				<xsl:choose>
					<xsl:when test="$continued = 'true'"> 
						<!-- <xsl:if test="$namespace = 'bsi'"></xsl:if> -->
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
				
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template name="calculate-columns-numbers">
		<xsl:param name="table-row"/>
		<xsl:variable name="columns-count" select="count($table-row/*)"/>
		<xsl:variable name="sum-colspans" select="sum($table-row/*/@colspan)"/>
		<xsl:variable name="columns-with-colspan" select="count($table-row/*[@colspan])"/>
		<xsl:value-of select="$columns-count + $sum-colspans - $columns-with-colspan"/>
	</xsl:template><xsl:template name="calculate-column-widths">
		<xsl:param name="table"/>
		<xsl:param name="cols-count"/>
		<xsl:param name="curr-col" select="1"/>
		<xsl:param name="width" select="0"/>
		
		<xsl:if test="$curr-col &lt;= $cols-count">
			<xsl:variable name="widths">
				<xsl:choose>
					<xsl:when test="not($table)"><!-- this branch is not using in production, for debug only -->
						<xsl:for-each select="*[local-name()='thead']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='th'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
						</xsl:for-each>
						<xsl:for-each select="*[local-name()='tbody']//*[local-name()='tr']">
							<xsl:variable name="words">
								<xsl:call-template name="tokenize">
									<xsl:with-param name="text" select="translate(*[local-name()='td'][$curr-col],'- —:', '    ')"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:value-of select="$max_length"/>
							</width>
							
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($table)/*/tr">
							<xsl:variable name="td_text">
								<xsl:apply-templates select="td[$curr-col]" mode="td_text"/>
								
								<!-- <xsl:if test="$namespace = 'bipm'">
									<xsl:for-each select="*[local-name()='td'][$curr-col]//*[local-name()='math']">									
										<word><xsl:value-of select="normalize-space(.)"/></word>
									</xsl:for-each>
								</xsl:if> -->
								
							</xsl:variable>
							<xsl:variable name="words">
								<xsl:variable name="string_with_added_zerospaces">
									<xsl:call-template name="add-zero-spaces-java">
										<xsl:with-param name="text" select="$td_text"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:call-template name="tokenize">
									<!-- <xsl:with-param name="text" select="translate(td[$curr-col],'- —:', '    ')"/> -->
									<!-- 2009 thinspace -->
									<!-- <xsl:with-param name="text" select="translate(normalize-space($td_text),'- —:', '    ')"/> -->
									<xsl:with-param name="text" select="normalize-space(translate($string_with_added_zerospaces, '​', ' '))"/>
								</xsl:call-template>
							</xsl:variable>
							<xsl:variable name="max_length">
								<xsl:call-template name="max_length">
									<xsl:with-param name="words" select="xalan:nodeset($words)"/>
								</xsl:call-template>
							</xsl:variable>
							<width>
								<xsl:variable name="divider">
									<xsl:choose>
										<xsl:when test="td[$curr-col]/@divide">
											<xsl:value-of select="td[$curr-col]/@divide"/>
										</xsl:when>
										<xsl:otherwise>1</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:value-of select="$max_length div $divider"/>
							</width>
							
						</xsl:for-each>
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			
			<column>
				<xsl:for-each select="xalan:nodeset($widths)//width">
					<xsl:sort select="." data-type="number" order="descending"/>
					<xsl:if test="position()=1">
							<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</column>
			<xsl:call-template name="calculate-column-widths">
				<xsl:with-param name="cols-count" select="$cols-count"/>
				<xsl:with-param name="curr-col" select="$curr-col +1"/>
				<xsl:with-param name="table" select="$table"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="text()" mode="td_text">
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:value-of select="translate(., $zero-space, ' ')"/><xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='termsource']" mode="td_text">
		<xsl:value-of select="*[local-name()='origin']/@citeas"/>
	</xsl:template><xsl:template match="*[local-name()='link']" mode="td_text">
		<xsl:value-of select="@target"/>
	</xsl:template><xsl:template match="*[local-name()='math']" mode="td_text">
		<xsl:variable name="mathml">
			<xsl:for-each select="*">
				<xsl:if test="local-name() != 'unit' and local-name() != 'prefix' and local-name() != 'dimension' and local-name() != 'quantity'">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="math_text" select="normalize-space(xalan:nodeset($mathml))"/>
		<xsl:value-of select="translate($math_text, ' ', '#')"/><!-- mathml images as one 'word' without spaces -->
	</xsl:template><xsl:template match="*[local-name()='table2']"/><xsl:template match="*[local-name()='thead']"/><xsl:template match="*[local-name()='thead']" mode="process">
		<xsl:param name="cols-count"/>
		<!-- font-weight="bold" -->
		<fo:table-header>
			
			
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template><xsl:template name="table-header-title">
		<xsl:param name="cols-count"/>
		<!-- row for title -->
		<fo:table-row>
			<fo:table-cell number-columns-spanned="{$cols-count}" border-left="1.5pt solid white" border-right="1.5pt solid white" border-top="1.5pt solid white" border-bottom="1.5pt solid black">
				
				<xsl:apply-templates select="ancestor::*[local-name()='table']/*[local-name()='name']" mode="presentation">
					<xsl:with-param name="continued">true</xsl:with-param>
				</xsl:apply-templates>
				<xsl:for-each select="ancestor::*[local-name()='table'][1]">
					<xsl:call-template name="fn_name_display"/>
				</xsl:for-each>
				
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="process_tbody">		
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tfoot']"/><xsl:template match="*[local-name()='tfoot']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="insertTableFooter">
		<xsl:param name="cols-count"/>
		<xsl:if test="../*[local-name()='tfoot']">
			<fo:table-footer>			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
			</fo:table-footer>
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooter2">
		<xsl:param name="cols-count"/>
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		<xsl:if test="../*[local-name()='tfoot'] or           $isNoteOrFnExist = 'true'">
		
			<fo:table-footer>
			
				<xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/>
				
				<!-- if there are note(s) or fn(s) then create footer row -->
				<xsl:if test="$isNoteOrFnExist = 'true'">
				
					
				
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							<!-- except gb -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- show Note under table in preface (ex. abstract) sections -->
							<!-- empty, because notes show at page side in main sections -->
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">										
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>										
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
						</fo:table-cell>
					</fo:table-row>
					
				</xsl:if>
			</fo:table-footer>
		
		</xsl:if>
	</xsl:template><xsl:template name="insertTableFooterInSeparateTable">
		<xsl:param name="table_attributes"/>
		<xsl:param name="colwidths"/>
		<xsl:param name="colgroup"/>
		
		<xsl:variable name="isNoteOrFnExist" select="../*[local-name()='note'] or ..//*[local-name()='fn'][local-name(..) != 'name']"/>
		
		<xsl:if test="$isNoteOrFnExist = 'true'">
		
			<xsl:variable name="cols-count">
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:value-of select="count(xalan:nodeset($colgroup)//*[local-name()='col'])"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="count(xalan:nodeset($colwidths)//column)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
			<fo:table keep-with-previous="always">
				<xsl:for-each select="xalan:nodeset($table_attributes)/attribute">
					<xsl:choose>
						<xsl:when test="@name = 'border-top'">
							<xsl:attribute name="{@name}">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:when test="@name = 'border'">
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
							<xsl:attribute name="border-top">0pt solid black</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="{@name}"><xsl:value-of select="."/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<xsl:choose>
					<xsl:when test="xalan:nodeset($colgroup)//*[local-name()='col']">
						<xsl:for-each select="xalan:nodeset($colgroup)//*[local-name()='col']">
							<fo:table-column column-width="{@width}"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
				<fo:table-body>
					<fo:table-row>
						<fo:table-cell border="solid black 1pt" padding-left="1mm" padding-right="1mm" padding-top="1mm" number-columns-spanned="{$cols-count}">
							
							
							
							
							<!-- fn will be processed inside 'note' processing -->
							
							
							
							
							
							
							
							
							<!-- for BSI (not PAS) display Notes before footnotes -->
							
							
							<!-- except gb  -->
							
								<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
							
							
							<!-- <xsl:if test="$namespace = 'bipm'">
								<xsl:choose>
									<xsl:when test="ancestor::*[local-name()='preface']">
										show Note under table in preface (ex. abstract) sections
										<xsl:apply-templates select="../*[local-name()='note']" mode="process"/>
									</xsl:when>
									<xsl:otherwise>
										empty, because notes show at page side in main sections
									<fo:block/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if> -->
							
							
							<!-- horizontal row separator -->
							
							
							<!-- fn processing -->
							<xsl:call-template name="fn_display"/>
							
							
							<!-- for PAS display Notes after footnotes -->
							
							
						</fo:table-cell>
					</fo:table-row>
				</fo:table-body>
				
			</fo:table>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='tbody']">
		
		<xsl:variable name="cols-count">
			<xsl:choose>
				<xsl:when test="../*[local-name()='thead']">					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="../*[local-name()='thead']/*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>					
					<xsl:call-template name="calculate-columns-numbers">
						<xsl:with-param name="table-row" select="./*[local-name()='tr'][1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		
		
		<xsl:apply-templates select="../*[local-name()='thead']" mode="process">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:apply-templates>
		
		<xsl:call-template name="insertTableFooter">
			<xsl:with-param name="cols-count" select="$cols-count"/>
		</xsl:call-template>
		
		<fo:table-body>
			

			<xsl:apply-templates/>
			<!-- <xsl:apply-templates select="../*[local-name()='tfoot']" mode="process"/> -->
		
		</fo:table-body>
		
	</xsl:template><xsl:template match="*[local-name()='tr']">
		<xsl:variable name="parent-name" select="local-name(..)"/>
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:table-row min-height="4mm">
				<xsl:if test="$parent-name = 'thead'">
					<xsl:attribute name="font-weight">bold</xsl:attribute>
					
					
					
					
					
					
				</xsl:if>
				<xsl:if test="$parent-name = 'tfoot'">
					
					
					
				</xsl:if>
				
				
				
				
				
				
				
				
				<!-- <xsl:if test="$namespace = 'bipm'">
					<xsl:attribute name="height">8mm</xsl:attribute>
				</xsl:if> -->
				
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']">
		<fo:table-cell text-align="{@align}" font-weight="bold" border="solid black 1pt" padding-left="1mm" display-align="center">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>center</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			
			
			
			
			
			
			
			
			
			
			
			
			
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="display-align">
		<xsl:if test="@valign">
			<xsl:attribute name="display-align">
				<xsl:choose>
					<xsl:when test="@valign = 'top'">before</xsl:when>
					<xsl:when test="@valign = 'middle'">center</xsl:when>
					<xsl:when test="@valign = 'bottom'">after</xsl:when>
					<xsl:otherwise>before</xsl:otherwise>
				</xsl:choose>					
			</xsl:attribute>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name()='td']">
		<fo:table-cell text-align="{@align}" display-align="center" border="solid black 1pt" padding-left="1mm">
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:call-template name="setAlignment"/>
						<!-- <xsl:value-of select="@align"/> -->
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="$lang = 'ar'">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			<xsl:if test=".//*[local-name() = 'table']">
				<xsl:attribute name="padding-right">1mm</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			<fo:block>
								
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']" priority="2"/><xsl:template match="*[local-name()='table']/*[local-name()='note']" mode="process">
		
		
			<fo:block font-size="10pt" margin-bottom="12pt">
				
				
				
				
				
				
				
				
				<!-- Table's note name (NOTE, for example) -->

				<fo:inline padding-right="2mm">
					
				
					
					
					
					
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						
				</fo:inline>
				
				
				
				<xsl:apply-templates mode="process"/>
			</fo:block>
		
	</xsl:template><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='name']" mode="process"/><xsl:template match="*[local-name()='table']/*[local-name()='note']/*[local-name()='p']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template name="fn_display">
		<xsl:variable name="references">
			<xsl:for-each select="..//*[local-name()='fn'][local-name(..) != 'name']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					
					
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		<xsl:for-each select="xalan:nodeset($references)//fn">
			<xsl:variable name="reference" select="@reference"/>
			<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
				<fo:block margin-bottom="12pt">
				
					
					
					
					
					
					
					<fo:inline font-size="80%" padding-right="5mm" id="{@id}">
						
						
						
						
						
						
						
						
						<xsl:value-of select="@reference"/>
						
						
						
					</fo:inline>
					<fo:inline>
						
						<!-- <xsl:apply-templates /> -->
						<xsl:copy-of select="./node()"/>
					</fo:inline>
				</fo:block>
			</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_name_display">
		<!-- <xsl:variable name="references">
			<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates />
				</fn>
			</xsl:for-each>
		</xsl:variable>
		$references=<xsl:copy-of select="$references"/> -->
		<xsl:for-each select="*[local-name()='name']//*[local-name()='fn']">
			<xsl:variable name="reference" select="@reference"/>
			<fo:block id="{@reference}_{ancestor::*[@id][1]/@id}"><xsl:value-of select="@reference"/></fo:block>
			<fo:block margin-bottom="12pt">
				<xsl:apply-templates/>
			</fo:block>
		</xsl:for-each>
	</xsl:template><xsl:template name="fn_display_figure">
		<xsl:variable name="key_iso">
			 <!-- and (not(@class) or @class !='pseudocode') -->
		</xsl:variable>
		<xsl:variable name="references">
			<xsl:for-each select=".//*[local-name()='fn'][not(parent::*[local-name()='name'])]">
				<fn reference="{@reference}" id="{@reference}_{ancestor::*[@id][1]/@id}">
					<xsl:apply-templates/>
				</fn>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- current hierarchy is 'figure' element -->
		<xsl:variable name="following_dl_colwidths">
			<xsl:if test="*[local-name() = 'dl']"><!-- if there is a 'dl', then set the same columns width as for 'dl' -->
				<xsl:variable name="html-table">
					<xsl:variable name="doc_ns">
						
					</xsl:variable>
					<xsl:variable name="ns">
						<xsl:choose>
							<xsl:when test="normalize-space($doc_ns)  != ''">
								<xsl:value-of select="normalize-space($doc_ns)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-before(name(/*), '-')"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
					<!-- <xsl:element name="{$ns}:table"> -->
						<xsl:for-each select="*[local-name() = 'dl'][1]">
							<tbody>
								<xsl:apply-templates mode="dl"/>
							</tbody>
						</xsl:for-each>
					<!-- </xsl:element> -->
				</xsl:variable>
				
				<xsl:call-template name="calculate-column-widths">
					<xsl:with-param name="cols-count" select="2"/>
					<xsl:with-param name="table" select="$html-table"/>
				</xsl:call-template>
				
			</xsl:if>
		</xsl:variable>
		
		
		<xsl:variable name="maxlength_dt">
			<xsl:for-each select="*[local-name() = 'dl'][1]">
				<xsl:call-template name="getMaxLength_dt"/>			
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:if test="xalan:nodeset($references)//fn">
			<fo:block>
				<fo:table width="95%" table-layout="fixed">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="font-size">10pt</xsl:attribute>
						
					</xsl:if>
					<xsl:choose>
						<!-- if there 'dl', then set same columns width -->
						<xsl:when test="xalan:nodeset($following_dl_colwidths)//column">
							<xsl:call-template name="setColumnWidth_dl">
								<xsl:with-param name="colwidths" select="$following_dl_colwidths"/>								
								<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>								
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<fo:table-column column-width="15%"/>
							<fo:table-column column-width="85%"/>
						</xsl:otherwise>
					</xsl:choose>
					<fo:table-body>
						<xsl:for-each select="xalan:nodeset($references)//fn">
							<xsl:variable name="reference" select="@reference"/>
							<xsl:if test="not(preceding-sibling::*[@reference = $reference])"> <!-- only unique reference puts in note-->
								<fo:table-row>
									<fo:table-cell>
										<fo:block>
											<fo:inline font-size="80%" padding-right="5mm" vertical-align="super" id="{@id}">
												
												<xsl:value-of select="@reference"/>
											</fo:inline>
										</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block text-align="justify" margin-bottom="12pt">
											
											<xsl:if test="normalize-space($key_iso) = 'true'">
												<xsl:attribute name="margin-bottom">0</xsl:attribute>
											</xsl:if>
											
											<!-- <xsl:apply-templates /> -->
											<xsl:copy-of select="./node()"/>
										</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</xsl:if>
						</xsl:for-each>
					</fo:table-body>
				</fo:table>
			</fo:block>
		</xsl:if>
		
	</xsl:template><xsl:template match="*[local-name()='fn']">
		<!-- <xsl:variable name="namespace" select="substring-before(name(/*), '-')"/> -->
		<fo:inline font-size="80%" keep-with-previous.within-line="always">
			
			
			
			
			
			
			
			
			
			
			<fo:basic-link internal-destination="{@reference}_{ancestor::*[@id][1]/@id}" fox:alt-text="{@reference}"> <!-- @reference   | ancestor::*[local-name()='clause'][1]/@id-->
				
				
				<xsl:value-of select="@reference"/>
				
				
			</fo:basic-link>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='fn']/*[local-name()='p']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='dl']">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container>
			
				<xsl:if test="not(ancestor::*[local-name() = 'quote'])">
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
				</xsl:if>
			
			
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<fo:block-container>
				
					<xsl:attribute name="margin-left">0mm</xsl:attribute>
					<xsl:attribute name="margin-right">0mm</xsl:attribute>
				
				
				<xsl:variable name="parent" select="local-name(..)"/>
				
				<xsl:variable name="key_iso">
					 <!-- and  (not(../@class) or ../@class !='pseudocode') -->
				</xsl:variable>
				
				<xsl:choose>
					<xsl:when test="$parent = 'formula' and count(*[local-name()='dt']) = 1"> <!-- only one component -->
						
						
							<fo:block margin-bottom="12pt" text-align="left">
								
								<xsl:variable name="title-where">
									
									
										<xsl:call-template name="getTitle">
											<xsl:with-param name="name" select="'title-where'"/>
										</xsl:call-template>
									
								</xsl:variable>
								<xsl:value-of select="$title-where"/><xsl:text> </xsl:text>
								<xsl:apply-templates select="*[local-name()='dt']/*"/>
								<xsl:text/>
								<xsl:apply-templates select="*[local-name()='dd']/*" mode="inline"/>
							</fo:block>
						
					</xsl:when>
					<xsl:when test="$parent = 'formula'"> <!-- a few components -->
						<fo:block margin-bottom="12pt" text-align="left">
							
							
							
							
							<xsl:variable name="title-where">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-where'"/>
									</xsl:call-template>
																
							</xsl:variable>
							<xsl:value-of select="$title-where"/>
						</fo:block>
					</xsl:when>
					<xsl:when test="$parent = 'figure' and  (not(../@class) or ../@class !='pseudocode')">
						<fo:block font-weight="bold" text-align="left" margin-bottom="12pt" keep-with-next="always">
							
							
							
							
							<xsl:variable name="title-key">
								
								
									<xsl:call-template name="getTitle">
										<xsl:with-param name="name" select="'title-key'"/>
									</xsl:call-template>
								
							</xsl:variable>
							<xsl:value-of select="$title-key"/>
						</fo:block>
					</xsl:when>
				</xsl:choose>
				
				<!-- a few components -->
				<xsl:if test="not($parent = 'formula' and count(*[local-name()='dt']) = 1)">
					<fo:block>
						
						
						
						
						<fo:block>
							
							
							
							
							<fo:table width="95%" table-layout="fixed">
								
								<xsl:choose>
									<xsl:when test="normalize-space($key_iso) = 'true' and $parent = 'formula'">
										<!-- <xsl:attribute name="font-size">11pt</xsl:attribute> -->
									</xsl:when>
									<xsl:when test="normalize-space($key_iso) = 'true'">
										<xsl:attribute name="font-size">10pt</xsl:attribute>
										
									</xsl:when>
								</xsl:choose>
								<!-- create virtual html table for dl/[dt and dd] -->
								<xsl:variable name="html-table">
									<xsl:variable name="doc_ns">
										
									</xsl:variable>
									<xsl:variable name="ns">
										<xsl:choose>
											<xsl:when test="normalize-space($doc_ns)  != ''">
												<xsl:value-of select="normalize-space($doc_ns)"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring-before(name(/*), '-')"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<!-- <xsl:variable name="ns" select="substring-before(name(/*), '-')"/> -->
									<!-- <xsl:element name="{$ns}:table"> -->
										<tbody>
											<xsl:apply-templates mode="dl"/>
										</tbody>
									<!-- </xsl:element> -->
								</xsl:variable>
								<!-- html-table<xsl:copy-of select="$html-table"/> -->
								<xsl:variable name="colwidths">
									<xsl:call-template name="calculate-column-widths">
										<xsl:with-param name="cols-count" select="2"/>
										<xsl:with-param name="table" select="$html-table"/>
									</xsl:call-template>
								</xsl:variable>
								<!-- colwidths=<xsl:copy-of select="$colwidths"/> -->
								<xsl:variable name="maxlength_dt">							
									<xsl:call-template name="getMaxLength_dt"/>							
								</xsl:variable>
								<xsl:call-template name="setColumnWidth_dl">
									<xsl:with-param name="colwidths" select="$colwidths"/>							
									<xsl:with-param name="maxlength_dt" select="$maxlength_dt"/>
								</xsl:call-template>
								<fo:table-body>
									<xsl:apply-templates>
										<xsl:with-param name="key_iso" select="normalize-space($key_iso)"/>
									</xsl:apply-templates>
								</fo:table-body>
							</fo:table>
						</fo:block>
					</fo:block>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template name="setColumnWidth_dl">
		<xsl:param name="colwidths"/>		
		<xsl:param name="maxlength_dt"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name()='dl']"><!-- second level, i.e. inlined table -->
				<fo:table-column column-width="50%"/>
				<fo:table-column column-width="50%"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- to set width check most wide chars like `W` -->
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 2"> <!-- if dt contains short text like t90, a, etc -->
						<fo:table-column column-width="7%"/>
						<fo:table-column column-width="93%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 5"> <!-- if dt contains short text like ABC, etc -->
						<fo:table-column column-width="15%"/>
						<fo:table-column column-width="85%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 7"> <!-- if dt contains short text like ABCDEF, etc -->
						<fo:table-column column-width="20%"/>
						<fo:table-column column-width="80%"/>
					</xsl:when>
					<xsl:when test="normalize-space($maxlength_dt) != '' and number($maxlength_dt) &lt;= 10"> <!-- if dt contains short text like ABCDEFEF, etc -->
						<fo:table-column column-width="25%"/>
						<fo:table-column column-width="75%"/>
					</xsl:when>
					<!-- <xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.7">
						<fo:table-column column-width="60%"/>
						<fo:table-column column-width="40%"/>
					</xsl:when> -->
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 1.3">
						<fo:table-column column-width="50%"/>
						<fo:table-column column-width="50%"/>
					</xsl:when>
					<xsl:when test="xalan:nodeset($colwidths)/column[1] div xalan:nodeset($colwidths)/column[2] &gt; 0.5">
						<fo:table-column column-width="40%"/>
						<fo:table-column column-width="60%"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="xalan:nodeset($colwidths)//column">
							<xsl:choose>
								<xsl:when test=". = 1 or . = 0">
									<fo:table-column column-width="proportional-column-width(2)"/>
								</xsl:when>
								<xsl:otherwise>
									<fo:table-column column-width="proportional-column-width({.})"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- <fo:table-column column-width="15%"/>
				<fo:table-column column-width="85%"/> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getMaxLength_dt">
		<xsl:variable name="lengths">
			<xsl:for-each select="*[local-name()='dt']">
				<xsl:variable name="maintext_length" select="string-length(normalize-space(.))"/>
				<xsl:variable name="attributes">
					<xsl:for-each select=".//@open"><xsl:value-of select="."/></xsl:for-each>
					<xsl:for-each select=".//@close"><xsl:value-of select="."/></xsl:for-each>
				</xsl:variable>
				<length><xsl:value-of select="string-length(normalize-space(.)) + string-length($attributes)"/></length>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="maxLength">
			<!-- <xsl:for-each select="*[local-name()='dt']">
				<xsl:sort select="string-length(normalize-space(.))" data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="string-length(normalize-space(.))"/>
				</xsl:if>
			</xsl:for-each> -->
			<xsl:for-each select="xalan:nodeset($lengths)/length">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position() = 1">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!-- <xsl:message>DEBUG:<xsl:value-of select="$maxLength"/></xsl:message> -->
		<xsl:value-of select="$maxLength"/>
	</xsl:template><xsl:template match="*[local-name()='dl']/*[local-name()='note']" priority="2">
		<xsl:param name="key_iso"/>
		
		<!-- <tr>
			<td>NOTE</td>
			<td>
				<xsl:apply-templates />
			</td>
		</tr>
		 -->
		<fo:table-row>
			<fo:table-cell>
				<fo:block margin-top="6pt">
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
					</xsl:if>
					<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					<xsl:apply-templates/>
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='dt']" mode="dl">
		<tr>
			<td>
				<xsl:apply-templates/>
			</td>
			<td>
				
				
					<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
				
			</td>
		</tr>
		
	</xsl:template><xsl:template match="*[local-name()='dt']">
		<xsl:param name="key_iso"/>
		
		<fo:table-row>
			
			
			<fo:table-cell>
				
				<fo:block margin-top="6pt">
					
					
					<xsl:if test="normalize-space($key_iso) = 'true'">
						<xsl:attribute name="margin-top">0</xsl:attribute>
						
					</xsl:if>
					
					
					
					
					
					
					
					<xsl:apply-templates/>
					<!-- <xsl:if test="$namespace = 'gb'">
						<xsl:if test="ancestor::*[local-name()='formula']">
							<xsl:text>—</xsl:text>
						</xsl:if>
					</xsl:if> -->
				</fo:block>
			</fo:table-cell>
			<fo:table-cell>
				<fo:block>
					
					<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
						<xsl:if test="local-name(*[1]) != 'stem'">
							<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
						</xsl:if>
					</xsl:if> -->
					
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					
				</fo:block>
			</fo:table-cell>
		</fo:table-row>
		<!-- <xsl:if test="$namespace = 'nist-cswp'  or $namespace = 'nist-sp'">
			<xsl:if test="local-name(*[1]) = 'stem'">
				<fo:table-row>
				<fo:table-cell>
					<fo:block margin-top="6pt">
						<xsl:if test="normalize-space($key_iso) = 'true'">
							<xsl:attribute name="margin-top">0</xsl:attribute>
						</xsl:if>
						<xsl:text>&#xA0;</xsl:text>
					</fo:block>
				</fo:table-cell>
				<fo:table-cell>
					<fo:block>
						<xsl:apply-templates select="following-sibling::*[local-name()='dd'][1]" mode="process"/>
					</fo:block>
				</fo:table-cell>
			</fo:table-row>
			</xsl:if>
		</xsl:if> -->
	</xsl:template><xsl:template match="*[local-name()='dd']" mode="dl"/><xsl:template match="*[local-name()='dd']" mode="dl_process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']"/><xsl:template match="*[local-name()='dd']" mode="process">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='dd']/*[local-name()='p']" mode="inline">
		<fo:inline><xsl:text> </xsl:text><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='em']">
		<fo:inline font-style="italic">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='strong'] | *[local-name()='b']">
		<fo:inline font-weight="bold">
			
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='padding']">
		<fo:inline padding-right="{@value}"> </fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sup']">
		<fo:inline font-size="80%" vertical-align="super">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='sub']">
		<fo:inline font-size="80%" vertical-align="sub">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='tt']">
		<fo:inline xsl:use-attribute-sets="tt-style">
			<xsl:variable name="_font-size">
				10
				
				
				
				
				
				
				
				
				
				
				
				
				
				
						
			</xsl:variable>
			<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
			<xsl:if test="$font-size != ''">
				<xsl:attribute name="font-size">
					<xsl:choose>
						<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
						<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='underline']">
		<fo:inline text-decoration="underline">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='add']">
		<xsl:choose>
			<xsl:when test="@amendment">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">A</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@amendment"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:when test="@corrigenda">
				<fo:inline>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
					<xsl:apply-templates/>
					<xsl:call-template name="insertTag">
						<xsl:with-param name="type">closing</xsl:with-param>
						<xsl:with-param name="kind">C</xsl:with-param>
						<xsl:with-param name="value"><xsl:value-of select="@corrigenda"/></xsl:with-param>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="add-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="insertTag">
		<xsl:param name="type"/>
		<xsl:param name="kind"/>
		<xsl:param name="value"/>
		<xsl:variable name="add_width" select="string-length($value) * 20"/>
		<xsl:variable name="maxwidth" select="60 + $add_width"/>
			<fo:instream-foreign-object fox:alt-text="OpeningTag" baseline-shift="-20%"><!-- alignment-baseline="middle" -->
				<!-- <xsl:attribute name="width">7mm</xsl:attribute>
				<xsl:attribute name="content-height">100%</xsl:attribute> -->
				<xsl:attribute name="height">5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="{$maxwidth + 32}" height="80">
					<g>
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="transform">scale(-1 1) translate(-<xsl:value-of select="$maxwidth + 32"/>,0)</xsl:attribute>
						</xsl:if>
						<polyline points="0,0 {$maxwidth},0 {$maxwidth + 30},40 {$maxwidth},80 0,80 " stroke="black" stroke-width="5" fill="white"/>
						<line x1="0" y1="0" x2="0" y2="80" stroke="black" stroke-width="20"/>
					</g>
					<text font-family="Arial" x="15" y="57" font-size="40pt">
						<xsl:if test="$type = 'closing'">
							<xsl:attribute name="x">25</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="$kind"/><tspan dy="10" font-size="30pt"><xsl:value-of select="$value"/></tspan>
					</text>
				</svg>
			</fo:instream-foreign-object>
	</xsl:template><xsl:template match="*[local-name()='del']">
		<fo:inline xsl:use-attribute-sets="del-style">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='hi']">
		<fo:inline background-color="yellow">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="text()[ancestor::*[local-name()='smallcap']]">
		<xsl:variable name="text" select="normalize-space(.)"/>
		<fo:inline font-size="75%">
				<xsl:if test="string-length($text) &gt; 0">
					<xsl:call-template name="recursiveSmallCaps">
						<xsl:with-param name="text" select="$text"/>
					</xsl:call-template>
				</xsl:if>
			</fo:inline> 
	</xsl:template><xsl:template name="recursiveSmallCaps">
    <xsl:param name="text"/>
    <xsl:variable name="char" select="substring($text,1,1)"/>
    <!-- <xsl:variable name="upperCase" select="translate($char, $lower, $upper)"/> -->
		<xsl:variable name="upperCase" select="java:toUpperCase(java:java.lang.String.new($char))"/>
    <xsl:choose>
      <xsl:when test="$char=$upperCase">
        <fo:inline font-size="{100 div 0.75}%">
          <xsl:value-of select="$upperCase"/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$upperCase"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="string-length($text) &gt; 1">
      <xsl:call-template name="recursiveSmallCaps">
        <xsl:with-param name="text" select="substring($text,2)"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template><xsl:template name="tokenize">
		<xsl:param name="text"/>
		<xsl:param name="separator" select="' '"/>
		<xsl:choose>
			<xsl:when test="not(contains($text, $separator))">
				<word>
					<xsl:variable name="str_no_en_chars" select="normalize-space(translate($text, $en_chars, ''))"/>
					<xsl:variable name="len_str_no_en_chars" select="string-length($str_no_en_chars)"/>
					<xsl:variable name="len_str_tmp" select="string-length(normalize-space($text))"/>
					<xsl:variable name="len_str">
						<xsl:choose>
							<xsl:when test="normalize-space(translate($text, $upper, '')) = ''"> <!-- english word in CAPITAL letters -->
								<xsl:value-of select="$len_str_tmp * 1.5"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$len_str_tmp"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable> 
					
					<!-- <xsl:if test="$len_str_no_en_chars div $len_str &gt; 0.8">
						<xsl:message>
							div=<xsl:value-of select="$len_str_no_en_chars div $len_str"/>
							len_str=<xsl:value-of select="$len_str"/>
							len_str_no_en_chars=<xsl:value-of select="$len_str_no_en_chars"/>
						</xsl:message>
					</xsl:if> -->
					<!-- <len_str_no_en_chars><xsl:value-of select="$len_str_no_en_chars"/></len_str_no_en_chars>
					<len_str><xsl:value-of select="$len_str"/></len_str> -->
					<xsl:choose>
						<xsl:when test="$len_str_no_en_chars div $len_str &gt; 0.8"> <!-- means non-english string -->
							<xsl:value-of select="$len_str - $len_str_no_en_chars"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$len_str"/>
						</xsl:otherwise>
					</xsl:choose>
				</word>
			</xsl:when>
			<xsl:otherwise>
				<word>
					<xsl:value-of select="string-length(normalize-space(substring-before($text, $separator)))"/>
				</word>
				<xsl:call-template name="tokenize">
					<xsl:with-param name="text" select="substring-after($text, $separator)"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="max_length">
		<xsl:param name="words"/>
		<xsl:for-each select="$words//word">
				<xsl:sort select="." data-type="number" order="descending"/>
				<xsl:if test="position()=1">
						<xsl:value-of select="."/>
				</xsl:if>
		</xsl:for-each>
	</xsl:template><xsl:template name="add-zero-spaces-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| )','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces-link-java">
		<xsl:param name="text" select="."/>
		<!-- add zero-width space (#x200B) after characters: dash, dot, colon, equal, underscore, em dash, thin space  -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new($text),'(-|\.|:|=|_|—| |,)','$1​')"/>
	</xsl:template><xsl:template name="add-zero-spaces">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-chars">-</xsl:variable>
		<xsl:variable name="zero-space-after-dot">.</xsl:variable>
		<xsl:variable name="zero-space-after-colon">:</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space-after-underscore">_</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-chars)">
				<xsl:value-of select="substring-before($text, $zero-space-after-chars)"/>
				<xsl:value-of select="$zero-space-after-chars"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-chars)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-dot)">
				<xsl:value-of select="substring-before($text, $zero-space-after-dot)"/>
				<xsl:value-of select="$zero-space-after-dot"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-dot)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-colon)">
				<xsl:value-of select="substring-before($text, $zero-space-after-colon)"/>
				<xsl:value-of select="$zero-space-after-colon"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-colon)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-underscore)">
				<xsl:value-of select="substring-before($text, $zero-space-after-underscore)"/>
				<xsl:value-of select="$zero-space-after-underscore"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-underscore)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="add-zero-spaces-equal">
		<xsl:param name="text" select="."/>
		<xsl:variable name="zero-space-after-equals">==========</xsl:variable>
		<xsl:variable name="zero-space-after-equal">=</xsl:variable>
		<xsl:variable name="zero-space">​</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($text, $zero-space-after-equals)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equals)"/>
				<xsl:value-of select="$zero-space-after-equals"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equals)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($text, $zero-space-after-equal)">
				<xsl:value-of select="substring-before($text, $zero-space-after-equal)"/>
				<xsl:value-of select="$zero-space-after-equal"/>
				<xsl:value-of select="$zero-space"/>
				<xsl:call-template name="add-zero-spaces-equal">
					<xsl:with-param name="text" select="substring-after($text, $zero-space-after-equal)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getSimpleTable">
		<xsl:variable name="simple-table">
		
			<!-- Step 1. colspan processing -->
			<xsl:variable name="simple-table-colspan">
				<tbody>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</tbody>
			</xsl:variable>
			
			<!-- Step 2. rowspan processing -->
			<xsl:variable name="simple-table-rowspan">
				<xsl:apply-templates select="xalan:nodeset($simple-table-colspan)" mode="simple-table-rowspan"/>
			</xsl:variable>
			
			<xsl:copy-of select="xalan:nodeset($simple-table-rowspan)"/>
					
			<!-- <xsl:choose>
				<xsl:when test="current()//*[local-name()='th'][@colspan] or current()//*[local-name()='td'][@colspan] ">
					
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="current()"/>
				</xsl:otherwise>
			</xsl:choose> -->
		</xsl:variable>
		<xsl:copy-of select="$simple-table"/>
	</xsl:template><xsl:template match="*[local-name()='thead'] | *[local-name()='tbody']" mode="simple-table-colspan">
		<xsl:apply-templates mode="simple-table-colspan"/>
	</xsl:template><xsl:template match="*[local-name()='fn']" mode="simple-table-colspan"/><xsl:template match="*[local-name()='th'] | *[local-name()='td']" mode="simple-table-colspan">
		<xsl:choose>
			<xsl:when test="@colspan">
				<xsl:variable name="td">
					<xsl:element name="td">
						<xsl:attribute name="divide"><xsl:value-of select="@colspan"/></xsl:attribute>
						<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
						<xsl:apply-templates mode="simple-table-colspan"/>
					</xsl:element>
				</xsl:variable>
				<xsl:call-template name="repeatNode">
					<xsl:with-param name="count" select="@colspan"/>
					<xsl:with-param name="node" select="$td"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="td">
					<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
					<xsl:apply-templates mode="simple-table-colspan"/>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@colspan" mode="simple-table-colspan"/><xsl:template match="*[local-name()='tr']" mode="simple-table-colspan">
		<xsl:element name="tr">
			<xsl:apply-templates select="@*" mode="simple-table-colspan"/>
			<xsl:apply-templates mode="simple-table-colspan"/>
		</xsl:element>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-colspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-colspan"/>
		</xsl:copy>
	</xsl:template><xsl:template name="repeatNode">
		<xsl:param name="count"/>
		<xsl:param name="node"/>
		
		<xsl:if test="$count &gt; 0">
			<xsl:call-template name="repeatNode">
				<xsl:with-param name="count" select="$count - 1"/>
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
			<xsl:copy-of select="$node"/>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="simple-table-rowspan"/>
		</xsl:copy>
	</xsl:template><xsl:template match="tbody" mode="simple-table-rowspan">
		<xsl:copy>
				<xsl:copy-of select="tr[1]"/>
				<xsl:apply-templates select="tr[2]" mode="simple-table-rowspan">
						<xsl:with-param name="previousRow" select="tr[1]"/>
				</xsl:apply-templates>
		</xsl:copy>
	</xsl:template><xsl:template match="tr" mode="simple-table-rowspan">
		<xsl:param name="previousRow"/>
		<xsl:variable name="currentRow" select="."/>
	
		<xsl:variable name="normalizedTDs">
				<xsl:for-each select="xalan:nodeset($previousRow)//td">
						<xsl:choose>
								<xsl:when test="@rowspan &gt; 1">
										<xsl:copy>
												<xsl:attribute name="rowspan">
														<xsl:value-of select="@rowspan - 1"/>
												</xsl:attribute>
												<xsl:copy-of select="@*[not(name() = 'rowspan')]"/>
												<xsl:copy-of select="node()"/>
										</xsl:copy>
								</xsl:when>
								<xsl:otherwise>
										<xsl:copy-of select="$currentRow/td[1 + count(current()/preceding-sibling::td[not(@rowspan) or (@rowspan = 1)])]"/>
								</xsl:otherwise>
						</xsl:choose>
				</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="newRow">
				<xsl:copy>
						<xsl:copy-of select="$currentRow/@*"/>
						<xsl:copy-of select="xalan:nodeset($normalizedTDs)"/>
				</xsl:copy>
		</xsl:variable>
		<xsl:copy-of select="$newRow"/>

		<xsl:apply-templates select="following-sibling::tr[1]" mode="simple-table-rowspan">
				<xsl:with-param name="previousRow" select="$newRow"/>
		</xsl:apply-templates>
	</xsl:template><xsl:template name="getLang">
		<xsl:variable name="language_current" select="normalize-space(//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language_current_2" select="normalize-space(xalan:nodeset($bibdata)//*[local-name()='bibdata']//*[local-name()='language'][@current = 'true'])"/>
		<xsl:variable name="language">
			<xsl:choose>
				<xsl:when test="$language_current != ''">
					<xsl:value-of select="$language_current"/>
				</xsl:when>
				<xsl:when test="$language_current_2 != ''">
					<xsl:value-of select="$language_current_2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="//*[local-name()='bibdata']//*[local-name()='language']"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$language = 'English'">en</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalizeWords">
		<xsl:param name="str"/>
		<xsl:variable name="str2" select="translate($str, '-', ' ')"/>
		<xsl:choose>
			<xsl:when test="contains($str2, ' ')">
				<xsl:variable name="substr" select="substring-before($str2, ' ')"/>
				<!-- <xsl:value-of select="translate(substring($substr, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($substr, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$substr"/>
				</xsl:call-template>
				<xsl:text> </xsl:text>
				<xsl:call-template name="capitalizeWords">
					<xsl:with-param name="str" select="substring-after($str2, ' ')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="translate(substring($str2, 1, 1), $lower, $upper)"/>
				<xsl:value-of select="substring($str2, 2)"/> -->
				<xsl:call-template name="capitalize">
					<xsl:with-param name="str" select="$str2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="java:toUpperCase(java:java.lang.String.new(substring($str, 1, 1)))"/>
		<xsl:value-of select="substring($str, 2)"/>		
	</xsl:template><xsl:template match="mathml:math">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		
		<fo:inline xsl:use-attribute-sets="mathml-style">
			
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<xsl:variable name="mathml">
				<xsl:apply-templates select="." mode="mathml"/>
			</xsl:variable>
			<fo:instream-foreign-object fox:alt-text="Math">
				
				
				<!-- <xsl:copy-of select="."/> -->
				<xsl:copy-of select="xalan:nodeset($mathml)"/>
			</fo:instream-foreign-object>			
		</fo:inline>
	</xsl:template><xsl:template match="@*|node()" mode="mathml">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mtext" mode="mathml">
		<xsl:copy>
			<!-- replace start and end spaces to non-break space -->
			<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),'(^ )|( $)',' ')"/>
		</xsl:copy>
	</xsl:template><xsl:template match="mathml:mi[. = ',' and not(following-sibling::*[1][local-name() = 'mtext' and text() = ' '])]" mode="mathml">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()" mode="mathml"/>
		</xsl:copy>
		<xsl:choose>
			<!-- if in msub, then don't add space -->
			<xsl:when test="ancestor::mathml:mrow[parent::mathml:msub and preceding-sibling::*[1][self::mathml:mrow]]"/>
			<!-- if next char in digit,  don't add space -->
			<xsl:when test="translate(substring(following-sibling::*[1]/text(),1,1),'0123456789','') = ''"/>
			<xsl:otherwise>
				<mathml:mspace width="0.5ex"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="mathml:math/*[local-name()='unit']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='prefix']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='dimension']" mode="mathml"/><xsl:template match="mathml:math/*[local-name()='quantity']" mode="mathml"/><xsl:template match="*[local-name()='localityStack']"/><xsl:template match="*[local-name()='link']" name="link">
		<xsl:variable name="target">
			<xsl:choose>
				<xsl:when test="@updatetype = 'true'">
					<xsl:value-of select="concat(normalize-space(@target), '.pdf')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="target_text">
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space(@target), 'mailto:')">
					<xsl:value-of select="normalize-space(substring-after(@target, 'mailto:'))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(@target)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline xsl:use-attribute-sets="link-style">
			
			
			
			<xsl:choose>
				<xsl:when test="$target_text = ''">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<fo:basic-link external-destination="{$target}" fox:alt-text="{$target}">
						<xsl:choose>
							<xsl:when test="normalize-space(.) = ''">
								<xsl:call-template name="add-zero-spaces-link-java">
									<xsl:with-param name="text" select="$target_text"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<!-- output text from <link>text</link> -->
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:basic-link>
				</xsl:otherwise>
			</xsl:choose>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-style">
			<xsl:apply-templates select="*[local-name()='title']" mode="process"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name()='appendix']/*[local-name()='title']"/><xsl:template match="*[local-name()='appendix']/*[local-name()='title']" mode="process">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name()='appendix']//*[local-name()='example']" priority="2">
		<fo:block id="{@id}" xsl:use-attribute-sets="appendix-example-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'callout']">		
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}">&lt;<xsl:apply-templates/>&gt;</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'annotation']">
		<xsl:variable name="annotation-id" select="@id"/>
		<xsl:variable name="callout" select="//*[@target = $annotation-id]/text()"/>		
		<fo:block id="{$annotation-id}" white-space="nowrap">			
			<fo:inline>				
				<xsl:apply-templates>
					<xsl:with-param name="callout" select="concat('&lt;', $callout, '&gt; ')"/>
				</xsl:apply-templates>
			</fo:inline>
		</fo:block>		
	</xsl:template><xsl:template match="*[local-name() = 'annotation']/*[local-name() = 'p']">
		<xsl:param name="callout"/>
		<fo:inline id="{@id}">
			<!-- for first p in annotation, put <x> -->
			<xsl:if test="not(preceding-sibling::*[local-name() = 'p'])"><xsl:value-of select="$callout"/></xsl:if>
			<xsl:apply-templates/>
		</fo:inline>		
	</xsl:template><xsl:template match="*[local-name() = 'modification']">
		<xsl:variable name="title-modified">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-modified'"/>
				</xsl:call-template>
			
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$lang = 'zh'"><xsl:text>、</xsl:text><xsl:value-of select="$title-modified"/><xsl:text>—</xsl:text></xsl:when>
			<xsl:otherwise><xsl:text>, </xsl:text><xsl:value-of select="$title-modified"/><xsl:text> — </xsl:text></xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'xref']">
		<fo:basic-link internal-destination="{@target}" fox:alt-text="{@target}" xsl:use-attribute-sets="xref-style">
			
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'formula']" name="formula">
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">	
				<fo:block id="{@id}" xsl:use-attribute-sets="formula-style">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'dt']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']/*[local-name() = 'stem']">
		<fo:inline>
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'formula']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<xsl:text>(</xsl:text><xsl:apply-templates/><xsl:text>)</xsl:text>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'note']" name="note">
	
		<fo:block-container id="{@id}" xsl:use-attribute-sets="note-style">
			
			
			
			
			
			<fo:block-container margin-left="0mm">
				
				
				
				
					<xsl:if test="ancestor::csa:ul or ancestor::csa:ol and not(ancestor::csa:note[1]/following-sibling::*)">
						<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
					</xsl:if>
				
				
				

				
					<fo:block>
						
						
						
						
						
						
						<fo:inline xsl:use-attribute-sets="note-name-style">
							
							<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
						</fo:inline>
						<xsl:apply-templates/>
					</fo:block>
				
				
			</fo:block-container>
		</fo:block-container>
		
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$num = 1">
				<fo:inline xsl:use-attribute-sets="note-p-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="note-p-style">						
					<xsl:apply-templates/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termnote-style">			
			
			<fo:inline xsl:use-attribute-sets="termnote-name-style">
				
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			</fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name'] |               *[local-name() = 'termnote']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'note']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'name']" mode="presentation">
		<xsl:param name="sfx"/>
		<xsl:variable name="suffix">
			<xsl:choose>
				<xsl:when test="$sfx != ''">
					<xsl:value-of select="$sfx"/>					
				</xsl:when>
				<xsl:otherwise>
					
					
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="normalize-space() != ''">
			<xsl:apply-templates/>
			<xsl:value-of select="$suffix"/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termnote']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'terms']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']">
		<fo:block id="{@id}" xsl:use-attribute-sets="term-style">
			
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'term']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline>
				<xsl:apply-templates/>
				<!-- <xsl:if test="$namespace = 'gb' or $namespace = 'ogc'">
					<xsl:text>.</xsl:text>
				</xsl:if> -->
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']" name="figure">
		<xsl:variable name="isAdded" select="@added"/>
		<xsl:variable name="isDeleted" select="@deleted"/>
		<fo:block-container id="{@id}">			
			
			<xsl:call-template name="setTrackChangesStyles">
				<xsl:with-param name="isAdded" select="$isAdded"/>
				<xsl:with-param name="isDeleted" select="$isDeleted"/>
			</xsl:call-template>
			
			<fo:block>
				
				<xsl:apply-templates/>
			</fo:block>
			<xsl:call-template name="fn_display_figure"/>
			<xsl:for-each select="*[local-name() = 'note']">
				<xsl:call-template name="note"/>
			</xsl:for-each>
			
			
				<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
			
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
		<xsl:apply-templates select="*[local-name() = 'name']" mode="presentation"/>
	</xsl:template><xsl:template match="*[local-name() = 'figure'][@class = 'pseudocode']//*[local-name() = 'p']">
		<fo:block xsl:use-attribute-sets="figure-pseudocode-p-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'image']">
		<xsl:variable name="isAdded" select="../@added"/>
		<xsl:variable name="isDeleted" select="../@deleted"/>
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'title']">
				<fo:inline padding-left="1mm" padding-right="1mm">
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" vertical-align="middle"/>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">
					
					<xsl:variable name="src">
						<xsl:call-template name="image_src"/>
					</xsl:variable>
					
					<xsl:choose>
						<xsl:when test="$isDeleted = 'true'">
							<!-- enclose in svg -->
							<fo:instream-foreign-object fox:alt-text="Image {@alt}">
								<xsl:attribute name="width">100%</xsl:attribute>
								<xsl:attribute name="content-height">100%</xsl:attribute>
								<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
								<xsl:attribute name="scaling">uniform</xsl:attribute>
								
								
									<xsl:apply-templates select="." mode="cross_image"/>
									
							</fo:instream-foreign-object>
						</xsl:when>
						<xsl:otherwise>
							<fo:external-graphic src="{$src}" fox:alt-text="Image {@alt}" xsl:use-attribute-sets="image-graphic-style"/>
						</xsl:otherwise>
					</xsl:choose>
					
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="image_src">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="@src"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'image']" mode="cross_image">
		<xsl:choose>
			<xsl:when test="@mimetype = 'image/svg+xml' and $images/images/image[@id = current()/@id]">
				<xsl:variable name="src">
					<xsl:value-of select="$images/images/image[@id = current()/@id]/@src"/>
				</xsl:variable>
				<xsl:variable name="width" select="document($src)/@width"/>
				<xsl:variable name="height" select="document($src)/@height"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:when test="not(starts-with(@src, 'data:'))">
				<xsl:variable name="src">
					<xsl:value-of select="concat('url(file:',$basepath, @src, ')')"/>
				</xsl:variable>
				<xsl:variable name="file" select="java:java.io.File.new(@src)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($file)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{$src}" style="overflow:visible;"/>
				</svg>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="base64String" select="substring-after(@src, 'base64,')"/>
				<xsl:variable name="decoder" select="java:java.util.Base64.getDecoder()"/>
				<xsl:variable name="fileContent" select="java:decode($decoder, $base64String)"/>
				<xsl:variable name="bis" select="java:java.io.ByteArrayInputStream.new($fileContent)"/>
				<xsl:variable name="bufferedImage" select="java:javax.imageio.ImageIO.read($bis)"/>
				<xsl:variable name="width" select="java:getWidth($bufferedImage)"/>
				<!-- width=<xsl:value-of select="$width"/> -->
				<xsl:variable name="height" select="java:getHeight($bufferedImage)"/>
				<!-- height=<xsl:value-of select="$height"/> -->
				<svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" style="enable-background:new 0 0 595.28 841.89;" height="{$height}" width="{$width}" viewBox="0 0 {$width} {$height}" y="0px" x="0px" id="Layer_1" version="1.1">
					<image xmlns:xlink="http://www.w3.org/1999/xlink" xlink:href="{@src}" height="{$height}" width="{$width}" style="overflow:visible;"/>
					<xsl:call-template name="svg_cross">
						<xsl:with-param name="width" select="$width"/>
						<xsl:with-param name="height" select="$height"/>
					</xsl:call-template>
				</svg>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="svg_cross">
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="0" x2="{$width}" y2="{$height}" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
		<line xmlns="http://www.w3.org/2000/svg" x1="0" y1="{$height}" x2="{$width}" y2="0" style="stroke: rgb(255, 0, 0); stroke-width:4px; "/>
	</xsl:template><xsl:variable name="figure_name_height">14</xsl:variable><xsl:variable name="width_effective" select="$pageWidth - $marginLeftRight1 - $marginLeftRight2"/><xsl:variable name="height_effective" select="$pageHeight - $marginTop - $marginBottom - $figure_name_height"/><xsl:variable name="image_dpi" select="96"/><xsl:variable name="width_effective_px" select="$width_effective div 25.4 * $image_dpi"/><xsl:variable name="height_effective_px" select="$height_effective div 25.4 * $image_dpi"/><xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image']) and *[local-name() = 'svg']]/*[local-name() = 'name']/*[local-name() = 'bookmark']" priority="2"/><xsl:template match="*[local-name() = 'figure'][not(*[local-name() = 'image'])]/*[local-name() = 'svg']" priority="2" name="image_svg">
		<xsl:param name="name"/>
		
		<xsl:variable name="svg_content">
			<xsl:apply-templates select="." mode="svg_update"/>
		</xsl:variable>
		
		<xsl:variable name="alt-text">
			<xsl:choose>
				<xsl:when test="normalize-space(../*[local-name() = 'name']) != ''">
					<xsl:value-of select="../*[local-name() = 'name']"/>
				</xsl:when>
				<xsl:when test="normalize-space($name) != ''">
					<xsl:value-of select="$name"/>
				</xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]">
				<fo:block>
					<xsl:variable name="width" select="@width"/>
					<xsl:variable name="height" select="@height"/>
					
					<xsl:variable name="scale_x">
						<xsl:choose>
							<xsl:when test="$width &gt; $width_effective_px">
								<xsl:value-of select="$width_effective_px div $width"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="scale_y">
						<xsl:choose>
							<xsl:when test="$height * $scale_x &gt; $height_effective_px">
								<xsl:value-of select="$height_effective_px div ($height * $scale_x)"/>
							</xsl:when>
							<xsl:otherwise>1</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					
					<xsl:variable name="scale">
						<xsl:choose>
							<xsl:when test="$scale_y != 1">
								<xsl:value-of select="$scale_x * $scale_y"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$scale_x"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					 
					<xsl:variable name="width_scale" select="round($width * $scale)"/>
					<xsl:variable name="height_scale" select="round($height * $scale)"/>
					
					<fo:table table-layout="fixed" width="100%">
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-column column-width="{$width_scale}px"/>
						<fo:table-column column-width="proportional-column-width(1)"/>
						<fo:table-body>
							<fo:table-row>
								<fo:table-cell column-number="2">
									<fo:block>
										<fo:block-container width="{$width_scale}px" height="{$height_scale}px">
											<xsl:if test="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
												<fo:block line-height="0" font-size="0">
													<xsl:for-each select="../*[local-name() = 'name']/*[local-name() = 'bookmark']">
														<xsl:call-template name="bookmark"/>
													</xsl:for-each>
												</fo:block>
											</xsl:if>
											<fo:block text-depth="0" line-height="0" font-size="0">

												<fo:instream-foreign-object fox:alt-text="{$alt-text}">
													<xsl:attribute name="width">100%</xsl:attribute>
													<xsl:attribute name="content-height">100%</xsl:attribute>
													<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
													<xsl:attribute name="scaling">uniform</xsl:attribute>

													<xsl:apply-templates select="xalan:nodeset($svg_content)" mode="svg_remove_a"/>
												</fo:instream-foreign-object>
											</fo:block>
											
											<xsl:apply-templates select=".//*[local-name() = 'a'][*[local-name() = 'rect'] or *[local-name() = 'polygon'] or *[local-name() = 'circle'] or *[local-name() = 'ellipse']]" mode="svg_imagemap_links">
												<xsl:with-param name="scale" select="$scale"/>
											</xsl:apply-templates>
										</fo:block-container>
									</fo:block>
								</fo:table-cell>
							</fo:table-row>
						</fo:table-body>
					</fo:table>
				</fo:block>
				
			</xsl:when>
			<xsl:otherwise>
				<fo:block xsl:use-attribute-sets="image-style">
					<fo:instream-foreign-object fox:alt-text="{$alt-text}">
						<xsl:attribute name="width">100%</xsl:attribute>
						<xsl:attribute name="content-height">100%</xsl:attribute>
						<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
						<!-- effective height 297 - 27.4 - 13 =  256.6 -->
						<!-- effective width 210 - 12.5 - 25 = 172.5 -->
						<!-- effective height / width = 1.48, 1.4 - with title -->
						<xsl:if test="@height &gt; (@width * 1.4)"> <!-- for images with big height -->
							<xsl:variable name="width" select="((@width * 1.4) div @height) * 100"/>
							<xsl:attribute name="width"><xsl:value-of select="$width"/>%</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="scaling">uniform</xsl:attribute>
						<xsl:copy-of select="$svg_content"/>
					</fo:instream-foreign-object>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@*|node()" mode="svg_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_update"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'image']/@href" mode="svg_update">
		<xsl:attribute name="href" namespace="http://www.w3.org/1999/xlink">
			<xsl:value-of select="."/>
		</xsl:attribute>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'image'][@mimetype = 'image/svg+xml' and @src[not(starts-with(., 'data:image/'))]]" priority="2">
		<xsl:variable name="svg_content" select="document(@src)"/>
		<xsl:variable name="name" select="ancestor::*[local-name() = 'figure']/*[local-name() = 'name']"/>
		<xsl:for-each select="xalan:nodeset($svg_content)/node()">
			<xsl:call-template name="image_svg">
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template><xsl:template match="@*|node()" mode="svg_remove_a">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="svg_remove_a"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'a']" mode="svg_remove_a">
		<xsl:apply-templates mode="svg_remove_a"/>
	</xsl:template><xsl:template match="*[local-name() = 'a']" mode="svg_imagemap_links">
		<xsl:param name="scale"/>
		<xsl:variable name="dest">
			<xsl:choose>
				<xsl:when test="starts-with(@href, '#')">
					<xsl:value-of select="substring-after(@href, '#')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:for-each select="./*[local-name() = 'rect']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor(@x * $scale)"/>
				<xsl:with-param name="top" select="floor(@y * $scale)"/>
				<xsl:with-param name="width" select="floor(@width * $scale)"/>
				<xsl:with-param name="height" select="floor(@height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="./*[local-name() = 'polygon']">
			<xsl:variable name="points">
				<xsl:call-template name="split">
					<xsl:with-param name="pText" select="@points"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="x_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 1]">
					<xsl:sort select="." data-type="number"/>
					<x><xsl:value-of select="."/></x>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="y_coords">
				<xsl:for-each select="xalan:nodeset($points)//item[position() mod 2 = 0]">
					<xsl:sort select="." data-type="number"/>
					<y><xsl:value-of select="."/></y>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="x" select="xalan:nodeset($x_coords)//x[1]"/>
			<xsl:variable name="y" select="xalan:nodeset($y_coords)//y[1]"/>
			<xsl:variable name="width" select="xalan:nodeset($x_coords)//x[last()] - $x"/>
			<xsl:variable name="height" select="xalan:nodeset($y_coords)//y[last()] - $y"/>
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor($x * $scale)"/>
				<xsl:with-param name="top" select="floor($y * $scale)"/>
				<xsl:with-param name="width" select="floor($width * $scale)"/>
				<xsl:with-param name="height" select="floor($height * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		
		<xsl:for-each select="./*[local-name() = 'circle']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @r) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @r) * $scale)"/>
				<xsl:with-param name="width" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@r * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="./*[local-name() = 'ellipse']">
			<xsl:call-template name="insertSVGMapLink">
				<xsl:with-param name="left" select="floor((@cx - @rx) * $scale)"/>
				<xsl:with-param name="top" select="floor((@cy - @ry) * $scale)"/>
				<xsl:with-param name="width" select="floor(@rx * 2 * $scale)"/>
				<xsl:with-param name="height" select="floor(@ry * 2 * $scale)"/>
				<xsl:with-param name="dest" select="$dest"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template><xsl:template name="insertSVGMapLink">
		<xsl:param name="left"/>
		<xsl:param name="top"/>
		<xsl:param name="width"/>
		<xsl:param name="height"/>
		<xsl:param name="dest"/>
		<fo:block-container position="absolute" left="{$left}px" top="{$top}px" width="{$width}px" height="{$height}px">
		 <fo:block font-size="1pt">
			<fo:basic-link internal-destination="{$dest}" fox:alt-text="svg link">
				<fo:inline-container inline-progression-dimension="100%">
					<fo:block-container height="{$height - 1}px" width="100%">
						<!-- DEBUG <xsl:if test="local-name()='polygon'">
							<xsl:attribute name="background-color">magenta</xsl:attribute>
						</xsl:if> -->
					<fo:block> </fo:block></fo:block-container>
				</fo:inline-container>
			</fo:basic-link>
		 </fo:block>
	  </fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="contents">		
		<xsl:apply-templates mode="contents"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |                *[local-name() = 'table']/*[local-name() = 'name'] |               *[local-name() = 'permission']/*[local-name() = 'name'] |               *[local-name() = 'recommendation']/*[local-name() = 'name'] |               *[local-name() = 'requirement']/*[local-name() = 'name']" mode="bookmarks">		
		<xsl:apply-templates mode="bookmarks"/>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="contents" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'figure' or local-name() = 'table' or local-name() = 'permission' or local-name() = 'recommendation' or local-name() = 'requirement']/*[local-name() = 'name']/text()" mode="bookmarks" priority="2">
		<xsl:value-of select="."/>
	</xsl:template><xsl:template match="node()" mode="contents">
		<xsl:apply-templates mode="contents"/>
	</xsl:template><xsl:template match="node()" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template match="*[local-name() = 'title' or local-name() = 'name']//*[local-name() = 'stem']" mode="contents">
		<xsl:apply-templates select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" mode="contents" priority="3"/><xsl:template match="*[local-name() = 'stem']" mode="bookmarks">
		<xsl:apply-templates mode="bookmarks"/>
	</xsl:template><xsl:template name="addBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)//item">
			<fo:bookmark-tree>
				<xsl:choose>
					<xsl:when test="xalan:nodeset($contents)/doc">
						<xsl:choose>
							<xsl:when test="count(xalan:nodeset($contents)/doc) &gt; 1">
								<xsl:for-each select="xalan:nodeset($contents)/doc">
									<fo:bookmark internal-destination="{contents/item[1]/@id}" starting-state="hide">
										<xsl:if test="@bundle = 'true'">
											<xsl:attribute name="internal-destination"><xsl:value-of select="@firstpage_id"/></xsl:attribute>
										</xsl:if>
										<fo:bookmark-title>
											<xsl:choose>
												<xsl:when test="not(normalize-space(@bundle) = 'true')"> <!-- 'bundle' means several different documents (not language versions) in one xml -->
													<xsl:variable name="bookmark-title_">
														<xsl:call-template name="getLangVersion">
															<xsl:with-param name="lang" select="@lang"/>
															<xsl:with-param name="doctype" select="@doctype"/>
															<xsl:with-param name="title" select="@title-part"/>
														</xsl:call-template>
													</xsl:variable>
													<xsl:choose>
														<xsl:when test="normalize-space($bookmark-title_) != ''">
															<xsl:value-of select="normalize-space($bookmark-title_)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:choose>
																<xsl:when test="@lang = 'en'">English</xsl:when>
																<xsl:when test="@lang = 'fr'">Français</xsl:when>
																<xsl:when test="@lang = 'de'">Deutsche</xsl:when>
																<xsl:otherwise><xsl:value-of select="@lang"/> version</xsl:otherwise>
															</xsl:choose>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="@title-part"/>
												</xsl:otherwise>
											</xsl:choose>
										</fo:bookmark-title>
										
										<xsl:apply-templates select="contents/item" mode="bookmark"/>
										
										<xsl:call-template name="insertFigureBookmarks">
											<xsl:with-param name="contents" select="contents"/>
										</xsl:call-template>
										
										<xsl:call-template name="insertTableBookmarks">
											<xsl:with-param name="contents" select="contents"/>
											<xsl:with-param name="lang" select="@lang"/>
										</xsl:call-template>
										
									</fo:bookmark>
									
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="xalan:nodeset($contents)/doc">
								
									<xsl:apply-templates select="contents/item" mode="bookmark"/>
									
									<xsl:call-template name="insertFigureBookmarks">
										<xsl:with-param name="contents" select="contents"/>
									</xsl:call-template>
										
									<xsl:call-template name="insertTableBookmarks">
										<xsl:with-param name="contents" select="contents"/>
										<xsl:with-param name="lang" select="@lang"/>
									</xsl:call-template>
									
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="xalan:nodeset($contents)/contents/item" mode="bookmark"/>				
					</xsl:otherwise>
				</xsl:choose>
				
				
				
				
				
				
				
				
			</fo:bookmark-tree>
		</xsl:if>
	</xsl:template><xsl:template name="insertFigureBookmarks">
		<xsl:param name="contents"/>
		<xsl:if test="xalan:nodeset($contents)/figure">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/figure[1]/@id}" starting-state="hide">
				<fo:bookmark-title>Figures</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/figure">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="insertTableBookmarks">
		<xsl:param name="contents"/>
		<xsl:param name="lang"/>
		<xsl:if test="xalan:nodeset($contents)/table">
			<fo:bookmark internal-destination="{xalan:nodeset($contents)/table[1]/@id}" starting-state="hide">
				<fo:bookmark-title>
					<xsl:choose>
						<xsl:when test="$lang = 'fr'">Tableaux</xsl:when>
						<xsl:otherwise>Tables</xsl:otherwise>
					</xsl:choose>
				</fo:bookmark-title>
				<xsl:for-each select="xalan:nodeset($contents)/table">
					<fo:bookmark internal-destination="{@id}">
						<fo:bookmark-title>
							<xsl:value-of select="normalize-space(title)"/>
						</fo:bookmark-title>
					</fo:bookmark>
				</xsl:for-each>
			</fo:bookmark>	
		</xsl:if>
	</xsl:template><xsl:template name="getLangVersion">
		<xsl:param name="lang"/>
		<xsl:param name="doctype" select="''"/>
		<xsl:param name="title" select="''"/>
		<xsl:choose>
			<xsl:when test="$lang = 'en'">
				
				
				</xsl:when>
			<xsl:when test="$lang = 'fr'">
				
				
			</xsl:when>
			<xsl:when test="$lang = 'de'">Deutsche</xsl:when>
			<xsl:otherwise><xsl:value-of select="$lang"/> version</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="item" mode="bookmark">
		<xsl:choose>
			<xsl:when test="@id != ''">
				<fo:bookmark internal-destination="{@id}" starting-state="hide">
					<fo:bookmark-title>
						<xsl:if test="@section != ''">
							<xsl:value-of select="@section"/> 
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="normalize-space(title)"/>
					</fo:bookmark-title>
					<xsl:apply-templates mode="bookmark"/>
				</fo:bookmark>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="bookmark"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="title" mode="bookmark"/><xsl:template match="text()" mode="bookmark"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'name'] |         *[local-name() = 'image']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">			
			<fo:block xsl:use-attribute-sets="figure-name-style">
				
				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'fn']" priority="2"/><xsl:template match="*[local-name() = 'figure']/*[local-name() = 'note']"/><xsl:template match="*[local-name() = 'title']" mode="contents_item">
		<xsl:apply-templates mode="contents_item"/>
		<!-- <xsl:text> </xsl:text> -->
	</xsl:template><xsl:template name="getSection">
		<xsl:value-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
		<!-- 
		<xsl:for-each select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/preceding-sibling::node()">
			<xsl:value-of select="."/>
		</xsl:for-each>
		-->
		
	</xsl:template><xsl:template name="getName">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'title']/*[local-name() = 'tab']">
				<xsl:copy-of select="*[local-name() = 'title']/*[local-name() = 'tab'][1]/following-sibling::node()"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="*[local-name() = 'title']/node()"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertTitleAsListItem">
		<xsl:param name="provisional-distance-between-starts" select="'9.5mm'"/>
		<xsl:variable name="section">						
			<xsl:for-each select="..">
				<xsl:call-template name="getSection"/>
			</xsl:for-each>
		</xsl:variable>							
		<fo:list-block provisional-distance-between-starts="{$provisional-distance-between-starts}">						
			<fo:list-item>
				<fo:list-item-label end-indent="label-end()">
					<fo:block>
						<xsl:value-of select="$section"/>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="body-start()">
					<fo:block>						
						<xsl:choose>
							<xsl:when test="*[local-name() = 'tab']">
								<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates/>
							</xsl:otherwise>
						</xsl:choose>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
	</xsl:template><xsl:template name="extractSection">
		<xsl:value-of select="*[local-name() = 'tab'][1]/preceding-sibling::node()"/>
	</xsl:template><xsl:template name="extractTitle">
		<xsl:choose>
				<xsl:when test="*[local-name() = 'tab']">
					<xsl:apply-templates select="*[local-name() = 'tab'][1]/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'fn']" mode="contents"/><xsl:template match="*[local-name() = 'fn']" mode="bookmarks"/><xsl:template match="*[local-name() = 'fn']" mode="contents_item"/><xsl:template match="*[local-name() = 'tab']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'strong']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'em']" mode="contents_item">
		<xsl:copy>
			<xsl:apply-templates mode="contents_item"/>
		</xsl:copy>		
	</xsl:template><xsl:template match="*[local-name() = 'stem']" mode="contents_item">
		<xsl:copy-of select="."/>
	</xsl:template><xsl:template match="*[local-name() = 'br']" mode="contents_item">
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']" name="sourcecode">
	
		<fo:block-container margin-left="0mm">
			<xsl:copy-of select="@id"/>
			
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:attribute name="margin-left">
					<xsl:choose>
						<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				
			</xsl:if>
			<fo:block-container margin-left="0mm">
		
				
				
				<fo:block xsl:use-attribute-sets="sourcecode-style">
					<xsl:variable name="_font-size">
						10
												
						
						
						
						
						
						
						
								
						
						
						
												
						
								
				</xsl:variable>
				<xsl:variable name="font-size" select="normalize-space($_font-size)"/>		
				<xsl:if test="$font-size != ''">
					<xsl:attribute name="font-size">
						<xsl:choose>
							<xsl:when test="ancestor::*[local-name()='note']"><xsl:value-of select="$font-size * 0.91"/>pt</xsl:when>
							<xsl:otherwise><xsl:value-of select="$font-size"/>pt</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</xsl:if>
				
				<xsl:apply-templates/>			
			</fo:block>
				
			
				<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
				
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='sourcecode']/text()" priority="2">
		<xsl:variable name="text">
			<xsl:call-template name="add-zero-spaces-equal"/>
		</xsl:variable>
		<xsl:call-template name="add-zero-spaces-java">
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:template><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'sourcecode']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">		
			<fo:block xsl:use-attribute-sets="sourcecode-name-style">				
				<xsl:apply-templates/>
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']">
		<fo:block id="{@id}" xsl:use-attribute-sets="permission-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="permission-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'permission']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="permission-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']">
		<fo:block id="{@id}" xsl:use-attribute-sets="requirement-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='label']" mode="presentation"/>
			<xsl:apply-templates select="@obligation" mode="presentation"/>
			<xsl:apply-templates select="*[local-name()='subject']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="requirement-name-style">
				
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'label']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/@obligation" mode="presentation">
			<fo:block>
				<fo:inline padding-right="3mm">Obligation</fo:inline><xsl:value-of select="."/>
			</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']"/><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'subject']" mode="presentation">
		<fo:block xsl:use-attribute-sets="requirement-subject-style">
			<xsl:text>Target Type </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'requirement']/*[local-name() = 'inherit']">
		<fo:block xsl:use-attribute-sets="requirement-inherit-style">
			<xsl:text>Dependency </xsl:text><xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']">
		<fo:block id="{@id}" xsl:use-attribute-sets="recommendation-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:block xsl:use-attribute-sets="recommendation-name-style">
				<xsl:apply-templates/>
				
			</fo:block>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'recommendation']/*[local-name() = 'label']">
		<fo:block xsl:use-attribute-sets="recommendation-label-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
		<fo:block-container margin-left="0mm" margin-right="0mm" margin-bottom="12pt">
			<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			</xsl:if>
			<fo:block-container margin-left="0mm" margin-right="0mm">
				<fo:table id="{@id}" table-layout="fixed" width="100%"> <!-- border="1pt solid black" -->
					<xsl:if test="ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
						<!-- <xsl:attribute name="border">0.5pt solid black</xsl:attribute> -->
					</xsl:if>
					<xsl:variable name="simple-table">	
						<xsl:call-template name="getSimpleTable"/>			
					</xsl:variable>					
					<xsl:variable name="cols-count" select="count(xalan:nodeset($simple-table)//tr[1]/td)"/>
					<xsl:if test="$cols-count = 2 and not(ancestor::*[local-name()='table'])">
						<!-- <fo:table-column column-width="35mm"/>
						<fo:table-column column-width="115mm"/> -->
						<fo:table-column column-width="30%"/>
						<fo:table-column column-width="70%"/>
					</xsl:if>
					<xsl:apply-templates mode="requirement"/>
				</fo:table>
				<!-- fn processing -->
				<xsl:if test=".//*[local-name() = 'fn']">
					<xsl:for-each select="*[local-name() = 'tbody']">
						<fo:block font-size="90%" border-bottom="1pt solid black">
							<xsl:call-template name="fn_display"/>
						</fo:block>
					</xsl:for-each>
				</xsl:if>
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name()='thead']" mode="requirement">		
		<fo:table-header>			
			<xsl:apply-templates mode="requirement"/>
		</fo:table-header>
	</xsl:template><xsl:template match="*[local-name()='tbody']" mode="requirement">		
		<fo:table-body>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-body>
	</xsl:template><xsl:template match="*[local-name()='tr']" mode="requirement">
		<fo:table-row height="7mm" border-bottom="0.5pt solid grey">			
			<xsl:if test="parent::*[local-name()='thead']"> <!-- and not(ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']) -->
				<!-- <xsl:attribute name="border">1pt solid black</xsl:attribute> -->
				<xsl:attribute name="background-color">rgb(33, 55, 92)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Requirement ')">
				<xsl:attribute name="background-color">rgb(252, 246, 222)</xsl:attribute>
			</xsl:if>
			<xsl:if test="starts-with(*[local-name()='td'][1], 'Recommendation ')">
				<xsl:attribute name="background-color">rgb(233, 235, 239)</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="requirement"/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name()='th']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(165, 165, 165)</xsl:attribute>				
			</xsl:if>
			<xsl:if test="ancestor::*[local-name()='table']/@type = 'recommendtest'">
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>
				<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>				
			</xsl:if> -->
			
			<fo:block>
				<xsl:apply-templates/>
			</fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name()='td']" mode="requirement">
		<fo:table-cell text-align="{@align}" display-align="center" padding="1mm" padding-left="2mm"> <!-- border="0.5pt solid black" -->
			<xsl:if test="*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']">
				<xsl:attribute name="padding">0mm</xsl:attribute>
				<xsl:attribute name="padding-left">0mm</xsl:attribute>
			</xsl:if>
			<xsl:attribute name="text-align">
				<xsl:choose>
					<xsl:when test="@align">
						<xsl:value-of select="@align"/>
					</xsl:when>
					<xsl:otherwise>left</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="following-sibling::*[local-name()='td'] and not(preceding-sibling::*[local-name()='td'])">
				<xsl:attribute name="font-weight">bold</xsl:attribute>
			</xsl:if>
			<xsl:if test="@colspan">
				<xsl:attribute name="number-columns-spanned">
					<xsl:value-of select="@colspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="@rowspan">
				<xsl:attribute name="number-rows-spanned">
					<xsl:value-of select="@rowspan"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="display-align"/>
			
			<!-- <xsl:if test="ancestor::*[local-name()='table']/@type = 'recommend'">
				<xsl:attribute name="padding-left">0.5mm</xsl:attribute>
				<xsl:attribute name="padding-top">0.5mm</xsl:attribute>				 
				<xsl:if test="parent::*[local-name()='tr']/preceding-sibling::*[local-name()='tr'] and not(*[local-name()='table'])">
					<xsl:attribute name="background-color">rgb(201, 201, 201)</xsl:attribute>					
				</xsl:if>
			</xsl:if> -->
			<!-- 2nd line and below -->
			
			<fo:block>			
				<xsl:apply-templates/>
			</fo:block>			
		</fo:table-cell>
	</xsl:template><xsl:template match="*[local-name() = 'p'][@class='RecommendationTitle' or @class = 'RecommendationTestTitle']" priority="2">
		<fo:block font-size="11pt" color="rgb(237, 193, 35)"> <!-- font-weight="bold" margin-bottom="4pt" text-align="center"  -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'p2'][ancestor::*[local-name() = 'table'][@class = 'recommendation' or @class='requirement' or @class='permission']]">
		<fo:block> <!-- margin-bottom="10pt" -->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']">
		<fo:block id="{@id}" xsl:use-attribute-sets="termexample-style">			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'name']" mode="presentation">
		<xsl:if test="normalize-space() != ''">
			<fo:inline xsl:use-attribute-sets="termexample-name-style">
				<xsl:apply-templates/>
			</fo:inline>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'termexample']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'example']">
		<fo:block id="{@id}" xsl:use-attribute-sets="example-style">
			
			
			<xsl:apply-templates select="*[local-name()='name']" mode="presentation"/>
			
			<xsl:variable name="element">
				block				
				
				<xsl:if test=".//*[local-name() = 'table']">block</xsl:if> 
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="contains(normalize-space($element), 'block')">
					<fo:block xsl:use-attribute-sets="example-body-style">
						<xsl:apply-templates/>
					</fo:block>
				</xsl:when>
				<xsl:otherwise>
					<fo:inline>
						<xsl:apply-templates/>
					</fo:inline>
				</xsl:otherwise>
			</xsl:choose>
			
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']"/><xsl:template match="*[local-name() = 'example']/*[local-name() = 'name']" mode="presentation">

		<xsl:variable name="element">
			block
			
			<xsl:if test="following-sibling::*[1][local-name() = 'table']">block</xsl:if> 
		</xsl:variable>		
		<xsl:choose>
			<xsl:when test="ancestor::*[local-name() = 'appendix']">
				<fo:inline>
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:when>
			<xsl:when test="contains(normalize-space($element), 'block')">
				<fo:block xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-name-style">
					<xsl:apply-templates/>
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template><xsl:template match="*[local-name() = 'example']/*[local-name() = 'p']">
		<xsl:variable name="num"><xsl:number/></xsl:variable>
		<xsl:variable name="element">
			block
			
			
		</xsl:variable>		
		<xsl:choose>			
			<xsl:when test="normalize-space($element) = 'block'">
				<fo:block xsl:use-attribute-sets="example-p-style">
					
					<xsl:apply-templates/>
				</fo:block>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline xsl:use-attribute-sets="example-p-style">
					<xsl:apply-templates/>					
				</fo:inline>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template><xsl:template match="*[local-name() = 'termsource']" name="termsource">
		<fo:block xsl:use-attribute-sets="termsource-style">
			<!-- Example: [SOURCE: ISO 5127:2017, 3.1.6.02] -->			
			<xsl:variable name="termsource_text">
				<xsl:apply-templates/>
			</xsl:variable>
			
			<xsl:choose>
				<xsl:when test="starts-with(normalize-space($termsource_text), '[')">
					<!-- <xsl:apply-templates /> -->
					<xsl:copy-of select="$termsource_text"/>
				</xsl:when>
				<xsl:otherwise>					
					
						<xsl:text>[</xsl:text>
					
					<!-- <xsl:apply-templates />					 -->
					<xsl:copy-of select="$termsource_text"/>
					
						<xsl:text>]</xsl:text>
					
				</xsl:otherwise>
			</xsl:choose>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'termsource']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:variable name="localized.source">
		<xsl:call-template name="getLocalizedString">
				<xsl:with-param name="key">source</xsl:with-param>
			</xsl:call-template>
	</xsl:variable><xsl:template match="*[local-name() = 'origin']">
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:if test="normalize-space(@citeas) = ''">
				<xsl:attribute name="fox:alt-text"><xsl:value-of select="@bibitemid"/></xsl:attribute>
			</xsl:if>
			
				<fo:inline>
					
					
					
					
					
					
						<xsl:call-template name="getTitle">
							<xsl:with-param name="name" select="'title-source'"/>
						</xsl:call-template>
						<xsl:text>: </xsl:text>
					
					
				</fo:inline>
			
			<fo:inline xsl:use-attribute-sets="origin-style">
				<xsl:apply-templates/>
			</fo:inline>
			</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/*[local-name() = 'p']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'modification']/text()">
		<xsl:if test="normalize-space() != ''">
			<xsl:value-of select="."/>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'quote']">		
		<fo:block-container margin-left="0mm">
			<xsl:if test="parent::*[local-name() = 'note']">
				<xsl:if test="not(ancestor::*[local-name() = 'table'])">
					<xsl:attribute name="margin-left">5mm</xsl:attribute>
				</xsl:if>
			</xsl:if>
			
			
			<fo:block-container margin-left="0mm">
		
				<fo:block xsl:use-attribute-sets="quote-style">
					<!-- <xsl:apply-templates select=".//*[local-name() = 'p']"/> -->
					
					<xsl:apply-templates select="./node()[not(local-name() = 'author') and not(local-name() = 'source')]"/> <!-- process all nested nodes, except author and source -->
				</fo:block>
				<xsl:if test="*[local-name() = 'author'] or *[local-name() = 'source']">
					<fo:block xsl:use-attribute-sets="quote-source-style">
						<!-- — ISO, ISO 7301:2011, Clause 1 -->
						<xsl:apply-templates select="*[local-name() = 'author']"/>
						<xsl:apply-templates select="*[local-name() = 'source']"/>				
					</fo:block>
				</xsl:if>
				
			</fo:block-container>
		</fo:block-container>
	</xsl:template><xsl:template match="*[local-name() = 'source']">
		<xsl:if test="../*[local-name() = 'author']">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
			<xsl:apply-templates/>
		</fo:basic-link>
	</xsl:template><xsl:template match="*[local-name() = 'author']">
		<xsl:text>— </xsl:text>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'eref']">
	
		<xsl:variable name="bibitemid">
			<xsl:choose>
				<xsl:when test="//*[local-name() = 'bibitem'][@hidden='true' and @id = current()/@bibitemid]"/>
				<xsl:when test="//*[local-name() = 'references'][@hidden='true']/*[local-name() = 'bibitem'][@id = current()/@bibitemid]"/>
				<xsl:otherwise><xsl:value-of select="@bibitemid"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
	
		<xsl:choose>
			<xsl:when test="normalize-space($bibitemid) != ''">
				<fo:inline xsl:use-attribute-sets="eref-style">
					<xsl:if test="@type = 'footnote'">
						
							<xsl:attribute name="keep-together.within-line">always</xsl:attribute>
							<xsl:attribute name="font-size">80%</xsl:attribute>
							<xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
							<xsl:attribute name="vertical-align">super</xsl:attribute>
											
						
					</xsl:if>	
					
					
            
					<fo:basic-link internal-destination="{@bibitemid}" fox:alt-text="{@citeas}">
						<xsl:if test="normalize-space(@citeas) = ''">
							<xsl:attribute name="fox:alt-text"><xsl:value-of select="."/></xsl:attribute>
						</xsl:if>
						<xsl:if test="@type = 'inline'">
							
							
							
							
						</xsl:if>

						<xsl:apply-templates/>
					</fo:basic-link>
							
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<fo:inline><xsl:apply-templates/></fo:inline>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="*[local-name() = 'tab']">
		<!-- zero-space char -->
		<xsl:variable name="depth">
			<xsl:call-template name="getLevel">
				<xsl:with-param name="depth" select="../@depth"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:variable name="padding">
			2
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		</xsl:variable>
		
		<xsl:variable name="padding-right">
			<xsl:choose>
				<xsl:when test="normalize-space($padding) = ''">0</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space($padding)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="language" select="//*[local-name()='bibdata']//*[local-name()='language']"/>
		
		<xsl:choose>
			<xsl:when test="$language = 'zh'">
				<fo:inline><xsl:value-of select="$tab_zh"/></fo:inline>
			</xsl:when>
			<xsl:when test="../../@inline-header = 'true'">
				<fo:inline font-size="90%">
					<xsl:call-template name="insertNonBreakSpaces">
						<xsl:with-param name="count" select="$padding-right"/>
					</xsl:call-template>
				</fo:inline>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="direction"><xsl:if test="$lang = 'ar'"><xsl:value-of select="$RLM"/></xsl:if></xsl:variable>
				<fo:inline padding-right="{$padding-right}mm"><xsl:value-of select="$direction"/>​</fo:inline>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="insertNonBreakSpaces">
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:text> </xsl:text>
			<xsl:call-template name="insertNonBreakSpaces">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'domain']">
		<fo:inline xsl:use-attribute-sets="domain-style">&lt;<xsl:apply-templates/>&gt;</fo:inline>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'admitted']">
		<fo:block xsl:use-attribute-sets="admitted-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'deprecates']">
		<xsl:variable name="title-deprecated">
			
			
				<xsl:call-template name="getTitle">
					<xsl:with-param name="name" select="'title-deprecated'"/>
				</xsl:call-template>
			
		</xsl:variable>
		<fo:block xsl:use-attribute-sets="deprecates-style">
			<xsl:value-of select="$title-deprecated"/>: <xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition']">
		<fo:block xsl:use-attribute-sets="definition-style">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'definition'][preceding-sibling::*[local-name() = 'domain']]/*[local-name() = 'p']">
		<fo:inline> <xsl:apply-templates/></fo:inline>
		<fo:block> </fo:block>
	</xsl:template><xsl:template match="/*/*[local-name() = 'sections']/*" priority="2">
		
		<fo:block>
			<xsl:call-template name="setId"/>
			
				<xsl:variable name="pos"><xsl:number count="csa:sections/csa:clause[not(@type='scope') and not(@type='conformance')]"/></xsl:variable>
				<xsl:if test="$pos &gt;= 2">
					<xsl:attribute name="space-before">18pt</xsl:attribute>
				</xsl:if>
			
			
			
			
			
						
			
						
			
			
			<xsl:apply-templates/>
		</fo:block>
		
		
		
	</xsl:template><xsl:template match="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*" priority="2"> <!-- /*/*[local-name() = 'preface']/* -->
		<fo:block break-after="page"/>
		<fo:block>
			<xsl:call-template name="setId"/>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'clause']">
		<fo:block>
			<xsl:call-template name="setId"/>
			
			
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'definitions']">
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'references'][@hidden='true']" priority="3"/><xsl:template match="*[local-name() = 'bibitem'][@hidden='true']" priority="3"/><xsl:template match="/*/*[local-name() = 'bibliography']/*[local-name() = 'references'][@normative='true']">
		
		<fo:block id="{@id}">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'annex']">
		<fo:block break-after="page"/>
		<fo:block id="{@id}">
			
		</fo:block>
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'review']">
		<!-- comment 2019-11-29 -->
		<!-- <fo:block font-weight="bold">Review:</fo:block>
		<xsl:apply-templates /> -->
	</xsl:template><xsl:template match="*[local-name() = 'name']/text()">
		<!-- 0xA0 to space replacement -->
		<xsl:value-of select="java:replaceAll(java:java.lang.String.new(.),' ',' ')"/>
	</xsl:template><xsl:template match="*[local-name() = 'ul'] | *[local-name() = 'ol']">
		<xsl:choose>
			<xsl:when test="parent::*[local-name() = 'note'] or parent::*[local-name() = 'termnote']">
				<fo:block-container>
					<xsl:attribute name="margin-left">
						<xsl:choose>
							<xsl:when test="not(ancestor::*[local-name() = 'table'])"><xsl:value-of select="$note-body-indent"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$note-body-indent-table"/></xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					
					
					
					<fo:block-container margin-left="0mm">
						<fo:block>
							<xsl:apply-templates select="." mode="ul_ol"/>
						</fo:block>
					</fo:block-container>
				</fo:block-container>
			</xsl:when>
			<xsl:otherwise>
				<fo:block>
					<xsl:apply-templates select="." mode="ul_ol"/>
				</fo:block>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="index" select="document($external_index)"/><xsl:variable name="dash" select="'–'"/><xsl:variable name="bookmark_in_fn">
		<xsl:for-each select="//*[local-name() = 'bookmark'][ancestor::*[local-name() = 'fn']]">
			<bookmark><xsl:value-of select="@id"/></bookmark>
		</xsl:for-each>
	</xsl:variable><xsl:template match="@*|node()" mode="index_add_id">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_add_id"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'xref']" mode="index_add_id">
		<xsl:variable name="id">
			<xsl:call-template name="generateIndexXrefId"/>
		</xsl:variable>
		<xsl:copy> <!-- add id to xref -->
			<xsl:apply-templates select="@*" mode="index_add_id"/>
			<xsl:attribute name="id">
				<xsl:value-of select="$id"/>
			</xsl:attribute>
			<xsl:apply-templates mode="index_add_id"/>
		</xsl:copy>
		<!-- split <xref target="bm1" to="End" pagenumber="true"> to two xref:
		<xref target="bm1" pagenumber="true"> and <xref target="End" pagenumber="true"> -->
		<xsl:if test="@to">
			<xsl:value-of select="$dash"/>
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="target"><xsl:value-of select="@to"/></xsl:attribute>
				<xsl:attribute name="id">
					<xsl:value-of select="$id"/><xsl:text>_to</xsl:text>
				</xsl:attribute>
				<xsl:apply-templates mode="index_add_id"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template><xsl:template match="@*|node()" mode="index_update">
		<xsl:copy>
				<xsl:apply-templates select="@*|node()" mode="index_update"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" mode="index_update">
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="index_update"/>
		<xsl:apply-templates select="node()[1]" mode="process_li_element"/>
		</xsl:copy>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']/node()" mode="process_li_element" priority="2">
		<xsl:param name="element"/>
		<xsl:param name="remove" select="'false'"/>
		<xsl:param name="target"/>
		<!-- <node></node> -->
		<xsl:choose>
			<xsl:when test="self::text()  and (normalize-space(.) = ',' or normalize-space(.) = $dash) and $remove = 'true'">
				<!-- skip text (i.e. remove it) and process next element -->
				<!-- [removed_<xsl:value-of select="."/>] -->
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
					<xsl:with-param name="target"><xsl:value-of select="$target"/></xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="self::text()">
				<xsl:value-of select="."/>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'xref'">
				<xsl:variable name="id" select="@id"/>
				<xsl:variable name="page" select="$index//item[@id = $id]"/>
				<xsl:variable name="id_next" select="following-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_next" select="$index//item[@id = $id_next]"/>
				
				<xsl:variable name="id_prev" select="preceding-sibling::*[local-name() = 'xref'][1]/@id"/>
				<xsl:variable name="page_prev" select="$index//item[@id = $id_prev]"/>
				
				<xsl:choose>
					<!-- 2nd pass -->
					<!-- if page is equal to page for next and page is not the end of range -->
					<xsl:when test="$page != '' and $page_next != '' and $page = $page_next and not(contains($page, '_to'))">  <!-- case: 12, 12-14 -->
						<!-- skip element (i.e. remove it) and remove next text ',' -->
						<!-- [removed_xref] -->
						
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
							<xsl:with-param name="target">
								<xsl:choose>
									<xsl:when test="$target != ''"><xsl:value-of select="$target"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="@target"/></xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>
					
					<xsl:when test="$page != '' and $page_prev != '' and $page = $page_prev and contains($page_prev, '_to')"> <!-- case: 12-14, 14, ... -->
						<!-- remove xref -->
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element">
							<xsl:with-param name="remove">true</xsl:with-param>
						</xsl:apply-templates>
					</xsl:when>

					<xsl:otherwise>
						<xsl:apply-templates select="." mode="xref_copy">
							<xsl:with-param name="target" select="$target"/>
						</xsl:apply-templates>
						<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="self::* and local-name(.) = 'ul'">
				<!-- ul -->
				<xsl:apply-templates select="." mode="index_update"/>
			</xsl:when>
			<xsl:otherwise>
			 <xsl:apply-templates select="." mode="xref_copy">
					<xsl:with-param name="target" select="$target"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="following-sibling::node()[1]" mode="process_li_element"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template match="@*|node()" mode="xref_copy">
		<xsl:param name="target"/>
		<xsl:copy>
			<xsl:apply-templates select="@*" mode="xref_copy"/>
			<xsl:if test="$target != '' and not(xalan:nodeset($bookmark_in_fn)//bookmark[. = $target])">
				<xsl:attribute name="target"><xsl:value-of select="$target"/></xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="node()" mode="xref_copy"/>
		</xsl:copy>
	</xsl:template><xsl:template name="generateIndexXrefId">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		
		<xsl:variable name="docid">
			<xsl:call-template name="getDocumentId"/>
		</xsl:variable>
		<xsl:variable name="item_number">
			<xsl:number count="*[local-name() = 'li'][ancestor::*[local-name() = 'indexsect']]" level="any"/>
		</xsl:variable>
		<xsl:variable name="xref_number"><xsl:number count="*[local-name() = 'xref']"/></xsl:variable>
		<xsl:value-of select="concat($docid, '_', $item_number, '_', $xref_number)"/> <!-- $level, '_',  -->
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']/*[local-name() = 'clause']" priority="4">
		<xsl:apply-templates/>
		<fo:block>
		<xsl:if test="following-sibling::*[local-name() = 'clause']">
			<fo:block> </fo:block>
		</xsl:if>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'ul']" priority="4">
		<xsl:apply-templates/>
	</xsl:template><xsl:template match="*[local-name() = 'indexsect']//*[local-name() = 'li']" priority="4">
		<xsl:variable name="level" select="count(ancestor::*[local-name() = 'ul'])"/>
		<fo:block start-indent="{5 * $level}mm" text-indent="-5mm">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'bookmark']" name="bookmark">
		<fo:inline id="{@id}" font-size="1pt"/>
	</xsl:template><xsl:template match="*[local-name() = 'errata']">
		<!-- <row>
					<date>05-07-2013</date>
					<type>Editorial</type>
					<change>Changed CA-9 Priority Code from P1 to P2 in <xref target="tabled2"/>.</change>
					<pages>D-3</pages>
				</row>
		-->
		<fo:table table-layout="fixed" width="100%" font-size="10pt" border="1pt solid black">
			<fo:table-column column-width="20mm"/>
			<fo:table-column column-width="23mm"/>
			<fo:table-column column-width="107mm"/>
			<fo:table-column column-width="15mm"/>
			<fo:table-body>
				<fo:table-row text-align="center" font-weight="bold" background-color="black" color="white">
					
					<fo:table-cell border="1pt solid black"><fo:block>Date</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Type</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Change</fo:block></fo:table-cell>
					<fo:table-cell border="1pt solid black"><fo:block>Pages</fo:block></fo:table-cell>
				</fo:table-row>
				<xsl:apply-templates/>
			</fo:table-body>
		</fo:table>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template><xsl:template match="*[local-name() = 'errata']/*[local-name() = 'row']/*">
		<fo:table-cell border="1pt solid black" padding-left="1mm" padding-top="0.5mm">
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template><xsl:template name="processBibitem">
		
		
		<!-- end BIPM bibitem processing-->
		
		 
		
		
		 
		
		
		
		
	</xsl:template><xsl:template name="processBibitemDocId">
		<xsl:variable name="_doc_ident" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]"/>
		<xsl:choose>
			<xsl:when test="normalize-space($_doc_ident) != ''">
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'DOI' or @type = 'metanorma' or @type = 'ISSN' or @type = 'ISBN' or @type = 'rfc-anchor')]/@type"/>
				<xsl:if test="$type != '' and not(contains($_doc_ident, $type))">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="$_doc_ident"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:variable name="type" select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]/@type"/>
				<xsl:if test="$type != ''">
					<xsl:value-of select="$type"/><xsl:text> </xsl:text>
				</xsl:if> -->
				<xsl:value-of select="*[local-name() = 'docidentifier'][not(@type = 'metanorma')]"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="processPersonalAuthor">
		<xsl:choose>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'completename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'completename']"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'initial']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'initial']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:when test="*[local-name() = 'name']/*[local-name() = 'surname'] and *[local-name() = 'name']/*[local-name() = 'forename']">
				<author>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'surname']"/>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="*[local-name() = 'name']/*[local-name() = 'forename']" mode="strip"/>
				</author>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="renderDate">		
			<xsl:if test="normalize-space(*[local-name() = 'on']) != ''">
				<xsl:value-of select="*[local-name() = 'on']"/>
			</xsl:if>
			<xsl:if test="normalize-space(*[local-name() = 'from']) != ''">
				<xsl:value-of select="concat(*[local-name() = 'from'], '–', *[local-name() = 'to'])"/>
			</xsl:if>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'initial']/text()" mode="strip">
		<xsl:value-of select="translate(.,'. ','')"/>
	</xsl:template><xsl:template match="*[local-name() = 'name']/*[local-name() = 'forename']/text()" mode="strip">
		<xsl:value-of select="substring(.,1,1)"/>
	</xsl:template><xsl:template match="*[local-name() = 'title']" mode="title">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'label']">
		<fo:inline><xsl:apply-templates/></fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'text' or @type = 'date' or @type = 'file' or @type = 'password']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template><xsl:template name="text_input">
		<xsl:variable name="count">
			<xsl:choose>
				<xsl:when test="normalize-space(@maxlength) != ''"><xsl:value-of select="@maxlength"/></xsl:when>
				<xsl:when test="normalize-space(@size) != ''"><xsl:value-of select="@size"/></xsl:when>
				<xsl:otherwise>10</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="repeat">
			<xsl:with-param name="char" select="'_'"/>
			<xsl:with-param name="count" select="$count"/>
		</xsl:call-template>
		<xsl:text> </xsl:text>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'button']">
		<xsl:variable name="caption">
			<xsl:choose>
				<xsl:when test="normalize-space(@value) != ''"><xsl:value-of select="@value"/></xsl:when>
				<xsl:otherwise>BUTTON</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<fo:inline>[<xsl:value-of select="$caption"/>]</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'checkbox']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<polyline points="0,0 80,0 80,80 0,80 0,0" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'input'][@type = 'radio']">
		<fo:inline padding-right="1mm">
			<fo:instream-foreign-object fox:alt-text="Box" baseline-shift="-10%">
				<xsl:attribute name="height">3.5mm</xsl:attribute>
				<xsl:attribute name="content-width">100%</xsl:attribute>
				<xsl:attribute name="content-width">scale-down-to-fit</xsl:attribute>
				<xsl:attribute name="scaling">uniform</xsl:attribute>
				<svg xmlns="http://www.w3.org/2000/svg" width="80" height="80">
					<circle cx="40" cy="40" r="30" stroke="black" stroke-width="5" fill="white"/>
					<circle cx="40" cy="40" r="15" stroke="black" stroke-width="5" fill="white"/>
				</svg>
			</fo:instream-foreign-object>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'select']">
		<fo:inline>
			<xsl:call-template name="text_input"/>
		</fo:inline>
	</xsl:template><xsl:template match="*[local-name() = 'form']//*[local-name() = 'textarea']">
		<fo:block-container border="1pt solid black" width="50%">
			<fo:block> </fo:block>
		</fo:block-container>
	</xsl:template><xsl:template name="convertDate">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'">January</xsl:when>
				<xsl:when test="$month = '02'">February</xsl:when>
				<xsl:when test="$month = '03'">March</xsl:when>
				<xsl:when test="$month = '04'">April</xsl:when>
				<xsl:when test="$month = '05'">May</xsl:when>
				<xsl:when test="$month = '06'">June</xsl:when>
				<xsl:when test="$month = '07'">July</xsl:when>
				<xsl:when test="$month = '08'">August</xsl:when>
				<xsl:when test="$month = '09'">September</xsl:when>
				<xsl:when test="$month = '10'">October</xsl:when>
				<xsl:when test="$month = '11'">November</xsl:when>
				<xsl:when test="$month = '12'">December</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="convertDateLocalized">
		<xsl:param name="date"/>
		<xsl:param name="format" select="'short'"/>
		<xsl:variable name="year" select="substring($date, 1, 4)"/>
		<xsl:variable name="month" select="substring($date, 6, 2)"/>
		<xsl:variable name="day" select="substring($date, 9, 2)"/>
		<xsl:variable name="monthStr">
			<xsl:choose>
				<xsl:when test="$month = '01'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_january</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '02'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_february</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '03'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_march</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '04'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_april</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '05'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_may</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '06'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_june</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '07'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_july</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '08'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_august</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '09'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_september</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '10'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_october</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '11'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_november</xsl:with-param></xsl:call-template></xsl:when>
				<xsl:when test="$month = '12'"><xsl:call-template name="getLocalizedString"><xsl:with-param name="key">month_december</xsl:with-param></xsl:call-template></xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="result">
			<xsl:choose>
				<xsl:when test="$format = 'ddMMyyyy'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ' , $year))"/>
				</xsl:when>
				<xsl:when test="$format = 'ddMM'">
					<xsl:if test="$day != ''"><xsl:value-of select="number($day)"/></xsl:if>
					<xsl:text> </xsl:text><xsl:value-of select="$monthStr"/>
				</xsl:when>
				<xsl:when test="$format = 'short' or $day = ''">
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $year))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(concat($monthStr, ' ', $day, ', ' , $year))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$result"/>
	</xsl:template><xsl:template name="insertKeywords">
		<xsl:param name="sorting" select="'true'"/>
		<xsl:param name="charAtEnd" select="'.'"/>
		<xsl:param name="charDelim" select="', '"/>
		<xsl:choose>
			<xsl:when test="$sorting = 'true' or $sorting = 'yes'">
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:sort data-type="text" order="ascending"/>
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="//*[contains(local-name(), '-standard')]/*[local-name() = 'bibdata']//*[local-name() = 'keyword']">
					<xsl:call-template name="insertKeyword">
						<xsl:with-param name="charAtEnd" select="$charAtEnd"/>
						<xsl:with-param name="charDelim" select="$charDelim"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="insertKeyword">
		<xsl:param name="charAtEnd"/>
		<xsl:param name="charDelim"/>
		<xsl:apply-templates/>
		<xsl:choose>
			<xsl:when test="position() != last()"><xsl:value-of select="$charDelim"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="$charAtEnd"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="addPDFUAmeta">
		<xsl:variable name="lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		<pdf:catalog xmlns:pdf="http://xmlgraphics.apache.org/fop/extensions/pdf">
				<pdf:dictionary type="normal" key="ViewerPreferences">
					<pdf:boolean key="DisplayDocTitle">true</pdf:boolean>
				</pdf:dictionary>
			</pdf:catalog>
		<x:xmpmeta xmlns:x="adobe:ns:meta/">
			<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<rdf:Description xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/" rdf:about="">
				<!-- Dublin Core properties go here -->
					<dc:title>
						<xsl:variable name="title">
							<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
								
								
								
																
									<xsl:value-of select="*[local-name() = 'title'][@language = $lang]"/>
								
								
																
							</xsl:for-each>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="normalize-space($title) != ''">
								<xsl:value-of select="$title"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>							
					</dc:title>
					<dc:creator>
						<xsl:for-each select="(//*[contains(local-name(), '-standard')])[1]/*[local-name() = 'bibdata']">
							
								<xsl:for-each select="*[local-name() = 'contributor'][*[local-name() = 'role']/@type='author']">
									<xsl:value-of select="*[local-name() = 'organization']/*[local-name() = 'name']"/>
									<xsl:if test="position() != last()">; </xsl:if>
								</xsl:for-each>
							
							
							
						</xsl:for-each>
					</dc:creator>
					<dc:description>
						<xsl:variable name="abstract">
							
								<xsl:copy-of select="//*[contains(local-name(), '-standard')]/*[local-name() = 'preface']/*[local-name() = 'abstract']//text()"/>									
							
							
						</xsl:variable>
						<xsl:value-of select="normalize-space($abstract)"/>
					</dc:description>
					<pdf:Keywords>
						<xsl:call-template name="insertKeywords"/>
					</pdf:Keywords>
				</rdf:Description>
				<rdf:Description xmlns:xmp="http://ns.adobe.com/xap/1.0/" rdf:about="">
					<!-- XMP properties go here -->
					<xmp:CreatorTool/>
				</rdf:Description>
			</rdf:RDF>
		</x:xmpmeta>
	</xsl:template><xsl:template name="getId">
		<xsl:choose>
			<xsl:when test="../@id">
				<xsl:value-of select="../@id"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- <xsl:value-of select="concat(local-name(..), '_', text())"/> -->
				<xsl:value-of select="concat(generate-id(..), '_', text())"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="getLevel">
		<xsl:param name="depth"/>
		<xsl:choose>
			<xsl:when test="normalize-space(@depth) != ''">
				<xsl:value-of select="@depth"/>
			</xsl:when>
			<xsl:when test="normalize-space($depth) != ''">
				<xsl:value-of select="$depth"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="level_total" select="count(ancestor::*)"/>
				<xsl:variable name="level">
					<xsl:choose>
						<xsl:when test="parent::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface'] and not(ancestor::*[local-name() = 'foreword']) and not(ancestor::*[local-name() = 'introduction'])"> <!-- for preface/clause -->
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'preface']">
							<xsl:value-of select="$level_total - 2"/>
						</xsl:when>
						<!-- <xsl:when test="parent::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when> -->
						<xsl:when test="ancestor::*[local-name() = 'sections']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'bibliography']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="parent::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total - 1"/>
						</xsl:when>
						<xsl:when test="ancestor::*[local-name() = 'annex']">
							<xsl:value-of select="$level_total"/>
						</xsl:when>
						<xsl:when test="local-name() = 'annex'">1</xsl:when>
						<xsl:when test="local-name(ancestor::*[1]) = 'annex'">1</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$level_total - 1"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:value-of select="$level"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="split">
		<xsl:param name="pText" select="."/>
		<xsl:param name="sep" select="','"/>
		<xsl:param name="normalize-space" select="'true'"/>
		<xsl:if test="string-length($pText) &gt;0">
		<item>
			<xsl:choose>
				<xsl:when test="$normalize-space = 'true'">
					<xsl:value-of select="normalize-space(substring-before(concat($pText, $sep), $sep))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="substring-before(concat($pText, $sep), $sep)"/>
				</xsl:otherwise>
			</xsl:choose>
		</item>
		<xsl:call-template name="split">
			<xsl:with-param name="pText" select="substring-after($pText, $sep)"/>
			<xsl:with-param name="sep" select="$sep"/>
			<xsl:with-param name="normalize-space" select="$normalize-space"/>
		</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getDocumentId">		
		<xsl:call-template name="getLang"/><xsl:value-of select="//*[local-name() = 'p'][1]/@id"/>
	</xsl:template><xsl:template name="namespaceCheck">
		<xsl:variable name="documentNS" select="namespace-uri(/*)"/>
		<xsl:variable name="XSLNS">			
			
			
			
			
			
			
			
			
			
				<xsl:value-of select="document('')//*/namespace::csa"/>
			
			
			
						
			
			
			
			
		</xsl:variable>
		<xsl:if test="$documentNS != $XSLNS">
			<xsl:message>[WARNING]: Document namespace: '<xsl:value-of select="$documentNS"/>' doesn't equal to xslt namespace '<xsl:value-of select="$XSLNS"/>'</xsl:message>
		</xsl:if>
	</xsl:template><xsl:template name="getLanguage">
		<xsl:param name="lang"/>		
		<xsl:variable name="language" select="java:toLowerCase(java:java.lang.String.new($lang))"/>
		<xsl:choose>
			<xsl:when test="$language = 'en'">English</xsl:when>
			<xsl:when test="$language = 'fr'">French</xsl:when>
			<xsl:when test="$language = 'de'">Deutsch</xsl:when>
			<xsl:when test="$language = 'cn'">Chinese</xsl:when>
			<xsl:otherwise><xsl:value-of select="$language"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:template name="setId">
		<xsl:attribute name="id">
			<xsl:choose>
				<xsl:when test="@id">
					<xsl:value-of select="@id"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="generate-id()"/>
				</xsl:otherwise>
			</xsl:choose>					
		</xsl:attribute>
	</xsl:template><xsl:template name="add-letter-spacing">
		<xsl:param name="text"/>
		<xsl:param name="letter-spacing" select="'0.15'"/>
		<xsl:if test="string-length($text) &gt; 0">
			<xsl:variable name="char" select="substring($text, 1, 1)"/>
			<fo:inline padding-right="{$letter-spacing}mm">
				<xsl:if test="$char = '®'">
					<xsl:attribute name="font-size">58%</xsl:attribute>
					<xsl:attribute name="baseline-shift">30%</xsl:attribute>
				</xsl:if>				
				<xsl:value-of select="$char"/>
			</fo:inline>
			<xsl:call-template name="add-letter-spacing">
				<xsl:with-param name="text" select="substring($text, 2)"/>
				<xsl:with-param name="letter-spacing" select="$letter-spacing"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="repeat">
		<xsl:param name="char" select="'*'"/>
		<xsl:param name="count"/>
		<xsl:if test="$count &gt; 0">
			<xsl:value-of select="$char"/>
			<xsl:call-template name="repeat">
				<xsl:with-param name="char" select="$char"/>
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template><xsl:template name="getLocalizedString">
		<xsl:param name="key"/>	
		
		<xsl:variable name="curr_lang">
			<xsl:call-template name="getLang"/>
		</xsl:variable>
		
		<xsl:variable name="data_value" select="normalize-space(xalan:nodeset($bibdata)//*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang])"/>
		
		<xsl:choose>
			<xsl:when test="$data_value != ''">
				<xsl:value-of select="$data_value"/>
			</xsl:when>
			<xsl:when test="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]">
				<xsl:value-of select="/*/*[local-name() = 'localized-strings']/*[local-name() = 'localized-string'][@key = $key and @language = $curr_lang]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="key_">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="translate($key, '_', ' ')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:value-of select="$key_"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template><xsl:template name="setTrackChangesStyles">
		<xsl:param name="isAdded"/>
		<xsl:param name="isDeleted"/>
		<xsl:choose>
			<xsl:when test="local-name() = 'math'">
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-added-text"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="background-color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="$isAdded = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-added"/></xsl:attribute>
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
				<xsl:if test="$isDeleted = 'true'">
					<xsl:attribute name="border"><xsl:value-of select="$border-block-deleted"/></xsl:attribute>
					<xsl:if test="local-name() = 'table'">
						<xsl:attribute name="background-color">rgb(255, 185, 185)</xsl:attribute>
					</xsl:if>
					<!-- <xsl:attribute name="color"><xsl:value-of select="$color-deleted-text"/></xsl:attribute> -->
					<xsl:attribute name="padding">2mm</xsl:attribute>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template><xsl:variable name="LRM" select="'‎'"/><xsl:variable name="RLM" select="'‏'"/><xsl:template name="setWritingMode">
		<xsl:if test="$lang = 'ar'">
			<xsl:attribute name="writing-mode">rl-tb</xsl:attribute>
		</xsl:if>
	</xsl:template><xsl:template name="setAlignment">
		<xsl:param name="align" select="normalize-space(@align)"/>
		<xsl:choose>
			<xsl:when test="$lang = 'ar' and $align = 'left'">start</xsl:when>
			<xsl:when test="$lang = 'ar' and $align = 'right'">end</xsl:when>
			<xsl:when test="$align != ''">
				<xsl:value-of select="$align"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template><xsl:template name="setTextAlignment">
		<xsl:param name="default">left</xsl:param>
		<xsl:attribute name="text-align">
			<xsl:choose>
				<xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'td']/@align"><xsl:value-of select="ancestor::*[local-name() = 'td']/@align"/></xsl:when>
				<xsl:when test="ancestor::*[local-name() = 'th']/@align"><xsl:value-of select="ancestor::*[local-name() = 'th']/@align"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$default"/></xsl:otherwise>
			</xsl:choose>
		</xsl:attribute>
	</xsl:template><xsl:template name="number-to-words">
		<xsl:param name="number"/>
		<xsl:param name="first"/>
		<xsl:if test="$number != ''">
			<xsl:variable name="words">
								<words>
					<word cardinal="1">One-</word>
					<word ordinal="1">First </word>
					<word cardinal="2">Two-</word>
					<word ordinal="2">Second </word>
					<word cardinal="3">Three-</word>
					<word ordinal="3">Third </word>
					<word cardinal="4">Four-</word>
					<word ordinal="4">Fourth </word>
					<word cardinal="5">Five-</word>
					<word ordinal="5">Fifth </word>
					<word cardinal="6">Six-</word>
					<word ordinal="6">Sixth </word>
					<word cardinal="7">Seven-</word>
					<word ordinal="7">Seventh </word>
					<word cardinal="8">Eight-</word>
					<word ordinal="8">Eighth </word>
					<word cardinal="9">Nine-</word>
					<word ordinal="9">Ninth </word>
					<word ordinal="10">Tenth </word>
					<word ordinal="11">Eleventh </word>
					<word ordinal="12">Twelfth </word>
					<word ordinal="13">Thirteenth </word>
					<word ordinal="14">Fourteenth </word>
					<word ordinal="15">Fifteenth </word>
					<word ordinal="16">Sixteenth </word>
					<word ordinal="17">Seventeenth </word>
					<word ordinal="18">Eighteenth </word>
					<word ordinal="19">Nineteenth </word>
					<word cardinal="20">Twenty-</word>
					<word ordinal="20">Twentieth </word>
					<word cardinal="30">Thirty-</word>
					<word ordinal="30">Thirtieth </word>
					<word cardinal="40">Forty-</word>
					<word ordinal="40">Fortieth </word>
					<word cardinal="50">Fifty-</word>
					<word ordinal="50">Fiftieth </word>
					<word cardinal="60">Sixty-</word>
					<word ordinal="60">Sixtieth </word>
					<word cardinal="70">Seventy-</word>
					<word ordinal="70">Seventieth </word>
					<word cardinal="80">Eighty-</word>
					<word ordinal="80">Eightieth </word>
					<word cardinal="90">Ninety-</word>
					<word ordinal="90">Ninetieth </word>
					<word cardinal="100">Hundred-</word>
					<word ordinal="100">Hundredth </word>
				</words>
			</xsl:variable>

			<xsl:variable name="ordinal" select="xalan:nodeset($words)//word[@ordinal = $number]/text()"/>
			
			<xsl:variable name="value">
				<xsl:choose>
					<xsl:when test="$ordinal != ''">
						<xsl:value-of select="$ordinal"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$number &lt; 100">
								<xsl:variable name="decade" select="concat(substring($number,1,1), '0')"/>
								<xsl:variable name="digit" select="substring($number,2)"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $decade]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@ordinal = $digit]/text()"/>
							</xsl:when>
							<xsl:otherwise>
								<!-- more 100 -->
								<xsl:variable name="hundred" select="substring($number,1,1)"/>
								<xsl:variable name="digits" select="number(substring($number,2))"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = $hundred]/text()"/>
								<xsl:value-of select="xalan:nodeset($words)//word[@cardinal = '100']/text()"/>
								<xsl:call-template name="number-to-words">
									<xsl:with-param name="number" select="$digits"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$first = 'true'">
					<xsl:variable name="value_lc" select="java:toLowerCase(java:java.lang.String.new($value))"/>
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str" select="$value_lc"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template></xsl:stylesheet>