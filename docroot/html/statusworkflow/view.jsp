<%--
/**
Copyright (C) 2002-2013 3fConsulting s.r.l.

This program is free software: you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If
not, see <http://www.gnu.org/licenses/>.
 */ */
--%>

<%@page import="com.liferay.portal.kernel.util.GetterUtil"%>
<%@page import="com.liferay.portal.util.PortalUtil"%>
<%@page
	import="it.tref.liferay.statusworkflow.constant.ViewModeContstant"%>
<%@page
	import="com.liferay.portal.kernel.workflow.WorkflowEngineManagerUtil"%>
<%@page import="com.liferay.portal.util.PortletKeys"%>
<%@page import="com.liferay.portal.kernel.language.LanguageUtil"%>
<%@page import="com.liferay.portal.kernel.util.StringPool"%>
<%@page import="com.liferay.portal.util.PortletCategoryKeys"%>
<%@page import="com.liferay.portal.kernel.portlet.LiferayWindowState"%>
<%@page import="javax.portlet.PortletMode"%>
<%@page import="javax.portlet.PortletRequest"%>
<%@page import="com.liferay.portlet.PortletURLFactoryUtil"%>
<%@page import="com.liferay.portal.service.LayoutLocalServiceUtil"%>
<%@page import="com.liferay.portal.service.GroupLocalServiceUtil"%>
<%@page import="com.liferay.portal.model.GroupConstants"%>
<%@page import="com.liferay.portal.model.Group"%>
<%@page import="javax.portlet.PortletURL"%>

<%@include file="/html/statusworkflow/init.jsp"%>

<%
	String viewMode = preferences.getValue("statusworkflow-viewmode",
			ViewModeContstant.STANDARD);
		 
	String colorCountTasksUserText = preferences.getValue(
			"statusworkflow-color-count-tasks-user-text", null);
 	if (Validator.isNull(colorCountTasksUserText)) {
 		colorCountTasksUserText = ViewModeContstant.COLOR_TEXT_DEFAULT;
	}
 	
	String colorCountTasksUserRolesText = preferences
			.getValue("statusworkflow-color-count-tasks-user-roles-text", null);
	if (Validator.isNull(colorCountTasksUserRolesText)) {
		colorCountTasksUserRolesText = ViewModeContstant.COLOR_TEXT_DEFAULT;
	}
	
	String colorCountTasksUserFull = preferences.getValue(
			"statusworkflow-color-count-tasks-user-full", null);
	if (Validator.isNull(colorCountTasksUserFull)) {
		colorCountTasksUserFull = ViewModeContstant.COLOR_BOX_DEFAULT;
	}
	
	String colorCountTasksUserEmpty = preferences.getValue(
			"statusworkflow-color-count-tasks-user-empty", null);
	if (Validator.isNull(colorCountTasksUserEmpty)) {
		colorCountTasksUserEmpty = ViewModeContstant.COLOR_BOX_DEFAULT;
	}
	
	String colorCountTasksUserRolesFull = preferences
			.getValue("statusworkflow-color-count-tasks-user-roles-full", null);
	if (Validator.isNull(colorCountTasksUserRolesFull)) {
		colorCountTasksUserRolesFull = ViewModeContstant.COLOR_BOX_DEFAULT;
	}
	
	String colorCountTasksUserRolesEmpty = preferences
			.getValue("statusworkflow-color-count-tasks-user-roles-empty", null);
	if (Validator.isNull(colorCountTasksUserRolesEmpty)) {
		colorCountTasksUserRolesEmpty = ViewModeContstant.COLOR_BOX_DEFAULT;
	}

	boolean showTooltip = GetterUtil.getBoolean(preferences.getValue("statusworkflow-show-tooltip",
			null), Boolean.TRUE);
	
	String alignment = preferences
			.getValue("statusworkflow-alignment", ViewModeContstant.LEFT);
	
	// CSS
	String style = StringPool.BLANK;
	if (alignment.equals(ViewModeContstant.CENTER)) {
		style = "display:inline-block;";
	}
	else if (alignment.equals(ViewModeContstant.LEFT)) {
		style = "float:left;";
	}
	else if (alignment.equals(ViewModeContstant.RIGHT)) {
		style = "float:right;";
	}
%>

<style>
	.statusworkflow-dynamic-alignment {
		<%= style %>
	}
</style>

<aui:script>
			
	Liferay.provide(
		window,
		'<portlet:namespace />openLinkToPopup',
		function(currentTarget) {
		
			var A = new AUI();
	
			var controlPanelCategory = A.Lang.trim(currentTarget.attr('data-controlPanelCategory'));
	
			var uri = currentTarget.attr('href');
			var title = currentTarget.attr('title');
	
			if (controlPanelCategory) {
				uri = Liferay.Util.addParams('controlPanelCategory=' + controlPanelCategory, uri) || uri;
			}
			
			Liferay.Util.openWindow(
				{
					dialog: {
						align: Liferay.Util.Window.ALIGN_CENTER,
						width: 960,
						on: {
							close: function(event) {
								<portlet:namespace />refresh();
							}
						}
					},
					title: title,
					uri: uri
				}
			);
		},
		['aui-node', 'event-touch', 'aui-io-request', 'aui-overlay-context', 'liferay-dockbar-underlay', 'node-focusmanager']
	);
		
	Liferay.provide(
		window,
		'<portlet:namespace />loadCountValue',
		function(id, url, elementId, callback, colorText, colorFull, colorEmpty) {
		
			var A = AUI();
			
			var content = A.one('#'+id);
			
			var loading = A.one('#'+id).attr('loading');
			if (!loading || loading == 'false') {
			
				A.io.request(url,
				{
					method: 'POST',
					dataType: 'json',
					on: {
						start: function() {
							content.attr('loading', true);
							var img = "<img width='10px' src='<%=PortalUtil.getPathContext()%>/html/themes/_unstyled/images/application/loading_indicator.gif' />";
							content.html(img);
						},
						complete: function() {
							content.attr('loading', false);
							content.empty();
						},
						success: function() {
					    	var response = this.get('responseData');
					    	content.html(response.count);
					    	if (callback !== undefined) {
					    		callback(elementId, response.count, colorText, colorFull, colorEmpty);
					    	}
					   	}
					}
				});
			}
		},
		['aui-io-request']
	);
	
</aui:script>

<c:choose>
	<c:when test='<%=WorkflowEngineManagerUtil.isDeployed()%>'>

		<%
			Group controlPanelGroup = GroupLocalServiceUtil.getGroup(
							company.getCompanyId(),
							GroupConstants.CONTROL_PANEL);
			long controlPanelPlid = LayoutLocalServiceUtil
					.getDefaultPlid(controlPanelGroup.getGroupId(),
							true);

			PortletURL workflowTaskURL = PortletURLFactoryUtil.create(
					request, PortletKeys.MY_WORKFLOW_TASKS,
					controlPanelPlid, PortletRequest.RENDER_PHASE);
			workflowTaskURL.setParameter("struts_action",
					"/my_workflow_tasks/view");
			workflowTaskURL.setPortletMode(PortletMode.VIEW);
			workflowTaskURL.setWindowState(LiferayWindowState.POP_UP);

			String controlPanelCategory = PortletCategoryKeys.MY;
			String useDialog = StringPool.SPACE + "use-dialog";
		%>

		<div style="width: 100%;">

			<portlet:resourceURL id="countTasksUser" var="countTasksUserURL" />

			<portlet:resourceURL id="countTasksUserRoles"
				var="countTaksUserRolesURL" />

			<c:choose>
				<c:when
					test="<%=viewMode.equals(ViewModeContstant.STANDARD)%>">

					<aui:layout>
						<aui:column>
							<div class="lfr-panel-titlebar">
								<div class="lfr-panel-title">
									<span> <liferay-ui:message key="javax.portlet.title.153" /></span>
								</div>
							</div>
						</aui:column>
						<aui:column>
							<aui:a id="workflowTask"
								data-controlPanelCategory="<%=controlPanelCategory%>"
								href="<%=workflowTaskURL.toString()%>"
								title="javax.portlet.title.153">
								<img src='<%=PortalUtil.getPathContext() + "/html/icons/my_workflow_tasks.png"%>' />
							</aui:a>
						</aui:column>
					</aui:layout>

					<br />

					<aui:layout>
						<aui:column first="true">
							<%=LanguageUtil.get(pageContext,
											"assigned-to-me")
											+ StringPool.SPACE
											+ StringPool.COLON
											+ StringPool.SPACE%>
							<span id='<portlet:namespace/>countTasksUser'
								class="statusworkflow-portlet-count-tasks"></span>
						</aui:column>
						<aui:column last="true">&nbsp;</aui:column>
					</aui:layout>

					<aui:layout>
						<aui:column first="true">
							<%=LanguageUtil.get(pageContext,
											"assigned-to-my-roles")
											+ StringPool.SPACE
											+ StringPool.COLON
											+ StringPool.SPACE%>
							<span id='<portlet:namespace/>countTaksUserRoles'
								class="statusworkflow-portlet-count-tasks"></span>
						</aui:column>
						<aui:column last="true">&nbsp;</aui:column>
					</aui:layout>

					<aui:script use="aui-base">
			
						A.one('#<portlet:namespace />countTasksUser').on('click', function(event) {
							<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', '<%=countTasksUserURL%>');
						});
					
						A.one('#<portlet:namespace />countTaksUserRoles').on('click', function(event) {
							<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles', '<%=countTaksUserRolesURL%>');
						});
						
						A.one('#<portlet:namespace />workflowTask').on('click', function(event) {
							event.preventDefault();
							<portlet:namespace />openLinkToPopup(event.currentTarget);
						});
						
						AUI().ready('event', 'node', function(A){
							<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', 
								'<%=countTasksUserURL%>');
								
							<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles',
								 '<%=countTaksUserRolesURL%>');
						});
						
						Liferay.provide(
							window,
							'<portlet:namespace />refresh',
							function() {
								var A = AUI();
								<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', 
									'<%=countTasksUserURL%>');
								
								<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles',
								 	'<%=countTaksUserRolesURL%>');
							},
							['aui-base']
						);
						
					</aui:script>

				</c:when>
				<c:when
					test="<%=viewMode.equals(ViewModeContstant.COMPACT)%>">

					<aui:layout>
						<aui:column first="true">
							<aui:a id="workflowTask"
								data-controlPanelCategory="<%=controlPanelCategory%>"
								href="<%=workflowTaskURL.toString()%>"
								title="javax.portlet.title.153">
								<img src='<%=PortalUtil.getPathContext() +"/html/icons/my_workflow_tasks.png"%>' />
							</aui:a>
						</aui:column>
						<aui:column>
							<div>
								<%=LanguageUtil.get(pageContext,
											"assigned-to-me")
											+ StringPool.SPACE
											+ StringPool.COLON
											+ StringPool.SPACE%>
								<span id='<portlet:namespace/>countTasksUser'
									class="statusworkflow-portlet-count-tasks"></span>
							</div>
							<div>
								<%=LanguageUtil.get(pageContext,
											"assigned-to-my-roles")
											+ StringPool.SPACE
											+ StringPool.COLON
											+ StringPool.SPACE%>
								<span id='<portlet:namespace/>countTaksUserRoles'
									class="statusworkflow-portlet-count-tasks"></span>
							</div>
						</aui:column>
					</aui:layout>

					<aui:script use="aui-base">
			
						A.one('#<portlet:namespace />countTasksUser').on('click', function(event) {
							<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', '<%=countTasksUserURL%>');
						});
					
						A.one('#<portlet:namespace />countTaksUserRoles').on('click', function(event) {
							<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles', '<%=countTaksUserRolesURL%>');
						});
						
						A.one('#<portlet:namespace />workflowTask').on('click', function(event) {
							event.preventDefault();
							<portlet:namespace />openLinkToPopup(event.currentTarget);
						});
						
						AUI().ready('event', 'node', function(A){
							
							<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', 
								'<%=countTasksUserURL%>');
								
							<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles',
								 '<%=countTaksUserRolesURL%>');
						});
						
						Liferay.provide(
							window,
							'<portlet:namespace />refresh',
							function() {
								var A = AUI();
								<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', 
									'<%=countTasksUserURL%>');
								
								<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles',
									 '<%=countTaksUserRolesURL%>');
							},
							['aui-base']
						);
						
					</aui:script>

				</c:when>
				<c:when test="<%=viewMode.equals(ViewModeContstant.MODERN)%>">

					<div class="aui-helper-hidden">
						<aui:a id="workflowTask"
							data-controlPanelCategory="<%=controlPanelCategory%>"
							href="<%=workflowTaskURL.toString()%>"
							title="javax.portlet.title.153">
							<img src='<%=PortalUtil.getPathContext() +"/html/icons/my_workflow_tasks.png"%>' />
						</aui:a>
					</div>

					<div class="statusworkflow-portlet-container-tasks">

						<div class="statusworkflow-portlet-box-tasks statusworkflow-dynamic-alignment"
							id='<portlet:namespace/>countTasksUserContainer'>

							<span id='<portlet:namespace/>countTasksUser'
								class="statusworkflow-portlet-count-tasks"></span>
						</div>

						<div class="statusworkflow-portlet-box-tasks statusworkflow-dynamic-alignment"
							id='<portlet:namespace/>countTaksUserRolesContainer'>

							<span id='<portlet:namespace/>countTaksUserRoles'
								class="statusworkflow-portlet-count-tasks"></span>
						</div>

					</div>

					<br />

					<c:if test="<%=showTooltip%>">

						<aui:script use="aui-tooltip">
								var t1 = new A.Tooltip({
									trigger: '#<portlet:namespace />countTasksUser',
									align: { points: [ 'tc', 'bc' ] },
									hideDelay: 0,
									bodyContent: '<%=LanguageUtil
											.get(pageContext,
													"label-statusworkflow-viewmode-compact-count-tasks-user")%>'
								})
								.render();
								var t2 = new A.Tooltip({
									trigger: '#<portlet:namespace />countTaksUserRoles',
									align: { points: [ 'tc', 'bc' ] },
									hideDelay: 0,
									bodyContent: '<%=LanguageUtil
											.get(pageContext,
													"label-statusworkflow-viewmode-compact-count-tasks-user-roles")%>'
								})
								.render();
						</aui:script>

					</c:if>

					<aui:script use="aui-base">
					
						Liferay.provide(
							window,
							'<portlet:namespace />successCallback',
							function(id, count, colorText, colorFull, colorEmpty) {
								var content = A.one('#'+id);
								content.setStyle('color', colorText);
								if (count > 0) {
							    	content.setStyle('backgroundColor', colorFull);
							    	content.setStyle('border', '1px solid '+colorFull);
							    }
							    else {
							  		content.setStyle('backgroundColor', colorEmpty);
							    	content.setStyle('border', '1px solid '+colorEmpty);
							    }
							},
							['aui-base']
						);
			
						A.one('#<portlet:namespace />countTasksUserContainer').on('dblclick', function(event) {
							var currentTarget = A.one('#<portlet:namespace />workflowTask');
							<portlet:namespace />openLinkToPopup(currentTarget);
						});
					
						A.one('#<portlet:namespace />countTaksUserRolesContainer').on('dblclick', function(event) {
							var currentTarget = A.one('#<portlet:namespace />workflowTask');
							<portlet:namespace />openLinkToPopup(currentTarget);
						});
						
						A.one('#<portlet:namespace />countTasksUserContainer').on('click', function(event) {
							<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', '<%=countTasksUserURL%>',
								'<portlet:namespace />countTasksUserContainer', <portlet:namespace />successCallback, '<%=colorCountTasksUserText %>', '<%=colorCountTasksUserFull%>', '<%=colorCountTasksUserEmpty%>');
						});
					
						A.one('#<portlet:namespace />countTaksUserRolesContainer').on('click', function(event) {
							<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles', '<%=countTaksUserRolesURL%>',
								'<portlet:namespace />countTaksUserRolesContainer', <portlet:namespace />successCallback, '<%=colorCountTasksUserRolesText %>', '<%=colorCountTasksUserRolesFull%>', '<%=colorCountTasksUserRolesEmpty%>');
						});
						
						AUI().ready('event', 'node', function(A){
							<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', '<%=countTasksUserURL%>',
								'<portlet:namespace />countTasksUserContainer', <portlet:namespace />successCallback, '<%=colorCountTasksUserText %>', '<%=colorCountTasksUserFull%>', '<%=colorCountTasksUserEmpty%>');
								
							<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles', '<%=countTaksUserRolesURL%>',
								'<portlet:namespace />countTaksUserRolesContainer', <portlet:namespace />successCallback, '<%=colorCountTasksUserRolesText %>', '<%=colorCountTasksUserRolesFull%>', '<%=colorCountTasksUserRolesEmpty%>');
						});
						
						Liferay.provide(
							window,
							'<portlet:namespace />refresh',
							function() {
								var A = AUI();
								<portlet:namespace />loadCountValue('<portlet:namespace />countTasksUser', '<%=countTasksUserURL%>',
									'<portlet:namespace />countTasksUserContainer', <portlet:namespace />successCallback, '<%=colorCountTasksUserText %>', '<%=colorCountTasksUserFull%>', '<%=colorCountTasksUserEmpty%>');
														
								<portlet:namespace />loadCountValue('<portlet:namespace />countTaksUserRoles', '<%=countTaksUserRolesURL%>',
									'<portlet:namespace />countTaksUserRolesContainer', <portlet:namespace />successCallback, '<%=colorCountTasksUserRolesText %>', '<%=colorCountTasksUserRolesFull%>', '<%=colorCountTasksUserRolesEmpty%>');
							},
							['aui-base']
						);
						
					</aui:script>

				</c:when>
			</c:choose>

		</div>

	</c:when>
	<c:otherwise>

		<aui:layout>
			<aui:column>
				<div class="lfr-panel-titlebar">
					<div class="lfr-panel-title">
						<span> <liferay-ui:message key="javax.portlet.title.153" /></span>
					</div>
				</div>
			</aui:column>
			<aui:column>
				&nbsp;
			</aui:column>
		</aui:layout>

		<br />

		<div class="portlet-msg-info">
			<liferay-ui:message key="no-workflow-engine-is-deployed" />
		</div>

	</c:otherwise>
</c:choose>


